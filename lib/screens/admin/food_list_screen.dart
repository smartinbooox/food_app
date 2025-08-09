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
  String _selectedCategoryId = 'all';

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
      // no-op
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

  List<Map<String, dynamic>> get _filteredFoods {
    if (_selectedCategoryId == 'all') return _foods;
    return _foods.where((f) => f['category_id'] == _selectedCategoryId).toList();
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
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    children: [
                      // Category chips (clone style)
                      SizedBox(
                        height: 48,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          itemCount: _categories.length + 1,
                          separatorBuilder: (context, idx) => const SizedBox(width: 8),
                          itemBuilder: (context, idx) {
                            if (idx == 0) {
                              final bool isSelected = _selectedCategoryId == 'all';
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(24),
                                  onTap: () => setState(() => _selectedCategoryId = 'all'),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppConstants.primaryColor : Colors.white,
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(color: AppConstants.primaryColor.withOpacity(0.15)),
                                      boxShadow: [
                                        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2)),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        'All',
                                        style: TextStyle(
                                          color: isSelected ? Colors.white : AppConstants.primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            final cat = _categories[idx - 1];
                            final bool isSelected = cat['id'] == _selectedCategoryId;
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(24),
                                onTap: () => setState(() => _selectedCategoryId = cat['id']),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppConstants.primaryColor : Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(color: AppConstants.primaryColor.withOpacity(0.15)),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2)),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      cat['name'],
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : AppConstants.primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Full food list (clone cards)
                      ..._filteredFoods.map((food) {
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
                                                  // Removed creator/account label
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
                      }).toList(),
                    ],
                  ),
                ),
    );
  }
}