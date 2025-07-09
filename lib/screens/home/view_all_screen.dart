import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class ViewAllScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final void Function(Map<String, dynamic> item, List<Map<String, dynamic>> addOns) onAddToCart;
  const ViewAllScreen({super.key, required this.cartItems, required this.onAddToCart});

  @override
  State<ViewAllScreen> createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'All',
    'Black Pinoy',
    'Sarap Inasal',
    'Burgers',
    'Fries',
    'Drinks',
    'Dinner',
    'Breakfast',
    'Lunch',
    'Snacks',
    'Desserts',
  ];

  final List<Map<String, dynamic>> _allFoodItems = [
    {
      'name': 'Classic Beef Burger',
      'image': 'assets/images/Burger.jpg',
      'description': 'Juicy beef patty with fresh lettuce, tomato, and special sauce',
      'price': 28.50,
      'rating': 4.5,
      'reviewCount': 124,
      'category': 'Burger',
      'merchant': 'General',
    },
    {
      'name': 'Crispy French Fries',
      'image': 'assets/images/friedChicken.jpg',
      'description': 'Golden crispy fries seasoned with herbs and spices',
      'price': 12.00,
      'rating': 4.2,
      'reviewCount': 89,
      'category': 'Fries',
      'merchant': 'General',
    },
    {
      'name': 'Fresh Orange Juice',
      'image': 'assets/images/Lumpia.jpg',
      'description': '100% natural orange juice, freshly squeezed',
      'price': 8.50,
      'rating': 4.7,
      'reviewCount': 156,
      'category': 'Drinks',
      'merchant': 'General',
    },
    {
      'name': 'Grilled Chicken Dinner',
      'image': 'assets/images/Food_image_1.jpg',
      'description': 'Grilled chicken breast with rice and vegetables',
      'price': 35.00,
      'rating': 4.4,
      'reviewCount': 78,
      'category': 'Dinner',
      'merchant': 'General',
    },
    {
      'name': 'Eggs Benedict',
      'image': 'assets/images/food_image_2.jpg',
      'description': 'Poached eggs on English muffin with hollandaise sauce',
      'price': 22.50,
      'rating': 4.6,
      'reviewCount': 92,
      'category': 'Breakfast',
      'merchant': 'General',
    },
    {
      'name': 'Caesar Salad',
      'image': 'assets/images/Lumpia.jpg',
      'description': 'Fresh romaine lettuce with Caesar dressing and croutons',
      'price': 18.75,
      'rating': 4.3,
      'reviewCount': 67,
      'category': 'Lunch',
      'merchant': 'General',
    },
    {
      'name': 'Popcorn Chicken',
      'image': 'assets/images/friedChicken.jpg',
      'description': 'Bite-sized crispy chicken pieces, perfect snack',
      'price': 15.00,
      'rating': 4.1,
      'reviewCount': 103,
      'category': 'Snack',
      'merchant': 'General',
    },
    {
      'name': 'Veggie Burger',
      'image': 'assets/images/Burger.jpg',
      'description': 'Plant-based burger with fresh vegetables and vegan cheese',
      'price': 26.00,
      'rating': 4.4,
      'reviewCount': 45,
      'category': 'Burger',
      'merchant': 'General',
    },
    {
      'name': 'Sweet Potato Fries',
      'image': 'assets/images/food_image_3.jpg',
      'description': 'Crispy sweet potato fries with sea salt',
      'price': 14.50,
      'rating': 4.5,
      'reviewCount': 71,
      'category': 'Fries',
      'merchant': 'General',
    },
    {
      'name': 'Iced Coffee',
      'image': 'assets/images/food_image_4.jpg',
      'description': 'Smooth iced coffee with cream and sugar',
      'price': 9.75,
      'rating': 4.3,
      'reviewCount': 88,
      'category': 'Drinks',
      'merchant': 'General',
    },
    {
      'name': 'Steak Dinner',
      'image': 'assets/images/food_image_5.jpg',
      'description': 'Premium steak with mashed potatoes and gravy',
      'price': 45.00,
      'rating': 4.8,
      'reviewCount': 112,
      'category': 'Dinner',
      'merchant': 'General',
    },
    {
      'name': 'Pancakes',
      'image': 'assets/images/Burger.jpg',
      'description': 'Fluffy pancakes with maple syrup and butter',
      'price': 16.50,
      'rating': 4.6,
      'reviewCount': 134,
      'category': 'Breakfast',
      'merchant': 'General',
    },
    // Black Pinoy Items
    {
      'name': 'Beef Bulalo',
      'image': 'assets/images/beef_bulalo.jpg',
      'description': 'Classic Filipino beef soup with bone marrow.',
      'price': 55.00,
      'rating': 4.8,
      'reviewCount': 89,
      'category': 'Dinner',
      'merchant': 'Black Pinoy',
    },
    {
      'name': 'Beef Kare-Kare',
      'image': 'assets/images/beef_kare-kare.jpg',
      'description': 'Rich peanut stew with tender beef and vegetables.',
      'price': 50.00,
      'rating': 4.7,
      'reviewCount': 76,
      'category': 'Dinner',
      'merchant': 'Black Pinoy',
    },
    {
      'name': 'Beef Sisig',
      'image': 'assets/images/beef_sisig.jpg',
      'description': 'Sizzling chopped beef with onions and chili.',
      'price': 45.00,
      'rating': 4.6,
      'reviewCount': 92,
      'category': 'Dinner',
      'merchant': 'Black Pinoy',
    },
    {
      'name': 'Buttered Chicken',
      'image': 'assets/images/buttered_chicken.jpg',
      'description': 'Crispy fried chicken tossed in butter sauce.',
      'price': 38.00,
      'rating': 4.5,
      'reviewCount': 67,
      'category': 'Dinner',
      'merchant': 'Black Pinoy',
    },
    // Sarap Inasal Items
    {
      'name': 'Fried Rice',
      'image': 'assets/images/fried_rice.jpg',
      'description': 'Delicious fried rice with vegetables, eggs, and special seasonings.',
      'price': 18.00,
      'rating': 4.4,
      'reviewCount': 45,
      'category': 'Lunch',
      'merchant': 'Sarap Inasal',
    },
    {
      'name': 'Sinigang na Salmon',
      'image': 'assets/images/sinigang_salmon.jpg',
      'description': 'Sour tamarind soup with fresh salmon and vegetables.',
      'price': 45.00,
      'rating': 4.9,
      'reviewCount': 78,
      'category': 'Dinner',
      'merchant': 'Sarap Inasal',
    },
    {
      'name': 'Chicharon Bulaklak',
      'image': 'assets/images/chicharon_bulaklak.jpg',
      'description': 'Crispy pork rinds made from pork intestines, perfect appetizer.',
      'price': 25.00,
      'rating': 4.3,
      'reviewCount': 34,
      'category': 'Snack',
      'merchant': 'Sarap Inasal',
    },
    {
      'name': 'Mixed Seafoods',
      'image': 'assets/images/mixed_seafoods.jpg',
      'description': 'Fresh seafood medley with shrimp, fish, and calamari.',
      'price': 55.00,
      'rating': 4.8,
      'reviewCount': 56,
      'category': 'Dinner',
      'merchant': 'Sarap Inasal',
    },
  ];

  List<Map<String, dynamic>> get _filteredFoodItems {
    String searchQuery = _searchController.text.toLowerCase();
    List<Map<String, dynamic>> filteredItems = _allFoodItems;

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filteredItems = filteredItems.where((item) {
        return item['name'].toString().toLowerCase().contains(searchQuery) ||
               item['description'].toString().toLowerCase().contains(searchQuery) ||
               item['merchant'].toString().toLowerCase().contains(searchQuery);
      }).toList();
    }

    // Filter by category
    if (_selectedCategoryIndex == 0) {
      // Show all items (already filtered by search)
      return filteredItems;
    } else if (_selectedCategoryIndex == 1) {
      // Black Pinoy
      return filteredItems.where((item) => item['merchant'] == 'Black Pinoy').toList();
    } else if (_selectedCategoryIndex == 2) {
      // Sarap Inasal
      return filteredItems.where((item) => item['merchant'] == 'Sarap Inasal').toList();
    } else {
      // Filter by selected category, mapping plural to singular where needed
      String selectedCategory = _categories[_selectedCategoryIndex];
      if (selectedCategory == 'Burgers') selectedCategory = 'Burger';
      if (selectedCategory == 'Desserts') selectedCategory = 'Dessert';
      return filteredItems.where((item) => item['category'] == selectedCategory).toList();
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
        backgroundColor: const Color(0xFFd00000),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar (moved up, less vertical padding)
            Container(
              color: const Color(0xFFd00000),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8), // less top/bottom padding
              child: Container(
                height: 44, // slightly smaller
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for food...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFFd00000),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      // Implement search functionality here
                    });
                  },
                ),
              ),
            ),
            // Category pills
            Container(
              color: const Color(0xFFd00000),
              padding: const EdgeInsets.only(bottom: 12), // less bottom padding
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final isSelected = index == _selectedCategoryIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.white.withAlpha(51),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _categories[index],
                          style: TextStyle(
                            color: isSelected ? const Color(0xFFd00000) : Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Food items grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8), // reduced bottom padding
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.95, // make cards shorter (was 0.75)
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _filteredFoodItems.length,
                  itemBuilder: (context, index) {
                    final item = _filteredFoodItems[index];
                    return GestureDetector(
                      onTap: () => _showFoodDetailsModal(item),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(25),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Food image
                            Stack(
                              children: [
                                Container(
                                  height: 90, // was 120, now shorter
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
                                    child: Image.asset(
                                      item['image'],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        color: Colors.grey[200],
                                        child: const Center(child: Icon(Icons.broken_image)),
                                      ),
                                    ),
                                  ),
                                ),
                                // Merchant badge
                                if (item['merchant'] != 'General')
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: item['merchant'] == 'Black Pinoy' 
                                            ? Colors.black.withAlpha(204)
                                            : const Color(0xFFd00000).withAlpha(204),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        item['merchant'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            // Food details
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8), // reduced from 12 to 8
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Food name
                                    Text(
                                      item['name'],
                                      style: const TextStyle(
                                        fontSize: 13, // reduced from 14
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    // Merchant name
                                    if (item['merchant'] != 'General')
                                      Text(
                                        item['merchant'],
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: item['merchant'] == 'Black Pinoy' 
                                              ? Colors.black
                                              : const Color(0xFFd00000),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    const SizedBox(height: 2), // reduced from 4
                                    // Description
                                    Text(
                                      item['description'],
                                      style: const TextStyle(
                                        fontSize: 10, // reduced from 11
                                        color: Colors.grey,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Spacer(),
                                    // Price and rating at bottom
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Price on left
                                        Text(
                                          'SAR ${item['price'].toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 13, // reduced from 14
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFd00000),
                                          ),
                                        ),
                                        // Rating on right
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              size: 12, // reduced from 14
                                              color: Colors.amber[600],
                                            ),
                                            const SizedBox(width: 2), // reduced from 4
                                            Text(
                                              '${item['rating']}',
                                              style: const TextStyle(
                                                fontSize: 11, // reduced from 12
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
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
            ),
          ],
        ),
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
          backgroundColor: const Color(0xFFd00000),
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
                      child: Image.asset(
                        foodItem['image'],
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
                child: Padding(
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
                              foodItem['name'],
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
                                '${foodItem['rating']} (${foodItem['reviewCount']})',
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
                        foodItem['description'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
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
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFFd00000),
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
                            foregroundColor: const Color(0xFFd00000),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: const Color(0xFFd00000),
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
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFd00000),
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              widget.onAddToCart(foodItem, selectedAddOns);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Added ${foodItem['name']} to cart!'),
                                  backgroundColor: const Color(0xFFd00000),
                                ),
                              );
                              Navigator.of(context).popUntil((route) => route.isFirst);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFd00000),
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
                    backgroundColor: const Color(0xFFd00000),
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
            color: const Color(0xFFd00000),
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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFd00000),
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
                  color: const Color(0xFFd00000),
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
