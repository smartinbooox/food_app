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

