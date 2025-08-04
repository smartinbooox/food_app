# Restaurant Order Testing Guide

## 🧪 Testing Restaurant Order Reception

This guide will help you test if your restaurant can receive orders from customers.

### 📋 Prerequisites

1. **Restaurant Account**: Make sure you have a restaurant account logged in
2. **Food Items**: Ensure your restaurant has some food items in the menu
3. **Database Access**: Access to your Supabase database

### 🔍 Step 1: Find Your Restaurant Information

First, you need to find your restaurant's user ID and food item IDs.

#### In Supabase SQL Editor, run:

```sql
-- Find your restaurant user ID
SELECT id, name, email, role FROM users WHERE role = 'restaurant';
```

**Note down your restaurant's user ID** (it will look like: `12345678-1234-1234-1234-123456789abc`)

```sql
-- Find your restaurant's food items (replace YOUR_RESTAURANT_ID with the ID from above)
SELECT id, name, price FROM foods WHERE created_by = 'YOUR_RESTAURANT_ID';
```

**Note down 2-3 food item IDs** for testing.

### 🧪 Step 2: Create Test Orders

Run this SQL script in your Supabase SQL Editor (replace the placeholders):

```sql
-- Create a test customer
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

-- Create test order 1 (pending status)
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

-- Create order items for test order 1
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

-- Create test order 2 (preparing status)
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

-- Create order items for test order 2
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
```

### 📱 Step 3: Test in Your App

1. **Open your restaurant dashboard** in the app
2. **Check if orders appear** in the orders list
3. **Test order status updates**:
   - Tap on a pending order
   - Change status from "pending" → "preparing" → "ready" → "completed"
4. **Verify order details**:
   - Customer name
   - Order items
   - Total amount
   - Delivery address

### 🔧 Step 4: Debugging

If orders don't appear, check:

#### 1. Restaurant Dashboard Debug Logs
Look for these debug messages in your terminal:
```
DEBUG: Fetching orders for restaurant: YOUR_RESTAURANT_ID
DEBUG: Query response: [order data]
DEBUG: Processed orders: 2
```

#### 2. Database Verification
Run this query to verify orders exist:
```sql
-- Check if orders exist for your restaurant
SELECT 
  o.id,
  o.status,
  o.total_amount,
  o.created_at,
  u.name as customer_name
FROM orders o
JOIN users u ON o.customer_id = u.id
WHERE o.merchant_id = 'YOUR_RESTAURANT_ID'
ORDER BY o.created_at DESC;
```

#### 3. Common Issues

**Issue**: "No orders found"
- **Solution**: Check if `merchant_id` in orders matches your restaurant's user ID

**Issue**: "Orders appear but no items"
- **Solution**: Verify `order_items` table has correct `food_id` values

**Issue**: "Orders don't update status"
- **Solution**: Check RLS policies for the `orders` table

### 🎯 Expected Results

✅ **Success Indicators**:
- Orders appear in restaurant dashboard
- Order details show correctly (customer, items, amount)
- Status updates work (pending → preparing → ready → completed)
- Orders refresh automatically every 30 seconds

❌ **Failure Indicators**:
- No orders shown
- Orders appear but with missing data
- Status updates don't work
- App crashes when viewing orders

### 🧹 Cleanup

After testing, you can clean up test data:

```sql
-- Remove test orders
DELETE FROM order_items WHERE order_id IN ('test-order-123', 'test-order-456');
DELETE FROM orders WHERE id IN ('test-order-123', 'test-order-456');
DELETE FROM users WHERE id = 'test-customer-123';
```

### 📞 Next Steps

If testing is successful:
1. ✅ Restaurant can receive orders
2. ✅ Order management works
3. ✅ Status updates function properly

If testing fails:
1. 🔧 Check database schema
2. 🔧 Verify RLS policies
3. 🔧 Review order fetching logic
4. 🔧 Check user authentication

---

**Need Help?** Check the debug logs in your terminal for detailed error messages! 