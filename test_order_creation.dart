import 'package:supabase_flutter/supabase_flutter.dart';

// Test script to create orders for restaurant testing
// Run this in your Supabase SQL editor or use it as a reference

/*
-- Test Order Creation Script
-- Run this in your Supabase SQL Editor to create test orders

-- First, let's create a test customer
INSERT INTO users (id, email, password, name, contact, role, created_at)
VALUES (
  'test-customer-123',
  'testcustomer@example.com',
  'hashedpassword123',
  'Test Customer',
  '+1234567890',
  'customer',
  NOW()
);

-- Create a test order for your restaurant
-- Replace 'YOUR_RESTAURANT_ID' with your actual restaurant user ID
INSERT INTO orders (
  id,
  customer_id,
  merchant_id,
  status,
  total_amount,
  delivery_fee,
  tip_amount,
  pickup_address,
  delivery_address,
  estimated_distance,
  estimated_time,
  created_at
)
VALUES (
  'test-order-123',
  'test-customer-123',
  'YOUR_RESTAURANT_ID', -- Replace with your restaurant's user ID
  'pending',
  25.50,
  3.00,
  2.00,
  '123 Restaurant Street, City',
  '456 Customer Home, City',
  2.5,
  15,
  NOW()
);

-- Create order items for the test order
-- Replace 'FOOD_ITEM_ID' with actual food IDs from your restaurant
INSERT INTO order_items (
  id,
  order_id,
  food_id,
  quantity,
  unit_price,
  add_ons,
  created_at
)
VALUES 
  ('test-item-1', 'test-order-123', 'FOOD_ITEM_ID_1', 2, 12.75, '[]', NOW()),
  ('test-item-2', 'test-order-123', 'FOOD_ITEM_ID_2', 1, 10.00, '[]', NOW());

-- Create another test order with different status
INSERT INTO orders (
  id,
  customer_id,
  merchant_id,
  status,
  total_amount,
  delivery_fee,
  tip_amount,
  pickup_address,
  delivery_address,
  estimated_distance,
  estimated_time,
  created_at
)
VALUES (
  'test-order-456',
  'test-customer-123',
  'YOUR_RESTAURANT_ID', -- Replace with your restaurant's user ID
  'preparing',
  18.00,
  2.50,
  1.50,
  '123 Restaurant Street, City',
  '789 Another Address, City',
  1.8,
  12,
  NOW()
);

-- Create order items for the second test order
INSERT INTO order_items (
  id,
  order_id,
  food_id,
  quantity,
  unit_price,
  add_ons,
  created_at
)
VALUES 
  ('test-item-3', 'test-order-456', 'FOOD_ITEM_ID_3', 1, 18.00, '[]', NOW());
*/

// To find your restaurant's user ID and food IDs, run these queries:

/*
-- Find your restaurant user ID
SELECT id, name, email, role FROM users WHERE role = 'restaurant';

-- Find your restaurant's food items
SELECT id, name, price FROM foods WHERE created_by = 'YOUR_RESTAURANT_ID';
*/ 