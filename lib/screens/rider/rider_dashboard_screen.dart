import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../services/rider_service.dart';

class RiderDashboardScreen extends StatefulWidget {
  const RiderDashboardScreen({super.key});

  @override
  State<RiderDashboardScreen> createState() => _RiderDashboardScreenState();
}

class _RiderDashboardScreenState extends State<RiderDashboardScreen> {
  final RiderService _riderService = RiderService();
  
  bool _isOnline = false;
  int _currentIndex = 0;
  bool _isLoading = true;
  
  // Real data from backend
  String _riderName = "Partner";
  String _riderLevel = "Level 1";
  double _todayEarnings = 0.0;
  int _availableOrders = 0;
  List<Map<String, dynamic>> _recentTransactions = [];
  Map<String, dynamic>? _riderProfile;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    
    try {
      // Load rider profile
      _riderProfile = await _riderService.getRiderProfile();
      
      // Load dashboard data
      final dashboardData = await _riderService.getDashboardData();
      
      // Load recent transactions
      final transactions = await _riderService.getRecentTransactions(limit: 5);
      
      if (mounted) {
        setState(() {
          _isOnline = _riderProfile?['is_online'] ?? false;
          _riderName = _riderProfile?['vehicle_type'] ?? "Partner";
          _riderLevel = "Level ${dashboardData?['rider_level'] ?? 1}";
          _todayEarnings = (dashboardData?['today_earnings'] ?? 0.0).toDouble();
          _availableOrders = dashboardData?['available_orders'] ?? 0;
          _recentTransactions = transactions;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading dashboard data: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _toggleOnlineStatus(bool value) async {
    print('Toggling online status to: $value');
    setState(() => _isOnline = value);
    
    try {
      final success = await _riderService.updateOnlineStatus(value);
      print('Update status result: $success');
      
      if (!success && mounted) {
        setState(() => _isOnline = !value); // Revert if failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update status'), backgroundColor: Colors.red),
        );
      } else if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(value ? 'You are now online' : 'You are now offline'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error in _toggleOnlineStatus: $e');
      print('Error details: ${e.toString()}');
      
      if (mounted) {
        setState(() => _isOnline = !value); // Revert if failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating status: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAvailableOrders() async {
    try {
      final orders = await _riderService.getAvailableOrders();
      if (mounted) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AvailableOrdersScreen(orders: orders),
          ),
        );
        
        // Refresh dashboard data when returning from available orders
        if (result == true) {
          _loadDashboardData();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading orders'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppConstants.backgroundColor,
        body: const Center(
          child: CircularProgressIndicator(color: AppConstants.primaryColor),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadDashboardData,
                color: AppConstants.primaryColor,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatusToggle(),
                      const SizedBox(height: 16),
                      _buildOrderAlert(),
                      const SizedBox(height: 24),
                      _buildRecentTransactions(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  // TODO: Open drawer/menu
                },
                icon: const Icon(Icons.menu, color: Colors.white, size: 24),
              ),
              Text(
                '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              Row(
                children: [
                  const Icon(Icons.wifi, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  const Icon(Icons.signal_cellular_4_bar, color: Colors.white, size: 16),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(_riderLevel, style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                    const SizedBox(height: 8),
                    Text(_riderName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    const Text('YOUR EARNINGS', style: TextStyle(color: Colors.white, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text('\$${_todayEarnings.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(Icons.delivery_dining, color: Colors.white, size: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status: ${_isOnline ? 'Online' : 'Offline'}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(_isOnline ? 'Open to any delivery' : 'Not available', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              ],
            ),
          ),
          Switch(
            value: _isOnline,
            onChanged: _toggleOnlineStatus,
            activeColor: AppConstants.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderAlert() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          if (_availableOrders > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: const Text('Rush hour, be careful', style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: AppConstants.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: const Icon(Icons.delivery_dining, color: AppConstants.primaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$_availableOrders delivery orders found!', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: _showAvailableOrders,
                      child: Text('View details >', style: TextStyle(fontSize: 14, color: AppConstants.primaryColor, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        if (_recentTransactions.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
            ),
            child: const Center(
              child: Text(
                'No recent transactions',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          )
        else
          ..._recentTransactions.map((transaction) => _buildTransactionCard(transaction)),
      ],
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final order = transaction['orders'] as Map<String, dynamic>? ?? {};
    final createdAt = DateTime.tryParse(order['created_at'] ?? '') ?? DateTime.now();
    final distance = order['estimated_distance']?.toString() ?? '0.0';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: AppConstants.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: const Icon(Icons.receipt_long, color: AppConstants.primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delivery #${order['id']?.toString().substring(0, 8) ?? 'N/A'}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('${_formatDate(createdAt)} • ${distance} mi', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('+ \$${transaction['total_earnings'].toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
              const SizedBox(height: 2),
              Text('+ \$${transaction['tip_amount'].toStringAsFixed(2)} tips', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Convert UTC time to local time
    final localDate = date.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(localDate.year, localDate.month, localDate.day);
    
    if (dateOnly == today) {
      return 'Today, ${localDate.hour}:${localDate.minute.toString().padLeft(2, '0')} ${localDate.hour >= 12 ? 'pm' : 'am'}';
    } else if (dateOnly == yesterday) {
      return 'Yesterday, ${localDate.hour}:${localDate.minute.toString().padLeft(2, '0')} ${localDate.hour >= 12 ? 'pm' : 'am'}';
    } else {
      return '${localDate.month}/${localDate.day}, ${localDate.hour}:${localDate.minute.toString().padLeft(2, '0')} ${localDate.hour >= 12 ? 'pm' : 'am'}';
    }
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppConstants.primaryColor,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// Available Orders Screen
class AvailableOrdersScreen extends StatefulWidget {
  final List<Map<String, dynamic>> orders;

  const AvailableOrdersScreen({super.key, required this.orders});

  @override
  State<AvailableOrdersScreen> createState() => _AvailableOrdersScreenState();
}

class _AvailableOrdersScreenState extends State<AvailableOrdersScreen> {
  final RiderService _riderService = RiderService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Available Orders'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: widget.orders.isEmpty
          ? const Center(
              child: Text(
                'No available orders at the moment',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.orders.length,
              itemBuilder: (context, index) {
                final order = widget.orders[index];
                return _buildOrderCard(order);
              },
            ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final customer = order['customers'] as Map<String, dynamic>? ?? {};
    final merchant = order['merchants'] as Map<String, dynamic>? ?? {};
    final orderItems = order['order_items'] as List<dynamic>? ?? [];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${order['id'].toString().substring(0, 8)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${order['total_amount'].toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppConstants.primaryColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('From: ${merchant['name'] ?? 'Unknown Restaurant'}', style: const TextStyle(fontSize: 14)),
          Text('To: ${customer['name'] ?? 'Customer'}', style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Text('Items: ${orderItems.length}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _acceptOrder(order['id']),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Accept Order'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _acceptOrder(String orderId) async {
    try {
      final success = await _riderService.acceptOrder(orderId);
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order accepted successfully!'), backgroundColor: Colors.green),
          );
          Navigator.pop(context, true); // Return true to indicate order was accepted
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to accept order'), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error accepting order'), backgroundColor: Colors.red),
        );
      }
    }
  }
} 