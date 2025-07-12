import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool _showWeekly = true; // Default to weekly view

  Future<int> _fetchUserCount() async {
    final response = await Supabase.instance.client
        .from('users')
        .select('id');
    return (response as List).length;
  }

  Future<List<Map<String, dynamic>>> _fetchMonthlyUsers() async {
    try {
      // Fetch users with created_at field (Supabase automatically adds this)
      final response = await Supabase.instance.client
          .from('users')
          .select('created_at')
          .order('created_at', ascending: true);
      
      final users = response as List;
      
      // Group users by month
      final Map<String, int> monthlyData = {};
      final now = DateTime.now();
      
      // Initialize last 6 months with 0
      for (int i = 5; i >= 0; i--) {
        final date = DateTime(now.year, now.month - i, 1);
        final monthKey = '${date.year}-${date.month.toString().padLeft(2, '0')}';
        monthlyData[monthKey] = 0;
      }
      
      // Count users by month
      for (final user in users) {
        if (user['created_at'] != null) {
          final createdAt = DateTime.parse(user['created_at']);
          final monthKey = '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}';
          monthlyData[monthKey] = (monthlyData[monthKey] ?? 0) + 1;
        }
      }
      
      // Convert to list format for chart
      final sortedKeys = monthlyData.keys.toList()..sort();
      return sortedKeys.map((key) {
        final parts = key.split('-');
        final month = int.parse(parts[1]);
        final monthName = _getMonthName(month);
        return {
          'month': monthName,
          'count': monthlyData[key] ?? 0,
        };
      }).toList();
    } catch (e) {
      print('Error fetching monthly users: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _fetchWeeklyUsers() async {
    try {
      // Fetch users with created_at field
      final response = await Supabase.instance.client
          .from('users')
          .select('created_at')
          .order('created_at', ascending: true);
      
      final users = response as List;
      
      // Group users by week
      final Map<String, int> weeklyData = {};
      final now = DateTime.now();
      
      // Initialize last 8 weeks with 0
      for (int i = 7; i >= 0; i--) {
        final date = now.subtract(Duration(days: i * 7));
        final weekStart = date.subtract(Duration(days: date.weekday - 1));
        final weekKey = '${weekStart.year}-${weekStart.month.toString().padLeft(2, '0')}-${weekStart.day.toString().padLeft(2, '0')}';
        weeklyData[weekKey] = 0;
      }
      
      // Count users by week
      for (final user in users) {
        if (user['created_at'] != null) {
          final createdAt = DateTime.parse(user['created_at']);
          final weekStart = createdAt.subtract(Duration(days: createdAt.weekday - 1));
          final weekKey = '${weekStart.year}-${weekStart.month.toString().padLeft(2, '0')}-${weekStart.day.toString().padLeft(2, '0')}';
          weeklyData[weekKey] = (weeklyData[weekKey] ?? 0) + 1;
        }
      }
      
      // Convert to list format for chart
      final sortedKeys = weeklyData.keys.toList()..sort();
      return sortedKeys.map((key) {
        final parts = key.split('-');
        final month = int.parse(parts[1]);
        final day = int.parse(parts[2]);
        final weekLabel = '$month/$day'; // Numeral format: 6/2, 6/9, etc.
        return {
          'week': weekLabel,
          'count': weeklyData[key] ?? 0,
        };
      }).toList();
    } catch (e) {
      print('Error fetching weekly users: $e');
      return [];
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  void _toggleView() {
    setState(() {
      _showWeekly = !_showWeekly;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color(0xFF800000),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<int>(
          future: _fetchUserCount(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final userCount = snapshot.data ?? 0;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome, Admin!',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    
                    // User Count Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            const Text(
                              'Total Registered Users',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              userCount.toString(),
                              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF800000)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Combined Chart Card with Toggle
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header with toggle button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _showWeekly ? 'Weekly User Registrations' : 'Monthly User Registrations',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                                IconButton(
                                  onPressed: _toggleView,
                                  icon: Icon(
                                    _showWeekly ? Icons.bar_chart : Icons.show_chart,
                                    color: const Color(0xFF800000),
                                    size: 24,
                                  ),
                                  tooltip: _showWeekly ? 'Switch to Monthly View' : 'Switch to Weekly View',
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            // Chart
                            SizedBox(
                              height: 250,
                              child: FutureBuilder<List<Map<String, dynamic>>>(
                                future: _showWeekly ? _fetchWeeklyUsers() : _fetchMonthlyUsers(),
                                builder: (context, chartSnapshot) {
                                  if (chartSnapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                  } else if (chartSnapshot.hasError) {
                                    return Center(child: Text('Error loading chart: ${chartSnapshot.error}'));
                                  } else {
                                    final chartData = chartSnapshot.data ?? [];
                                    if (chartData.isEmpty) {
                                      return const Center(
                                        child: Text('No data available', style: TextStyle(color: Colors.grey)),
                                      );
                                    }
                                    
                                    final maxCount = chartData.fold<int>(
                                      0, (max, item) => item['count'] > max ? item['count'] : max);
                                    
                                    return BarChart(
                                      BarChartData(
                                        alignment: BarChartAlignment.spaceAround,
                                        maxY: maxCount > 0 ? maxCount.toDouble() : 10,
                                        barTouchData: BarTouchData(
                                          enabled: true,
                                          touchTooltipData: BarTouchTooltipData(
                                            tooltipRoundedRadius: 8,
                                            tooltipPadding: const EdgeInsets.all(8),
                                            tooltipMargin: 8,
                                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                              return BarTooltipItem(
                                                '${rod.toY.toInt()} users',
                                                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                              );
                                            },
                                          ),
                                        ),
                                        titlesData: FlTitlesData(
                                          show: true,
                                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              getTitlesWidget: (value, meta) {
                                                if (value.toInt() >= 0 && value.toInt() < chartData.length) {
                                                  final label = _showWeekly 
                                                      ? chartData[value.toInt()]['week']
                                                      : chartData[value.toInt()]['month'];
                                                  return Padding(
                                                    padding: const EdgeInsets.only(top: 8.0),
                                                    child: Text(
                                                      label,
                                                      style: TextStyle(
                                                        fontSize: _showWeekly ? 10 : 12,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  );
                                                }
                                                return const Text('');
                                              },
                                            ),
                                          ),
                                          leftTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              reservedSize: 40,
                                              getTitlesWidget: (value, meta) {
                                                return Text(
                                                  value.toInt().toString(),
                                                  style: const TextStyle(fontSize: 10),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        borderData: FlBorderData(show: false),
                                        barGroups: chartData.asMap().entries.map((entry) {
                                          final index = entry.key;
                                          final data = entry.value;
                                          return BarChartGroupData(
                                            x: index,
                                            barRods: [
                                              BarChartRodData(
                                                toY: data['count'].toDouble(),
                                                color: const Color(0xFF800000),
                                                width: _showWeekly ? 15 : 20,
                                                borderRadius: const BorderRadius.only(
                                                  topLeft: Radius.circular(4),
                                                  topRight: Radius.circular(4),
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                        gridData: FlGridData(
                                          show: true,
                                          horizontalInterval: 1,
                                          getDrawingHorizontalLine: (value) {
                                            return FlLine(
                                              color: Colors.grey.withOpacity(0.3),
                                              strokeWidth: 1,
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
} 