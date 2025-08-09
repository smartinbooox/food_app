import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_constants.dart';

class FoodListScreen extends StatefulWidget {
  final String title;
  final String creatorId;

  const FoodListScreen({super.key, required this.title, required this.creatorId});

  @override
  State<FoodListScreen> createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _foods = [];
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final categoriesResponse = await Supabase.instance.client
          .from('categories')
          .select('*')
          .order('name');
      _categories = List<Map<String, dynamic>>.from(categoriesResponse as List);

      final foodsResponse = await Supabase.instance.client
          .from('foods')
          .select('*, users!foods_created_by_fkey(name, email)')
          .eq('created_by', widget.creatorId)
          .order('created_at', ascending: false);
      _foods = List<Map<String, dynamic>>.from(foodsResponse as List);
    } catch (e) {
      // no-op; show empty state below if needed
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Color _categoryColor(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'main course':
      case 'main':
        return Colors.red.withOpacity(0.1);
      case 'beverage':
      case 'drink':
        return Colors.blue.withOpacity(0.1);
      case 'seafood':
        return Colors.cyan.withOpacity(0.1);
      case 'grilled & bbq':
      case 'grilled':
      case 'bbq':
        return Colors.orange.withOpacity(0.1);
      case 'pastries':
      case 'pastry':
        return Colors.purple.withOpacity(0.1);
      case 'desserts':
      case 'dessert':
        return Colors.yellow.withOpacity(0.1);
      case 'snacks':
      case 'snack':
        return Colors.green.withOpacity(0.1);
      case 'etc':
      case 'other':
        return Colors.grey.withOpacity(0.1);
      default:
        return Colors.indigo.withOpacity(0.1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: AppConstants.backgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppConstants.primaryColor))
          : _foods.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.receipt_long, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No foods available', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Add foods or choose another creator to see items here', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _loadData,
        color: AppConstants.primaryColor,
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: _foods.length,
          itemBuilder: (context, index) {
            final food = _foods[index];
            final users = food['users'] as Map<String, dynamic>?;
            final creatorName = (users?['name'] as String?)?.trim();
            final creatorEmail = (users?['email'] as String?)?.trim();
            final creatorLabel = (creatorName != null && creatorName.isNotEmpty)
                ? creatorName
                : (creatorEmail != null && creatorEmail.isNotEmpty ? creatorEmail : 'Restaurant');

            final category = _categories.firstWhere(
                  (cat) => cat['id'] == food['category_id'],
              orElse: () => {'name': 'Uncategorized'},
            );

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      Container(
                        width: 92,
                        height: 92,
                        alignment: Alignment.center,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: (food['image_url'] != null && (food['image_url'] as String).isNotEmpty)
                              ? Image.network(food['image_url'], width: 92, height: 92, fit: BoxFit.cover)
                              : Container(
                            width: 92,
                            height: 92,
                            color: Colors.grey[200],
                            child: const Icon(Icons.fastfood, size: 44, color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),
                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        food['name'] ?? '',
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        creatorLabel,
                                        style: const TextStyle(fontSize: 13, color: Colors.blueGrey, fontWeight: FontWeight.w600),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        food['description'] ?? '',
                                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _categoryColor(category['name'] ?? ''),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    category['name'],
                                    style: TextStyle(color: AppConstants.primaryColor, fontWeight: FontWeight.w600, fontSize: 12),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  'SAR ${food['price']?.toStringAsFixed(2) ?? ''}',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppConstants.primaryColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}