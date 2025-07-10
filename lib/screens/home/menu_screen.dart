import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import 'view_all_screen.dart';

class MenuScreen extends StatefulWidget {
  final String userName;
  const MenuScreen({super.key, required this.userName});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final TextEditingController _locationController = TextEditingController();

  final List<String> _carouselImages = [
    'assets/images/Lumpia.jpg',
    'assets/images/friedChicken.jpg',
    'assets/images/Burger.jpg',
  ];

  final List<Map<String, String>> _foodItems = [
    {'name': 'Combo Meals', 'image': 'assets/images/Food_image_1.jpg'},
    {'name': 'Combo Meals', 'image': 'assets/images/food_image_2.jpg'},
    {'name': 'Lumpia', 'image': 'assets/images/Lumpia.jpg'},
    {'name': 'Burger', 'image': 'assets/images/Burger.jpg'},
    {'name': 'Fried Chicken', 'image': 'assets/images/friedChicken.jpg'},
    {'name' : 'Combo Meals', 'image': 'assets/images/food_image_3.jpg'},
    {'name' : 'Combo Meals', 'image': 'assets/images/food_image_4.jpg'},
    {'name' : 'Combo Meals', 'image': 'assets/images/food_image_5.jpg'},
  ];

  final List<Map<String, dynamic>> _recommendedItems = [
    {
      'name': 'Grilled Chicken Burger',
      'image': 'assets/images/Burger.jpg',
      'description': 'Juicy grilled chicken with fresh vegetables and special sauce',
      'price': 25.50,
      'isFavorite': false,
    },
    {
      'name': 'Crispy Fried Chicken',
      'image': 'assets/images/friedChicken.jpg',
      'description': 'Golden crispy chicken with herbs and spices',
      'price': 32.00,
      'isFavorite': false,
    },
    {
      'name': 'Fresh Lumpia',
      'image': 'assets/images/Lumpia.jpg',
      'description': 'Traditional spring rolls with vegetables and meat',
      'price': 18.75,
      'isFavorite': false,
    },
    {
      'name': 'Beef Combo Meal',
      'image': 'assets/images/Food_image_1.jpg',
      'description': 'Delicious beef burger with fries and drink',
      'price': 45.00,
      'isFavorite': false,
    },
    {
      'name': 'Spicy Chicken Wings',
      'image': 'assets/images/friedChicken.jpg',
      'description': 'Hot and spicy wings with dipping sauce',
      'price': 28.50,
      'isFavorite': false,
    },
    {
      'name': 'Vegetable Spring Rolls',
      'image': 'assets/images/Lumpia.jpg',
      'description': 'Fresh vegetables wrapped in rice paper',
      'price': 16.25,
      'isFavorite': false,
    },
    {
      'name': 'Double Cheese Burger',
      'image': 'assets/images/Burger.jpg',
      'description': 'Double patty with extra cheese and bacon',
      'price': 38.75,
      'isFavorite': false,
    },
    {
      'name': 'Chicken Rice Bowl',
      'image': 'assets/images/chickenRice_bowl.jpg',
      'description': 'Grilled chicken with steamed rice and vegetables',
      'price': 22.00,
      'isFavorite': false,
    },
  ];

  final List<Map<String, dynamic>> _blackPinoyItems = [
    {
      'name': 'Beef Bulalo',
      'image': 'assets/images/beef_bulalo.jpg',
      'description': 'Classic Filipino beef soup with bone marrow.',
      'price': 55.00,
      'isFavorite': false,
    },
    {
      'name': 'Beef Kare-Kare',
      'image': 'assets/images/beef_kare-kare.jpg',
      'description': 'Rich peanut stew with tender beef and vegetables.',
      'price': 50.00,
      'isFavorite': false,
    },
    {
      'name': 'Beef Sisig',
      'image': 'assets/images/beef_sisig.jpg',
      'description': 'Sizzling chopped beef with onions and chili.',
      'price': 45.00,
      'isFavorite': false,
    },
    {
      'name': 'Buttered Chicken',
      'image': 'assets/images/buttered_chicken.jpg',
      'description': 'Crispy fried chicken tossed in butter sauce.',
      'price': 38.00,
      'isFavorite': false,
    },
  ];

  final List<Map<String, dynamic>> _sarapInasalItems = [
    {
      'name': 'Fried Rice',
      'image': 'assets/images/fried_rice.jpg',
      'description': 'Delicious fried rice with vegetables, eggs, and special seasonings.',
      'price': 18.00,
      'isFavorite': false,
    },
    {
      'name': 'Sinigang na Salmon',
      'image': 'assets/images/sinigang_salmon.jpg',
      'description': 'Sour tamarind soup with fresh salmon and vegetables.',
      'price': 45.00,
      'isFavorite': false,
    },
    {
      'name': 'Chicharon Bulaklak',
      'image': 'assets/images/chicharon_bulaklak.jpg',
      'description': 'Crispy pork rinds made from pork intestines, perfect appetizer.',
      'price': 25.00,
      'isFavorite': false,
    },
    {
      'name': 'Mixed Seafoods',
      'image': 'assets/images/mixed_seafoods.jpg',
      'description': 'Fresh seafood medley with shrimp, fish, and calamari.',
      'price': 55.00,
      'isFavorite': false,
    },
  ];

  final List<Map<String, String>> _merchants = [
    {'name': 'Black Pinoy', 'image': 'assets/images/blackPinoy_logo.jpg'},
    {'name': 'Sarap Inasal', 'image': 'assets/images/sarapInasal_logo.jpg'},
  ];

  late final PageController _pageController;
  int _currentPage = 0;
  int _currentIndex = 0; // For bottom navigation
  Timer? _carouselTimer;

  // Cart functionality
  final List<Map<String, dynamic>> _cartItems = [];
  int _cartCount = 0; // For cart badge

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1000); // Start from middle for infinite scroll
    _startCarouselTimer();
    // Show welcome notification
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome, ${widget.userName}!')),
      );
    });
  }

  void _startCarouselTimer() {
    _carouselTimer?.cancel();
    _carouselTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients && mounted) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onCarouselIndexChanged(int index) {
    if (mounted) {
      setState(() {
        _currentPage = index % _carouselImages.length;
      });
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _carouselTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onCartPressed() {
    _showCartPage();
  }

  void _addToCart(Map<String, dynamic> item, List<Map<String, dynamic>> addOns) {
    // Check if item with same add-ons exists
    final existingIndex = _cartItems.indexWhere((cartItem) {
      if (cartItem['name'] != item['name']) return false;
      final cartAddOns = cartItem['addOns'] as List<Map<String, dynamic>>? ?? [];
      if (cartAddOns.length != addOns.length) return false;
      for (int i = 0; i < cartAddOns.length; i++) {
        if (cartAddOns[i]['name'] != addOns[i]['name'] || cartAddOns[i]['price'] != addOns[i]['price']) {
          return false;
        }
      }
      return true;
    });
    if (existingIndex != -1) {
      setState(() {
        _cartItems[existingIndex]['quantity'] = (_cartItems[existingIndex]['quantity'] ?? 1) + 1;
        _cartCount++;
      });
    } else {
      setState(() {
        _cartItems.add({
          'name': item['name'],
          'image': item['image'],
          'price': item['price'],
          'addOns': List<Map<String, dynamic>>.from(addOns),
          'quantity': 1,
        });
        _cartCount++;
      });
    }
  }

  double _getTotalPrice() {
    return _cartItems.fold(0.0, (total, item) {
      return total + (item['price'] * (item['quantity'] ?? 1));
    });
  }

  void _onAvatarPressed() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profile pressed!')));
  }

  void _toggleFavorite(int index) {
    setState(() {
      _recommendedItems[index]['isFavorite'] = !_recommendedItems[index]['isFavorite'];
    });
  }

  void _toggleBlackPinoyFavorite(int index) {
    setState(() {
      _blackPinoyItems[index]['isFavorite'] = !_blackPinoyItems[index]['isFavorite'];
    });
  }

  void _toggleSarapInasalFavorite(int index) {
    setState(() {
      _sarapInasalItems[index]['isFavorite'] = !_sarapInasalItems[index]['isFavorite'];
    });
  }

  void _onNavigationTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    if (index == 1) {
      // Favorites page
      _showFavoritesPage();
    } else if (index == 2) {
      // Profile page
      _showProfilePage();
    }
  }

  void _showFavoritesPage() {
    final allItems = [..._recommendedItems, ..._blackPinoyItems, ..._sarapInasalItems];
    final favorites = allItems.where((item) => item['isFavorite'] == true).toList();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Favorites',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (favorites.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'No favorites yet!\nTap the heart icon to add items to your favorites.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final item = favorites[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            item['image'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          item['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('SAR ${item['price'].toStringAsFixed(2)}'),
                        trailing: IconButton(
                          onPressed: () {
                            // Find which list the item belongs to and toggle accordingly
                            if (_recommendedItems.contains(item)) {
                              _toggleFavorite(_recommendedItems.indexOf(item));
                            } else if (_blackPinoyItems.contains(item)) {
                              _toggleBlackPinoyFavorite(_blackPinoyItems.indexOf(item));
                            } else if (_sarapInasalItems.contains(item)) {
                              _toggleSarapInasalFavorite(_sarapInasalItems.indexOf(item));
                            }
                          },
                          icon: Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showProfilePage() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Guest User',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'guest@example.com',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            const ListTile(
              leading: Icon(Icons.help),
              title: Text('Help & Support'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            const ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
    );
  }

  void _showCartPage() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'My Cart',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (_cartItems.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Your cart is empty!\nAdd some delicious items to get started.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: _cartItems.length,
                            itemBuilder: (context, index) {
                              final item = _cartItems[index];
                              final quantity = item['quantity'] ?? 1;
                              final addOns = item['addOns'] as List<Map<String, dynamic>>? ?? [];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          item['image'],
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['name'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            if (addOns.isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(top: 4),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: addOns.map((addOn) => Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        '+ ${addOn['name']}',
                                                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                                                      ),
                                                      Text(
                                                        'SAR ${addOn['price'].toStringAsFixed(2)}',
                                                        style: const TextStyle(fontSize: 13, color: Color(0xFFd00000)),
                                                      ),
                                                    ],
                                                  )).toList(),
                                                ),
                                              ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'SAR ${item['price'].toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                color: Color(0xFFd00000),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                if (quantity - 1 <= 0) {
                                                  _cartItems.removeAt(index);
                                                  _cartCount = _cartCount > 0 ? _cartCount - 1 : 0;
                                                } else {
                                                  _cartItems[index]['quantity'] = quantity - 1;
                                                  _cartCount = _cartCount > 0 ? _cartCount - 1 : 0;
                                                }
                                              });
                                              setModalState(() {});
                                            },
                                            icon: const Icon(Icons.remove_circle_outline),
                                            color: const Color(0xFFd00000),
                                          ),
                                          Text(
                                            '$quantity',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _cartItems[index]['quantity'] = quantity + 1;
                                                _cartCount++;
                                              });
                                              setModalState(() {});
                                            },
                                            icon: const Icon(Icons.add_circle_outline),
                                            color: const Color(0xFFd00000),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        // Total and checkout section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'SAR ${_getTotalPrice().toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFd00000),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close cart modal first
                                    Future.delayed(const Duration(milliseconds: 300), () {
                                      _showCheckoutDetailsModal();
                                    });
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
                                    'Checkout',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
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
                    // Overlay Row with only the close button on the right
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
                                  color: Colors.black.withAlpha((255 * 0.08).round()),
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
                              _addToCart(foodItem, selectedAddOns);
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

  // Add the new method to show the checkout details modal
  void _showCheckoutDetailsModal() {
    String address = '';
    String paymentMethod = '';
    String onlinePaymentType = '';
    final addressController = TextEditingController();
    String error = ''; // Move error here, outside the builder
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            double totalPrice = _getTotalPrice();
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.85,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Checkout Details',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Delivery Address',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: addressController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your delivery address',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) {
                            setModalState(() {
                              address = val;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Payment Method',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Online',
                              groupValue: paymentMethod,
                              onChanged: (val) {
                                setModalState(() {
                                  paymentMethod = val!;
                                  onlinePaymentType = '';
                                });
                              },
                            ),
                            const Text('Online'),
                            const SizedBox(width: 16),
                            Radio<String>(
                              value: 'Cash on Delivery',
                              groupValue: paymentMethod,
                              onChanged: (val) {
                                setModalState(() {
                                  paymentMethod = val!;
                                  onlinePaymentType = '';
                                });
                              },
                            ),
                            const Text('Cash on Delivery'),
                          ],
                        ),
                        if (paymentMethod == 'Online') ...[
                          const SizedBox(height: 8),
                          const Text('Select Online Payment Type:', style: TextStyle(fontWeight: FontWeight.w500)),
                          Wrap(
                            spacing: 12,
                            children: [
                              ChoiceChip(
                                label: const Text('Card'),
                                selected: onlinePaymentType == 'Card',
                                onSelected: (selected) {
                                  setModalState(() {
                                    onlinePaymentType = 'Card';
                                  });
                                },
                              ),
                              ChoiceChip(
                                label: const Text('Mada'),
                                selected: onlinePaymentType == 'Mada',
                                onSelected: (selected) {
                                  setModalState(() {
                                    onlinePaymentType = 'Mada';
                                  });
                                },
                              ),
                              ChoiceChip(
                                label: const Text('STC Pay'),
                                selected: onlinePaymentType == 'STC Pay',
                                onSelected: (selected) {
                                  setModalState(() {
                                    onlinePaymentType = 'STC Pay';
                                  });
                                },
                              ),
                              ChoiceChip(
                                label: const Text('Bank Transfer'),
                                selected: onlinePaymentType == 'Bank Transfer',
                                onSelected: (selected) {
                                  setModalState(() {
                                    onlinePaymentType = 'Bank Transfer';
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 20),
                        const Text(
                          'Order Summary',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _cartItems.length,
                            itemBuilder: (context, index) {
                              final item = _cartItems[index];
                              final addOns = item['addOns'] as List<Map<String, dynamic>>? ?? [];
                              final quantity = item['quantity'] ?? 1;
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      item['image'],
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (addOns.isNotEmpty)
                                        ...addOns.map((addOn) => Text(
                                          '+ ${addOn['name']} (SAR ${addOn['price'].toStringAsFixed(2)})',
                                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                                        )),
                                      Text('Qty: $quantity', style: const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                  trailing: Text(
                                    'SAR ${(item['price'] * quantity).toStringAsFixed(2)}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFd00000)),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total:',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'SAR ${totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFd00000)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (addressController.text.trim().isEmpty) {
                                setModalState(() {
                                  error = 'Please enter your delivery address.';
                                });
                                return;
                              }
                              if (paymentMethod.isEmpty) {
                                setModalState(() {
                                  error = 'Please select a payment method.';
                                });
                                return;
                              }
                              if (paymentMethod == 'Online' && onlinePaymentType.isEmpty) {
                                setModalState(() {
                                  error = 'Please select an online payment type.';
                                });
                                return;
                              }
                              if (paymentMethod == 'Online') {
                                Navigator.pop(context); // Close checkout modal
                                Future.delayed(const Duration(milliseconds: 300), () {
                                  _showOnlinePaymentModal(onlinePaymentType);
                                });
                                return;
                              }
                              // Cash on Delivery: Place order directly
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Order placed successfully!'),
                                  backgroundColor: Color(0xFFd00000),
                                ),
                              );
                              setState(() {
                                _cartItems.clear();
                                _cartCount = 0;
                              });
                              Navigator.of(context).popUntil((route) => route.isFirst);
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
                              'Place Your Order',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (error.isNotEmpty)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.25), // Dim background
                        child: Center(
                          child: Container(
                            width: 220,
                            height: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(0xFFd00000),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha((255 * 0.08).round()),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text(
                                      error,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      setModalState(() {
                                        error = '';
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(2),
                                      child: const Icon(Icons.close, size: 18, color: Color(0xFFd00000)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Add the new method for online payment modal
  void _showOnlinePaymentModal(String paymentType) {
    final cardController = TextEditingController();
    final expiryController = TextEditingController();
    final cvvController = TextEditingController();
    final nameController = TextEditingController();
    bool isProcessing = false;
    String error = '';
    final double totalPrice = _getTotalPrice();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          paymentType == 'Card'
                              ? 'Card Payment'
                              : paymentType == 'Mada'
                                  ? 'Mada Payment'
                                  : paymentType == 'STC Pay'
                                      ? 'STC Pay Payment'
                                      : 'Bank Transfer',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Show total amount to pay
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Amount to Pay: SAR ${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFd00000),
                        ),
                      ),
                    ),
                    if (paymentType == 'Card' || paymentType == 'Mada') ...[
                      TextField(
                        controller: cardController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Card Number',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: expiryController,
                              keyboardType: TextInputType.datetime,
                              decoration: const InputDecoration(
                                labelText: 'Expiry (MM/YY)',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: cvvController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'CVV',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Cardholder Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ] else if (paymentType == 'STC Pay') ...[
                      const Text('You will be redirected to STC Pay to complete your payment.', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 24),
                    ] else if (paymentType == 'Bank Transfer') ...[
                      const Text('Please transfer the total amount to the following bank account:', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 12),
                      const Text('Bank: Mappia Bank\nAccount: 1234567890\nIBAN: SA0000000000000000000000', style: TextStyle(fontSize: 15)),
                      const SizedBox(height: 24),
                    ],
                    if (error.isNotEmpty) ...[
                      Text(error, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 8),
                    ],
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isProcessing
                            ? null
                            : () async {
                                setModalState(() {
                                  isProcessing = true;
                                  error = '';
                                });
                                await Future.delayed(const Duration(seconds: 2)); // Simulate payment
                                // Simulate validation
                                if (paymentType == 'Card' || paymentType == 'Mada') {
                                  if (cardController.text.length < 12 || expiryController.text.isEmpty || cvvController.text.length < 3 || nameController.text.isEmpty) {
                                    setModalState(() {
                                      error = 'Please enter valid card details.';
                                      isProcessing = false;
                                    });
                                    return;
                                  }
                                }
                                // Simulate random payment failure (10% chance)
                                if (DateTime.now().millisecondsSinceEpoch % 10 == 0) {
                                  setModalState(() {
                                    error = 'Payment failed. Please try again.';
                                    isProcessing = false;
                                  });
                                  return;
                                }
                                // Success
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Payment successful! Your order has been placed.'),
                                    backgroundColor: Color(0xFFd00000),
                                  ),
                                );
                                setState(() {
                                  _cartItems.clear();
                                  _cartCount = 0;
                                });
                                Navigator.of(context).popUntil((route) => route.isFirst);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFd00000),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isProcessing
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                paymentType == 'STC Pay'
                                    ? 'Continue to STC Pay'
                                    : paymentType == 'Bank Transfer'
                                        ? 'I have transferred'
                                        : 'Pay Now',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top section with red background
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingMedium,
                    vertical: AppConstants.paddingMedium,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusMedium,
                            ),
                            border: Border.all(
                              color: const Color(0xFFd00000),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha((255 * 0.04).round()),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _locationController,
                            decoration: InputDecoration(
                              hintText: 'Enter your location',
                              prefixIcon: const Icon(
                                Icons.location_on_outlined,
                                color: Color(0xFFd00000),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                            onSubmitted: (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Searching near: $value')),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      GestureDetector(
                        onTap: _onAvatarPressed,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: const Icon(
                            Icons.person,
                            color: Color(0xFFd00000),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      GestureDetector(
                        onTap: _onCartPressed,
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFd00000),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha((255 * 0.04).round()),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.shopping_cart_outlined,
                                color: Color(0xFFd00000),
                              ),
                            ),
                            if (_cartCount > 0)
                              Positioned(
                                right: 2,
                                top: 2,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFd00000),
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    '$_cartCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 264,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      onPageChanged: _onCarouselIndexChanged,
                      itemCount: null, // Infinite scroll
                      itemBuilder: (context, index) {
                        final imageIndex = index % _carouselImages.length;
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: 264,
                          child: Stack(
                            children: [
                              Image.asset(
                                _carouselImages[imageIndex],
                                width: MediaQuery.of(context).size.width,
                                height: 264,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Colors.grey[200],
                                  child: const Center(child: Icon(Icons.broken_image)),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 264,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      Colors.black.withAlpha((255 * 0.6).round()),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    // Text overlay on bottom left
                    Positioned(
                      bottom: 40,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Craving something?",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              shadows: [
                                Shadow(
                                  offset: const Offset(1, 1),
                                  blurRadius: 3,
                                  color: Colors.black.withAlpha((255 * 0.8).round()),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Let Mappia deliver it fast!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              shadows: [
                                Shadow(
                                  offset: const Offset(1, 1),
                                  blurRadius: 3,
                                  color: Colors.black.withAlpha((255 * 0.8).round()),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Indicator dots
                    Positioned(
                      bottom: 12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _carouselImages.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 20 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? AppConstants.primaryColor
                                  : const Color.fromRGBO(255, 255, 255, 0.7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // We offer section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                  vertical: AppConstants.paddingMedium,
                ),
                child: Column(
                  children: [
                    // Header row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'We offer',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewAllScreen(
                                  cartItems: _cartItems,
                                  onAddToCart: _addToCart,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'View all',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppConstants.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Horizontal scrollable food cards
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _foodItems.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 115,
                            margin: const EdgeInsets.only(right: 5),
                            child: Column(
                              children: [
                                Container(
                                  width: 95,
                                  height: 95,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha((255 * 0.1).round()),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      _foodItems[index]['image']!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        color: Colors.grey[200],
                                        child: const Center(child: Icon(Icons.broken_image)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _foodItems[index]['name']!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Recommended for you section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                  vertical: AppConstants.paddingMedium,
                ),
                child: Column(
                  children: [
                    // Header row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recommended for you',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Horizontal scrollable recommended food cards
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.0, // Increased from 0.85 to make cards shorter
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: _recommendedItems.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _showFoodDetailsModal(_recommendedItems[index]),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
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
                                // Food image with heart icon
                                Stack(
                                  children: [
                                    Container(
                                      height: 100, // Increased from 80 to 100
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
                                          _recommendedItems[index]['image'],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            color: Colors.grey[200],
                                            child: const Center(child: Icon(Icons.broken_image)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Heart icon overlay
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () => _toggleFavorite(index),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withAlpha((255 * 0.9).round()),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            _recommendedItems[index]['isFavorite'] 
                                                ? Icons.favorite 
                                                : Icons.favorite_border,
                                            size: 16,
                                            color: const Color(0xFFd00000),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Food details
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4), // Reduced from 6 to 4 (33% reduction)
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Food name
                                        Text(
                                          _recommendedItems[index]['name'],
                                          style: const TextStyle(
                                            fontSize: 12, // Reduced font size
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        // Food description (removed spacing)
                                        Expanded(
                                          child: Text(
                                            _recommendedItems[index]['description'],
                                            style: const TextStyle(
                                              fontSize: 10, // Reduced font size
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        // Price and add button row (removed spacing)
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Price
                                            Expanded(
                                              child: Text(
                                                'SAR ${_recommendedItems[index]['price'].toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  fontSize: 12, // Reduced font size
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xFFd00000),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            // Add to cart button
                                            GestureDetector(
                                              onTap: () {
                                                _addToCart(_recommendedItems[index], []);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('${_recommendedItems[index]['name']} added to cart!'),
                                                    backgroundColor: const Color(0xFFd00000),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFd00000),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                  size: 14,
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
                    const SizedBox(height: 16),
                    // See more button below the cards
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('See more pressed!')),
                          );
                        },
                        child: const Text(
                          'See more',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFd00000),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Merchants section
              const SizedBox(height: 24),
              Column(
                children: List.generate(_merchants.length, (merchantIndex) {
                  final merchant = _merchants[merchantIndex];
                  final items = merchantIndex == 0 ? _blackPinoyItems : _sarapInasalItems;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Show 'Merchants' only for the first merchant
                        if (merchantIndex == 0)
                          Text(
                            'Merchants',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        if (merchantIndex == 0) const SizedBox(height: 12),
                        // Merchant logo
                        if (merchantIndex == 0)
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.asset(
                                merchant['image']!,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Colors.grey[200],
                                  width: 120,
                                  height: 120,
                                  child: const Center(child: Icon(Icons.broken_image, size: 48)),
                                ),
                              ),
                            ),
                          )
                        else
                          Center(
                            child: Image.asset(
                              merchant['image']!,
                              width: 120,
                              height: 138,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.grey[200],
                                width: 120,
                                height: 138,
                                child: const Center(child: Icon(Icons.broken_image, size: 48)),
                              ),
                            ),
                          ),
                        SizedBox(height: merchantIndex == 0 ? 12 : 4),
                        // Logo name (repeat merchant name)
                        Text(
                          merchant['name']!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        // Product cards grid (2x2)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.0,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: (items.length > 4) ? 4 : items.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => _showFoodDetailsModal(items[index]),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 6),
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
                                      // Food image (match recommended section)
                                      Stack(
                                        children: [
                                          Container(
                                            height: 100,
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
                                                items[index]['image'],
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                errorBuilder: (context, error, stackTrace) => Container(
                                                  color: Colors.grey[200],
                                                  child: const Center(child: Icon(Icons.broken_image)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Heart icon overlay
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: GestureDetector(
                                              onTap: () {
                                                if (merchantIndex == 0) {
                                                  _toggleBlackPinoyFavorite(index);
                                                } else {
                                                  _toggleSarapInasalFavorite(index);
                                                }
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withAlpha((255 * 0.9).round()),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  items[index]['isFavorite'] 
                                                      ? Icons.favorite 
                                                      : Icons.favorite_border,
                                                  size: 16,
                                                  color: const Color(0xFFd00000),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Food details
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(4), // Match recommended section
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                items[index]['name'],
                                                style: const TextStyle(
                                                  fontSize: 12, // Match recommended section
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black87,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  items[index]['description'],
                                                  style: const TextStyle(
                                                    fontSize: 10, // Match recommended section
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'SAR ${items[index]['price'].toStringAsFixed(2)}',
                                                      style: const TextStyle(
                                                        fontSize: 12, // Match recommended section
                                                        fontWeight: FontWeight.w700,
                                                        color: Color(0xFFd00000),
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  GestureDetector(
                                                    onTap: () {
                                                      _addToCart(items[index], []);
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text('${items[index]['name']} added to cart!'),
                                                          backgroundColor: const Color(0xFFd00000),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.all(4),
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xFFd00000),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: const Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                        size: 14,
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
                        const SizedBox(height: 16),
                        // Show more products button
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Show more products pressed!')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFd00000),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              'Show more products',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              // Add bottom padding for navigation bar
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFd00000),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onNavigationTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFFd00000),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withAlpha((255 * 0.7).round()),
          elevation: 0,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          iconSize: 20,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

