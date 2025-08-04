-- Add Cart Table Migration
-- Run this script in your Supabase SQL editor to add cart functionality

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

-- Add RLS (Row Level Security) policies for cart items
ALTER TABLE cart_items ENABLE ROW LEVEL SECURITY;

-- Policy: Allow all operations for authenticated users (custom auth system)
-- This allows the app to manage cart items for any user
CREATE POLICY "Allow all cart operations" ON cart_items
    FOR ALL USING (true) WITH CHECK (true);

-- Alternative: If you want more restrictive policies, you can use these instead:
-- CREATE POLICY "Users can view own cart items" ON cart_items
--     FOR SELECT USING (true);
-- 
-- CREATE POLICY "Users can insert own cart items" ON cart_items
--     FOR INSERT WITH CHECK (true);
-- 
-- CREATE POLICY "Users can update own cart items" ON cart_items
--     FOR UPDATE USING (true);
-- 
-- CREATE POLICY "Users can delete own cart items" ON cart_items
--     FOR DELETE USING (true); 