# 🚴 Rider Dashboard Backend Setup

This document explains how to connect the rider dashboard to your Supabase backend.

## 📋 Prerequisites

1. **Supabase Project**: You need a Supabase project set up
2. **Database Access**: Access to your Supabase SQL editor
3. **Flutter App**: Your Mappia app with Supabase Flutter SDK

## 🗄️ Database Setup

### Step 1: Run the SQL Script

1. Go to your Supabase Dashboard
2. Navigate to **SQL Editor**
3. Copy and paste the entire content from `database_schema.sql`
4. Click **Run** to execute the script

This will create:
- `riders` table - Stores rider profiles
- `orders` table - Stores delivery orders
- `order_items` table - Stores items in each order
- `rider_earnings` table - Stores rider earnings
- Indexes for better performance
- Row Level Security (RLS) policies
- Helper functions

### Step 2: Verify Tables Created

Check that these tables exist in your **Table Editor**:
- `riders`
- `orders` 
- `order_items`
- `rider_earnings`

## 🔐 Row Level Security (RLS)

The setup includes RLS policies that ensure:
- Riders can only see their own profile and earnings
- Riders can only view orders assigned to them
- Data is properly secured

## 🚀 How It Works

### 1. **Rider Registration Flow**
```
User Login → Check Role → Check Profile → Setup Screen → Dashboard
```

### 2. **Dashboard Data Flow**
```
Dashboard Loads → Fetch Profile → Fetch Earnings → Fetch Orders → Display
```

### 3. **Order Management Flow**
```
Available Orders → Accept Order → Update Status → Complete Delivery → Record Earnings
```

## 📱 Key Features

### **Dashboard Features:**
- ✅ Real-time earnings display
- ✅ Online/Offline status toggle
- ✅ Available orders count
- ✅ Recent transactions
- ✅ Pull-to-refresh functionality

### **Order Management:**
- ✅ View available orders
- ✅ Accept orders
- ✅ Complete deliveries
- ✅ Track earnings and tips

### **Profile Management:**
- ✅ Vehicle information
- ✅ License details
- ✅ Rating and level system

## 🛠️ API Endpoints (via RiderService)

### **Profile Management:**
```dart
// Get rider profile
await riderService.getRiderProfile()

// Create/update profile
await riderService.createRiderProfile(
  vehicleType: 'Motorcycle',
  vehicleNumber: 'ABC-1234',
  licenseNumber: 'L123456789'
)
```

### **Status Management:**
```dart
// Update online status
await riderService.updateOnlineStatus(true)
```

### **Dashboard Data:**
```dart
// Get dashboard data
await riderService.getDashboardData()

// Get recent transactions
await riderService.getRecentTransactions()
```

### **Order Management:**
```dart
// Get available orders
await riderService.getAvailableOrders()

// Accept an order
await riderService.acceptOrder(orderId)

// Complete delivery
await riderService.completeDelivery(orderId, tipAmount)
```

## 🧪 Testing the Setup

### 1. **Create a Test Rider User**
```sql
INSERT INTO users (id, email, name, role, password) 
VALUES (
  gen_random_uuid(), 
  'rider@test.com', 
  'Test Rider', 
  'rider', 
  'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3' -- password: 123
);
```

### 2. **Create a Test Rider Profile**
```sql
INSERT INTO riders (user_id, vehicle_type, vehicle_number, license_number, is_online, level, rating)
SELECT 
  u.id,
  'Motorcycle',
  'TEST-1234',
  'L123456789',
  false,
  1,
  0.0
FROM users u 
WHERE u.email = 'rider@test.com';
```

### 3. **Create Test Orders**
```sql
-- Create test orders (you'll need existing users for customer and merchant)
INSERT INTO orders (customer_id, merchant_id, status, total_amount, delivery_fee, pickup_address, delivery_address, estimated_distance)
VALUES 
  ('customer-user-id', 'merchant-user-id', 'ready', 25.50, 5.00, 'Restaurant Address', 'Customer Address', 2.5),
  ('customer-user-id', 'merchant-user-id', 'ready', 18.75, 4.50, 'Restaurant Address', 'Customer Address', 1.8);
```

## 🔧 Troubleshooting

### **Common Issues:**

1. **"User not found" error**
   - Check if the user exists in the `users` table
   - Verify the email and password are correct

2. **"Permission denied" error**
   - Check RLS policies are enabled
   - Verify the user has the correct role

3. **"Profile not found" error**
   - Rider needs to complete profile setup first
   - Check if `riders` table has the user's profile

4. **"No available orders"**
   - Check if orders exist with status 'ready'
   - Verify orders don't have a rider assigned

### **Debug Queries:**
```sql
-- Check if rider profile exists
SELECT * FROM riders WHERE user_id = 'your-user-id';

-- Check available orders
SELECT * FROM orders WHERE status = 'ready' AND rider_id IS NULL;

-- Check rider earnings
SELECT * FROM rider_earnings WHERE rider_id = 'your-rider-id';
```

## 📈 Next Steps

1. **Add Real-time Updates**: Use Supabase Realtime for live order notifications
2. **Location Tracking**: Implement GPS location updates
3. **Push Notifications**: Add order alerts
4. **Payment Integration**: Connect with payment gateways
5. **Analytics**: Add delivery statistics and reports

## 🆘 Support

If you encounter issues:
1. Check the Supabase logs in your dashboard
2. Verify all SQL scripts ran successfully
3. Test with the provided test data
4. Check Flutter console for error messages

---

**Happy Coding! 🚀** 