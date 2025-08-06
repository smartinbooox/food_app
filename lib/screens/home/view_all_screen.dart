import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewAllScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final void Function(Map<String, dynamic> item, List<Map<String, dynamic>> addOns) onAddToCart;
  final List<Map<String, dynamic>> favoriteFoods;
  final void Function(Map<String, dynamic> food) onToggleFavorite;
  final bool Function(Map<String, dynamic> food) isFavorite;
  const ViewAllScreen({
    super.key, 
    required this.cartItems, 
    required this.onAddToCart,
    required this.favoriteFoods,
    required this.onToggleFavorite,
    required this.isFavorite,
  });

  @override
  State<ViewAllScreen> createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'All',
    'Dinner',
    'Breakfast',
    'Lunch',
    'Snacks',
    'Desserts',
    'Drinks',
  ];

  // Add state for dynamic food items
  List<Map<String, dynamic>> _allFoodItems = [];
  bool _isLoadingFoods = true;

  @override
  void initState() {
    super.initState();
    _fetchAllFoods();
  }

  Future<void> _fetchAllFoods() async {
    setState(() => _isLoadingFoods = true);
    final response = await Supabase.instance.client
        .from('foods')
        .select()
        .order('created_at', ascending: false);
    setState(() {
      _allFoodItems = List<Map<String, dynamic>>.from(response as List);
      _isLoadingFoods = false;
    });
  }

  List<Map<String, dynamic>> get _filteredFoodItems {
    String searchQuery = _searchController.text.toLowerCase();
    List<Map<String, dynamic>> filteredItems = _allFoodItems;

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filteredItems = filteredItems.where((item) {
        return item['name'].toString().toLowerCase().contains(searchQuery) ||
               item['description'].toString().toLowerCase().contains(searchQuery);
      }).toList();
    }
    
    // Filter by category if not 'All'
    if (_selectedCategoryIndex > 0) {
      final selectedCategory = _categories[_selectedCategoryIndex];
      filteredItems = filteredItems.where((item) {
        return _isFoodInCategory(item, selectedCategory);
      }).toList();
    }
    return filteredItems;
  }

  bool _isFoodInCategory(Map<String, dynamic> food, String category) {
    final name = food['name']?.toString().toLowerCase() ?? '';
    final description = food['description']?.toString().toLowerCase() ?? '';
    final combinedText = '$name $description';

    switch (category.toLowerCase()) {
      case 'dinner':
        return combinedText.contains('dinner') ||
               combinedText.contains('steak') ||
               combinedText.contains('t-bone') ||
               combinedText.contains('pasta') ||
               combinedText.contains('rice') ||
               combinedText.contains('chicken') ||
               combinedText.contains('beef') ||
               combinedText.contains('fish') ||
               combinedText.contains('seafood') ||
               combinedText.contains('salmon') ||
               combinedText.contains('tilapia') ||
               combinedText.contains('bulalo') ||
               combinedText.contains('sisig') ||
               combinedText.contains('kare-kare') ||
               combinedText.contains('sinigang') ||
               combinedText.contains('broccoli') ||
               combinedText.contains('mixed seafood') ||
               combinedText.contains('spare ribs') ||
               combinedText.contains('hipon') ||
               combinedText.contains('bangus') ||
               combinedText.contains('boneless');
      
      case 'breakfast':
        return combinedText.contains('breakfast') ||
               combinedText.contains('egg') ||
               combinedText.contains('bacon') ||
               combinedText.contains('pancake') ||
               combinedText.contains('waffle') ||
               combinedText.contains('toast') ||
               combinedText.contains('tapsilog') ||
               combinedText.contains('bangsilog') ||
               combinedText.contains('longganisa') ||
               combinedText.contains('tocino') ||
               combinedText.contains('garlic fried rice') ||
               combinedText.contains('fried rice');
      
      case 'lunch':
        return combinedText.contains('lunch') ||
               combinedText.contains('meal') ||
               combinedText.contains('rice') ||
               combinedText.contains('rice bowl') ||
               combinedText.contains('noodles') ||
               combinedText.contains('pancit') ||
               combinedText.contains('pancit canton') ||
               combinedText.contains('pancit batil patung') ||
               combinedText.contains('spaghetti') ||
               combinedText.contains('pinoy spaghetti') ||
               combinedText.contains('adobo') ||
               combinedText.contains('kaldereta') ||
               combinedText.contains('menudo') ||
               combinedText.contains('palabok') ||
               combinedText.contains('lomi') ||
               combinedText.contains('buttered chicken') ||
               combinedText.contains('chicken inasal') ||
               combinedText.contains('fried chicken') ||
               combinedText.contains('balbacua') ||
               combinedText.contains('laing');
      
      case 'snacks':
        return combinedText.contains('snack') ||
               combinedText.contains('fries') ||
               combinedText.contains('french fries') ||
               combinedText.contains('chips') ||
               combinedText.contains('popcorn') ||
               combinedText.contains('lumpia') ||
               combinedText.contains('siomai') ||
               combinedText.contains('steamed siomai') ||
               combinedText.contains('chicharon') ||
               combinedText.contains('chicharon bulaklak') ||
               combinedText.contains('nuggets') ||
               combinedText.contains('burger') ||
               combinedText.contains('onion rings');
      
      case 'desserts':
        return combinedText.contains('dessert') ||
               combinedText.contains('cake') ||
               combinedText.contains('chocolate cake') ||
               combinedText.contains('ice cream') ||
               combinedText.contains('flan') ||
               combinedText.contains('leche flan') ||
               combinedText.contains('halo-halo') ||
               combinedText.contains('buko pandan') ||
               combinedText.contains('leche') ||
               combinedText.contains('sweet') ||
               combinedText.contains('chocolate') ||
               combinedText.contains('sweet sour');
      
      case 'drinks':
        return combinedText.contains('drink') ||
               combinedText.contains('juice') ||
               combinedText.contains('fresh juice') ||
               combinedText.contains('soda') ||
               combinedText.contains('soft drink') ||
               combinedText.contains('coffee') ||
               combinedText.contains('tea') ||
               combinedText.contains('milk') ||
               combinedText.contains('water') ||
               combinedText.contains('smoothie') ||
               combinedText.contains('milktea') ||
               combinedText.contains('samalamig');
      
      default:
        return true;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('All Foods'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoadingFoods
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search foods...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                ),
                Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedCategoryIndex == index;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategoryIndex = index;
                            });
                          },
                                                      child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? AppConstants.primaryColor : Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: isSelected ? AppConstants.primaryColor : Colors.grey[300]!,
                                width: 1.5,
                              ),
                              boxShadow: isSelected ? [
                                BoxShadow(
                                  color: AppConstants.primaryColor.withAlpha((255 * 0.3).round()),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ] : null,
                            ),
                            child: Center(
                              child: Text(
                                _categories[index],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black87,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                  fontSize: 14,
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
                const SizedBox(height: 4),
                Expanded(
                  child: _filteredFoodItems.isEmpty
                      ? const Center(child: Text('No foods found.'))
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: _filteredFoodItems.length,
                          itemBuilder: (context, index) {
                            final food = _filteredFoodItems[index];
                            return GestureDetector(
                              onTap: () => _showFoodDetailsModal(food),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha((255 * 0.1).round()),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                  children: [
                                    Container(
                                      height: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                        child: food['image_url'] != null && food['image_url'].toString().isNotEmpty
                                            ? Image.network(
                                                food['image_url'],
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                errorBuilder: (context, error, stackTrace) => Container(
                                                  color: Colors.grey[200],
                                                  child: const Center(child: Icon(Icons.broken_image)),
                                                ),
                                              )
                                            : Container(
                                                color: Colors.grey[200],
                                                child: const Center(child: Icon(Icons.fastfood)),
                                              ),
                                      ),
                                    ),
                                        // Heart icon overlay
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: GestureDetector(
                                            onTap: () {
                                              widget.onToggleFavorite(food);
                                              setState(() {}); // Force rebuild to update heart icon
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withAlpha((255 * 0.9).round()),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                widget.isFavorite(food) ? Icons.favorite : Icons.favorite_border,
                                                size: 16,
                                                color: AppConstants.primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              food['name'] ?? 'Food Item',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black87,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                            Expanded(
                                              child: Text(
                                                food['description'] ?? 'No description available',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black54,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                              ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Expanded(
                                                  child: Text(
                                                    'SAR ${(food['price'] ?? 0.0).toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppConstants.primaryColor,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  widget.onAddToCart(food, []);
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                        content: Text('${food['name'] ?? 'Food Item'} added to cart!'),
                                                      backgroundColor: AppConstants.primaryColor,
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                    color: AppConstants.primaryColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  void _showFoodDetailsModal(Map<String, dynamic> foodItem) {
    List<Map<String, dynamic>> selectedAddOns = [];
    double totalPrice = foodItem['price'];
    void addAddOn(Map<String, dynamic> addOn) {
      selectedAddOns.add(addOn);
      totalPrice += addOn['price'];
      Navigator.of(context).pop();
      _showFoodDetailsModalWithAddOns(foodItem, selectedAddOns, totalPrice, addAddOn: addAddOn);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added ${addOn['name']} to cart!'),
          backgroundColor: AppConstants.primaryColor,
        ),
      );
    }
    _showFoodDetailsModalWithAddOns(foodItem, selectedAddOns, totalPrice, addAddOn: addAddOn);
  }

  void _showFoodDetailsModalWithAddOns(
    Map<String, dynamic> foodItem,
    List<Map<String, dynamic>> selectedAddOns,
    double totalPrice, {
    void Function(Map<String, dynamic>)? addAddOn,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final double modalHeight = MediaQuery.of(context).size.height;
        final double imageHeight = modalHeight * 0.6;
        return Container(
          height: modalHeight,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
          ),
          child: Column(
            children: [
              SizedBox(
                height: imageHeight,
                width: double.infinity,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.zero,
                      child: foodItem['image_url'] != null && foodItem['image_url'].toString().isNotEmpty
                          ? Image.network(
                              foodItem['image_url'],
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.grey[200],
                                width: double.infinity,
                                height: double.infinity,
                                child: const Center(child: Icon(Icons.broken_image)),
                              ),
                            )
                          : Image.asset(
                              foodItem['image'] ?? 'assets/images/food_image_1.jpg',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          width: double.infinity,
                          height: double.infinity,
                          child: const Center(child: Icon(Icons.broken_image)),
                        ),
                      ),
                    ),
                    // Overlay close button in the top right
                    Positioned(
                      top: 32,
                      right: 16,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(20),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.close, color: Colors.black87, size: 22),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              foodItem['name'] ?? 'Food Item',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 20,
                                color: Colors.amber[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${foodItem['rating'] ?? 4.5} (${foodItem['reviewCount'] ?? 50})',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        foodItem['description'] ?? 'No description available',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                      if (selectedAddOns.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Add-ons:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        ...selectedAddOns.map((addOn) => Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    addOn['name'],
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    '+ SAR ${addOn['price'].toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppConstants.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showCustomizeOptions(foodItem, addAddOn: addAddOn);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[100],
                            foregroundColor: AppConstants.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: AppConstants.primaryColor,
                                width: 1,
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.tune),
                          label: const Text(
                            'Customize',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Price',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'SAR ${totalPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstants.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              widget.onAddToCart(foodItem, selectedAddOns);
                              // Close modal first
                              Navigator.pop(context);
                              
                              // Use a post-frame callback to ensure the modal is closed
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Added ${foodItem['name']} to cart!'),
                                      backgroundColor: AppConstants.primaryColor,
                                    ),
                                  );
                                  
                                  // Navigate to home screen safely
                                  Navigator.of(context).popUntil((route) => route.isFirst);
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppConstants.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.shopping_cart),
                            label: const Text(
                              'Add to Cart',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 20), // Extra bottom padding
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCustomizeOptions(Map<String, dynamic> foodItem, {void Function(Map<String, dynamic>)? addAddOn}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Customize Your Order',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildAddOnItem('Dessert', 'Chocolate Cake', 8.50, addAddOn),
                  _buildAddOnItem('Dessert', 'Ice Cream', 5.00, addAddOn),
                  _buildAddOnItem('Drink', 'Soft Drink', 3.50, addAddOn),
                  _buildAddOnItem('Drink', 'Fresh Juice', 6.00, addAddOn),
                  _buildAddOnItem('Side', 'French Fries', 4.50, addAddOn),
                  _buildAddOnItem('Side', 'Onion Rings', 5.50, addAddOn),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddOnItem(String category, String name, double price, [void Function(Map<String, dynamic>)? addAddOn]) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            category == 'Dessert' ? Icons.cake : 
            category == 'Drink' ? Icons.local_drink : Icons.fastfood,
            color: AppConstants.primaryColor,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(category),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'SAR ${price.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryColor,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: addAddOn != null
                  ? () => addAddOn({'name': name, 'price': price})
                  : null,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
