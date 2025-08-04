-- Unified Database Schema for Mappia App
-- ======================================
-- This file contains all tables needed for the app.
-- Import this file into Supabase or your SQL DB to set up the schema.

-- =====================
-- USERS TABLE
-- =====================
CREATE TABLE IF NOT EXISTS users (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL, -- Store hashed passwords only!
    name TEXT, -- Changed from full_name to name
    contact TEXT,
    role TEXT NOT NULL DEFAULT 'customer',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc', now())
);

-- =====================
-- DEFAULT ADMIN USER
-- =====================
INSERT INTO users (id, email, password, name, contact, role, created_at)
VALUES (
  gen_random_uuid(),
  'admin@mappia.com',
  'b2eec2b7a2e7c2e6e6e3e0e2e2e7e2e6e2e7e2e6e2e7e2e6e2e7e2e6e2e7e2e6e2e7e2e6',
  'Admin',
  '',
  'admin',
  timezone('utc', now())
); 

-- =====================
-- FOODS TABLE
-- =====================
CREATE TABLE IF NOT EXISTS foods (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC(10,2) NOT NULL,
    image_url TEXT,
    created_by uuid REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc', now())
);

-- =====================
-- IMAGES TABLE
-- =====================
CREATE TABLE IF NOT EXISTS images (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    url TEXT NOT NULL,
    uploaded_by uuid REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc', now())
);

-- =====================
-- (Add more tables below as needed, e.g., orders, products, etc.)

-- Rider-related tables
CREATE TABLE IF NOT EXISTS riders (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    vehicle_type VARCHAR(50) NOT NULL,
    vehicle_number VARCHAR(20),
    license_number VARCHAR(50),
    is_online BOOLEAN DEFAULT false,
    current_location POINT,
    rating DECIMAL(3,2) DEFAULT 0.0,
    total_deliveries INTEGER DEFAULT 0,
    total_earnings DECIMAL(10,2) DEFAULT 0.0,
    level INTEGER DEFAULT 1,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS orders (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    customer_id UUID REFERENCES users(id) ON DELETE CASCADE,
    rider_id UUID REFERENCES riders(id) ON DELETE SET NULL,
    merchant_id UUID REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(50) DEFAULT 'pending', -- pending, accepted, preparing, ready, picked_up, delivered, cancelled
    total_amount DECIMAL(10,2) NOT NULL,
    delivery_fee DECIMAL(5,2) DEFAULT 0.0,
    tip_amount DECIMAL(5,2) DEFAULT 0.0,
    pickup_address TEXT NOT NULL,
    delivery_address TEXT NOT NULL,
    estimated_distance DECIMAL(8,2), -- in miles
    estimated_time INTEGER, -- in minutes
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS order_items (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    food_id UUID REFERENCES foods(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(8,2) NOT NULL,
    add_ons JSONB DEFAULT '[]',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================
-- CART TABLE
-- =====================
CREATE TABLE IF NOT EXISTS cart_items (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    customer_id UUID REFERENCES users(id) ON DELETE CASCADE,
    food_id UUID REFERENCES foods(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL DEFAULT 1,
    add_ons JSONB DEFAULT '[]',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(customer_id, food_id, add_ons) -- Prevent duplicate items with same add-ons
);

-- Index for cart queries
CREATE INDEX IF NOT EXISTS idx_cart_items_customer_id ON cart_items(customer_id);

-- =====================
-- RIDER EARNINGS TABLE
-- =====================
CREATE TABLE IF NOT EXISTS rider_earnings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    rider_id UUID REFERENCES riders(id) ON DELETE CASCADE,
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    base_earnings DECIMAL(8,2) NOT NULL,
    tip_amount DECIMAL(5,2) DEFAULT 0.0,
    total_earnings DECIMAL(8,2) NOT NULL,
    delivery_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for better performance
CREATE INDEX IF NOT EXISTS idx_riders_user_id ON riders(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_rider_id ON orders(rider_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON orders(created_at);
CREATE INDEX IF NOT EXISTS idx_rider_earnings_rider_id ON rider_earnings(rider_id);
CREATE INDEX IF NOT EXISTS idx_rider_earnings_date ON rider_earnings(delivery_date);

-- RLS Policies for riders table
ALTER TABLE riders ENABLE ROW LEVEL SECURITY;

-- Allow all operations for now (since we're using custom auth)
-- In production, you might want to add more specific policies
CREATE POLICY "Allow all rider operations" ON riders
    FOR ALL USING (true);

-- RLS Policies for orders table
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- Allow all operations for now (since we're using custom auth)
CREATE POLICY "Allow all order operations" ON orders
    FOR ALL USING (true);

-- RLS Policies for rider_earnings table
ALTER TABLE rider_earnings ENABLE ROW LEVEL SECURITY;

-- Allow all operations for now (since we're using custom auth)
CREATE POLICY "Allow all rider earnings operations" ON rider_earnings
    FOR ALL USING (true);

-- RLS Policies for foods table
ALTER TABLE foods ENABLE ROW LEVEL SECURITY;

-- Allow all operations for now (since we're using custom auth)
CREATE POLICY "Allow all food operations" ON foods
    FOR ALL USING (true);

-- Functions for common operations
CREATE OR REPLACE FUNCTION update_rider_online_status(
    rider_user_id UUID,
    is_online_status BOOLEAN
) RETURNS void AS $$
BEGIN
    UPDATE riders 
    SET is_online = is_online_status, updated_at = NOW()
    WHERE user_id = rider_user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION get_rider_dashboard_data(
    rider_user_id UUID,
    target_date DATE DEFAULT CURRENT_DATE
) RETURNS TABLE (
    today_earnings DECIMAL(10,2),
    total_orders INTEGER,
    available_orders INTEGER,
    rider_level INTEGER,
    rider_rating DECIMAL(3,2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COALESCE(SUM(re.total_earnings), 0) as today_earnings,
        COUNT(DISTINCT re.order_id) as total_orders,
        (SELECT COUNT(*) FROM orders WHERE status = 'ready' AND rider_id IS NULL) as available_orders,
        r.level as rider_level,
        r.rating as rider_rating
    FROM riders r
    LEFT JOIN rider_earnings re ON r.id = re.rider_id AND re.delivery_date = target_date
    WHERE r.user_id = rider_user_id
    GROUP BY r.level, r.rating;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

 