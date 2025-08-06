# Customer Order Testing Guide

## 🧪 Testing Complete Order Flow: Customer → Restaurant

This guide will help you test the complete order flow from customer placing an order to restaurant receiving it.

### 📋 Prerequisites

1. **Customer Account**: You have a customer account logged in
2. **Restaurant Account**: You have a restaurant account (different device/browser)
3. **Food Items**: Restaurant has food items in their menu
4. **Database Access**: Access to your Supabase database

### 🔄 Step-by-Step Testing Process

#### **Step 1: Prepare Restaurant Dashboard**
1. **Open restaurant dashboard** in a separate device/browser
2. **Log in with restaurant account**
3. **Verify restaurant has food items** in the menu
4. **Note the restaurant's user ID** (check terminal logs)

#### **Step 2: Place Order as Customer**
1. **Log in with customer account** in your main device
2. **Browse the menu** and add items to cart
3. **Go to checkout** and fill in:
   - Delivery address
   - Select "Cash on Delivery"
4. **Place the order**

#### **Step 3: Monitor Order Creation**
Watch the terminal logs for these debug messages:
```
DEBUG: Creating order...
DEBUG: Total amount: [amount]
DEBUG: Cart items: [count]
DEBUG: Merchant orders: [count]
DEBUG: Creating order for merchant [merchant_id], total: [amount]
DEBUG: Order created: [order_id]
DEBUG: Order items created for order [order_id]
DEBUG: All orders created successfully
```

#### **Step 4: Check Restaurant Dashboard**
1. **Go to restaurant dashboard**
2. **Look for new orders** in the "Incoming Orders" section
3. **Check order details**:
   - Customer name
   - Order items
   - Total amount
   - Delivery address
   - Status: "PENDING"

#### **Step 5: Test Order Status Updates**
1. **Tap on the order** in restaurant dashboard
2. **Update status**: "Start Preparing" → "Mark as Ready" → "Complete Order"
3. **Verify status changes** are reflected

### 🔍 What to Look For

#### **✅ Success Indicators:**
- Order appears in restaurant dashboard within 30 seconds
- Order details are complete and accurate
- Status updates work properly
- Customer receives success message
- Cart is cleared after successful order

#### **❌ Failure Indicators:**
- No orders appear in restaurant dashboard
- Order creation fails with error message
- Order details are missing or incorrect
- Status updates don't work
- App crashes during order placement

### 🛠️ Debugging Tips

#### **1. Check Customer Authentication**
If order creation fails, check if customer is properly authenticated:
```sql
-- Check if customer exists
SELECT id, name, email, role FROM users WHERE role = 'customer';
```

#### **2. Verify Restaurant Data**
Ensure restaurant has food items:
```sql
-- Check restaurant's food items
SELECT id, name, price, created_by FROM foods WHERE created_by = 'RESTAURANT_ID';
```

#### **3. Check Order Creation**
If orders don't appear, verify they were created:
```sql
-- Check recent orders
SELECT 
  o.id,
  o.status,
  o.total_amount,
  o.created_at,
  u.name as customer_name,
  m.name as merchant_name
FROM orders o
JOIN users u ON o.customer_id = u.id
JOIN users m ON o.merchant_id = m.id
ORDER BY o.created_at DESC
LIMIT 10;
```

#### **4. Common Issues & Solutions**

**Issue**: "No user ID found" in debug logs
- **Solution**: Check if customer is properly logged in with Supabase Auth

**Issue**: "Error creating order" in debug logs
- **Solution**: Check RLS policies for `orders` and `order_items` tables

**Issue**: Orders created but not visible in restaurant dashboard
- **Solution**: Verify `merchant_id` in orders matches restaurant's user ID

**Issue**: Order items missing
- **Solution**: Check if `food_id` in `order_items` references valid food items

### 📱 Testing Checklist

- [ ] Customer can add items to cart
- [ ] Customer can proceed to checkout
- [ ] Customer can enter delivery address
- [ ] Customer can select "Cash on Delivery"
- [ ] Order is created successfully (check debug logs)
- [ ] Order appears in restaurant dashboard
- [ ] Order details are complete and accurate
- [ ] Restaurant can update order status
- [ ] Customer receives success message
- [ ] Cart is cleared after order

### 🎯 Expected Flow

1. **Customer**: Add items → Checkout → Place order
2. **System**: Create order in database → Send to restaurant
3. **Restaurant**: Receive order → Update status → Complete order
4. **Customer**: Receive confirmation → Order delivered

### 🔧 Advanced Testing

#### **Test Multiple Items from Different Restaurants**
1. Add items from multiple restaurants to cart
2. Place order
3. Verify separate orders are created for each restaurant

#### **Test Order Status Flow**
1. Place order as customer
2. As restaurant: Pending → Preparing → Ready → Completed
3. Verify each status change is saved

#### **Test Real-time Updates**
1. Place order as customer
2. Watch restaurant dashboard for automatic refresh (every 30 seconds)
3. Verify order appears without manual refresh

---

**Need Help?** Check the debug logs in your terminal for detailed error messages! 