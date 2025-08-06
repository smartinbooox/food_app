-- Add Beverages category to the existing categories table
-- Run this script in your Supabase SQL editor

-- Add Beverages category if it doesn't exist
INSERT INTO categories (name) VALUES ('Beverages') ON CONFLICT (name) DO NOTHING; 