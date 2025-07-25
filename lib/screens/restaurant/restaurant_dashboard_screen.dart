import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class RestaurantDashboardScreen extends StatefulWidget {
  const RestaurantDashboardScreen({super.key});

  @override
  State<RestaurantDashboardScreen> createState() => _RestaurantDashboardScreenState();
}

class _RestaurantDashboardScreenState extends State<RestaurantDashboardScreen> {
  // Mock order data for now
  List<Map<String, dynamic>> orders = [
    {
      'id': '1',
      'customer': 'John Doe',
      'items': ['Beef Bulalo', 'Lumpia'],
      'status': 'pending',
      'address': '123 Main St',
    },
    {
      'id': '2',
      'customer': 'Jane Smith',
      'items': ['Chicken Inasal'],
      'status': 'preparing',
      'address': '456 Elm St',
    },
    {
      'id': '3',
      'customer': 'Mike Lee',
      'items': ['Buttered Chicken'],
      'status': 'ready',
      'address': '789 Oak St',
    },
    {
      'id': '4',
      'customer': 'Anna Cruz',
      'items': ['Halo-halo'],
      'status': 'completed',
      'address': '321 Pine St',
    },
  ];

  final Map<String, Color> statusColors = {
    'pending': AppConstants.warningColor,
    'preparing': AppConstants.secondaryColor,
    'ready': AppConstants.successColor,
    'completed': Colors.grey,
  };

  void _updateOrderStatus(int index) {
    setState(() {
      final currentStatus = orders[index]['status'];
      if (currentStatus == 'pending') {
        orders[index]['status'] = 'preparing';
      } else if (currentStatus == 'preparing') {
        orders[index]['status'] = 'ready';
      } else if (currentStatus == 'ready') {
        orders[index]['status'] = 'completed';
      }
    });
  }

  String _nextStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Start Preparing';
      case 'preparing':
        return 'Mark as Ready';
      case 'ready':
        return 'Complete Order';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Dashboard'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: AppConstants.textOnPrimary,
        elevation: 0,
      ),
      backgroundColor: AppConstants.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Incoming Orders',
              style: AppConstants.headingStyle.copyWith(color: AppConstants.primaryColor),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Card(
                    color: AppConstants.cardColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge)),
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingLarge),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Order #${order['id']}',
                                style: AppConstants.subheadingStyle,
                              ),
                              Chip(
                                label: Text(order['status'].toString().toUpperCase()),
                                backgroundColor: statusColors[order['status']]?.withOpacity(0.15),
                                labelStyle: TextStyle(
                                  color: statusColors[order['status']] ?? AppConstants.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Customer: ${order['customer']}', style: AppConstants.bodyStyle),
                          Text('Address: ${order['address']}', style: AppConstants.bodyStyle),
                          const SizedBox(height: 8),
                          Text('Items: ${order['items'].join(", ")}', style: AppConstants.bodyStyle),
                          const SizedBox(height: 12),
                          if (order['status'] != 'completed')
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: AppConstants.primaryButton,
                                onPressed: () => _updateOrderStatus(index),
                                child: Text(_nextStatusLabel(order['status'])),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Placeholder for menu management
            Card(
              color: AppConstants.cardColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge)),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.restaurant_menu, color: AppConstants.primaryColor),
                title: Text('Menu Management', style: AppConstants.subheadingStyle),
                subtitle: const Text('Add, edit, or remove menu items'),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: const Text('Menu management coming soon!'), backgroundColor: AppConstants.primaryColor),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} 