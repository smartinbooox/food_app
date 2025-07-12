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
    'Dinner',
    'Breakfast',
    'Lunch',
    'Snacks',
    'Desserts',
    'Drinks',
  ];

  final List<Map<String, dynamic>> _allFoodItems = [
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
    {
      'name': 'Bangsilog',
      'image': 'assets/images/bangsilog.jpg',
      'description': 'Crispy fried bangus, garlic rice, and a sunny-side egg — a classic Filipino breakfast that hits the spot any time of day!',
      'price': 25.00,
      'rating': 4.4,
      'reviewCount': 45,
      'category': 'Breakfast',
      'merchant': 'Black Pinoy',
    },
    {
      'name': 'Beef Broccoli',
      'image': 'assets/images/beef_broccoli.jpg',
      'description': 'Tender slices of beef wok‑tossed with crisp broccoli florets in a savory garlic‑soy sauce.',
      'price': 30.00,
      'rating': 4.3,
      'reviewCount': 58,
      'category': 'Dinner',
      'merchant': 'Black Pinoy',
    },
    {
      'name': 'Chicken Inasal',
      'image': 'assets/images/chicken_inasal.jpg',
      'description': 'Juicy, grilled chicken marinated in calamansi, garlic, and annatto oil — flame-grilled to smoky perfection.',
      'price': 25.00,
      'rating': 4.5,
      'reviewCount': 78,
      'category': 'Dinner',
      'merchant': 'Black Pinoy',
    },
    {
      'name': 'Halo-halo',
      'image': 'assets/images/halo-halo.jpg',
      'description': 'A colorful Filipino dessert with crushed ice, creamy leche flan, sweet beans, ube, and gulaman — all mixed for the ultimate icy treat!',
      'price': 15.00,
      'rating': 4.6,
      'reviewCount': 92,
      'category': 'Dessert',
      'merchant': 'Black Pinoy',
    },
    {
      'name': 'Fried Chicken',
      'image': 'assets/images/fried_chicken_blackpinoy.jpg',
      'description': 'Crispy on the outside, tender and juicy on the inside — our classic fried chicken is seasoned to perfection and fried golden brown.',
      'price': 20.00,
      'rating': 4.4,
      'reviewCount': 156,
      'category': 'Dinner',
      'merchant': 'Black Pinoy',
    },
    {
      'name': 'Garlic Fried Rice',
      'image': 'assets/images/garlic_friedrice.jpg',
      'description': 'Aromatic rice stir-fried with golden garlic bits — simple, savory, and the perfect pairing for any meal!',
      'price': 10.00,
      'rating': 4.3,
      'reviewCount': 89,
      'category': 'Lunch',
      'merchant': 'Black Pinoy',
    },
    {
      'name': 'Laing',
      'image': 'assets/images/Laing.jpg',
      'description': 'A rich, creamy Bicolano dish made with dried taro leaves simmered in coconut milk, chilies, and spices — earthy, spicy, and unforgettable.',
      'price': 20.00,
      'rating': 4.2,
      'reviewCount': 67,
      'category': 'Dinner',
      'merchant': 'Black Pinoy',
    },
    {
      'name': 'Leche Flan',
      'image': 'assets/images/leche_flan.jpg',
      'description': 'A silky smooth caramel custard made with eggs, milk, and sugar — the perfect sweet ending to any Filipino meal.',
      'price': 20.00,
      'rating': 4.7,
      'reviewCount': 134,
      'category': 'Dessert',
      'merchant': 'Black Pinoy',
    },
    {
      'name': 'Lomi',
      'image': 'assets/images/Lomi.jpg',
      'description': 'Thick egg noodles in a savory, hearty broth loaded with pork, vegetables, and egg — a warm, comforting Filipino favorite best enjoyed hot!',
      'price': 25.00,
      'rating': 4.5,
      'reviewCount': 98,
      'category': 'Dinner',
      'merchant': 'Black Pinoy',
    },
    {
      'name': 'Pancit Canton',
      'image': 'assets/images/pancit_canton.jpg',
      'description': 'Stir-fried egg noodles tossed with vegetables, meat, and a flavorful soy-garlic sauce — a delicious Filipino staple perfect for any celebration!',
      'price': 20.00,
      'rating': 4.4,
      'reviewCount': 112,
      'category': 'Dinner',
      'merchant': 'Black Pinoy',
    },
    {
      'name': 'Samalamig',
      'image': 'assets/images/samalamig.jpg',
      'description': 'A sweet, refreshing Filipino drink made with gulaman, sago, and flavored syrup — perfect to cool you down any time of the day!',
      'price': 10.00,
      'rating': 4.3,
      'reviewCount': 76,
      'category': 'Drinks',
      'merchant': 'Black Pinoy',
    },
    {
      'name': 'Steamed Siomai',
      'image': 'assets/images/steamed_siomai.jpg',
      'description': 'Tender dumplings filled with seasoned meat and vegetables, steamed to juicy perfection — served with soy sauce, calamansi, and chili garlic oil.',
      'price': 12.00,
      'rating': 4.6,
      'reviewCount': 145,
      'category': 'Snack',
      'merchant': 'Black Pinoy',
    },
    {
      'name': 'Sweet and Sour Tilapia',
      'image': 'assets/images/sweet_sour_tilapia.jpg',
      'description': 'Crispy-fried tilapia topped with a vibrant sweet and sour sauce made with bell peppers, onions, and pineapples — a tangy twist you\'ll crave again and again!',
      'price': 30.00,
      'rating': 4.4,
      'reviewCount': 88,
      'category': 'Dinner',
      'merchant': 'Black Pinoy',
    },
    {
      'name': 'Tofu Sisig',
      'image': 'assets/images/tofu_sisig.jpg',
      'description': 'Sizzling tofu cubes tossed in a creamy, spicy sisig sauce with onions and chili — a guilt-free, flavorful plant-based take on a Filipino favorite.',
      'price': 18.00,
      'rating': 4.2,
      'reviewCount': 54,
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
    {
      'name': 'Tapsilog',
      'image': 'assets/images/Tapsilog.jpg',
      'description': 'Tender beef tapa marinated in sweet and savory spices, served with garlic fried rice and a perfectly cooked sunny-side egg — a classic Filipino all-day breakfast!',
      'price': 20.00,
      'rating': 4.5,
      'reviewCount': 78,
      'category': 'Breakfast',
      'merchant': 'Sarap Inasal',
    },
    {
      'name': 'Sinigang Spare Ribs',
      'image': 'assets/images/sinigang_spare-ribs.jpg',
      'description': 'A comforting bowl of sour tamarind broth loaded with fall-off-the-bone beef spare ribs, fresh vegetables, and just the right level of tang — the ultimate Filipino comfort food.',
      'price': 35.00,
      'rating': 4.6,
      'reviewCount': 92,
      'category': 'Dinner',
      'merchant': 'Sarap Inasal',
    },
    {
      'name': 'Beef Bulalo',
      'image': 'assets/images/bulalo_sarap-inasal.jpg',
      'description': 'A rich, slow-cooked beef shank soup with bone marrow, corn, cabbage, and vegetables — warm, hearty, and perfect for sharing!',
      'price': 35.00,
      'rating': 4.8,
      'reviewCount': 89,
      'category': 'Dinner',
      'merchant': 'Sarap Inasal',
    },
    {
      'name': 'Beef Sisig',
      'image': 'assets/images/sisig-sarap-inasal.jpg',
      'description': 'Sizzling chopped beef seasoned with onions, chili, and calamansi — served on a hot plate for that irresistible smoky flavor and crunch!',
      'price': 30.00,
      'rating': 4.6,
      'reviewCount': 92,
      'category': 'Dinner',
      'merchant': 'Sarap Inasal',
    },
    {
      'name': 'Halo-Halo',
      'image': 'assets/images/Halo-Halo_sarapinasal.jpg',
      'description': 'A colorful Filipino dessert layered with crushed ice, sweetened fruits, gulaman, leche flan, and ube — topped with evaporated milk for a truly refreshing treat!',
      'price': 18.00,
      'rating': 4.6,
      'reviewCount': 92,
      'category': 'Dessert',
      'merchant': 'Sarap Inasal',
    },
    {
      'name': 'Buttered Chicken',
      'image': 'assets/images/buttered_chicken-sarapinasal.png',
      'description': 'Crispy fried chicken glazed in a rich, buttery garlic sauce — savory, sweet, and addictively good with every bite!',
      'price': 28.00,
      'rating': 4.5,
      'reviewCount': 67,
      'category': 'Dinner',
      'merchant': 'Sarap Inasal',
    },
    {
      'name': 'Fried Boneless Bangus',
      'image': 'assets/images/boneless-bangus.jpg',
      'description': 'Crispy, golden-fried boneless milkfish seasoned to perfection — flaky, flavorful, and mess-free for an easy, delicious meal.',
      'price': 25.00,
      'rating': 4.4,
      'reviewCount': 45,
      'category': 'Dinner',
      'merchant': 'Sarap Inasal',
    },
    {
      'name': 'Grilled T-bone Steak',
      'image': 'assets/images/t-bone-steak.jpg',
      'description': 'Juicy, tender T-bone steak grilled just right, seasoned with herbs and served with your choice of sides — a hearty feast for steak lovers.',
      'price': 90.00,
      'rating': 4.9,
      'reviewCount': 156,
      'category': 'Dinner',
      'merchant': 'Sarap Inasal',
    },
    {
      'name': 'Lomi',
      'image': 'assets/images/Lomi-sarapinasal.jpg',
      'description': 'Thick, hearty egg noodles swimming in a rich, savory broth loaded with tender meat, veggies, and egg — the ultimate Filipino comfort soup.',
      'price': 25.00,
      'rating': 4.5,
      'reviewCount': 98,
      'category': 'Dinner',
      'merchant': 'Sarap Inasal',
    },
    {
      'name': 'Milktea',
      'image': 'assets/images/milktea.jpg',
      'description': 'Creamy, refreshing milk tea with chewy tapioca pearls — a perfect sweet treat to sip anytime, anywhere.',
      'price': 15.00,
      'rating': 4.3,
      'reviewCount': 76,
      'category': 'Drinks',
      'merchant': 'Sarap Inasal',
    },
    {
      'name': 'Pancit Batil Patung',
      'image': 'assets/images/pancit_batil_patung.jpg',
      'description': 'A traditional Filipino noodle dish featuring sautéed vegetables, savory meat strips, and a flavorful sauce — a wholesome, satisfying meal full of local flavors.',
      'price': 20.00,
      'rating': 4.4,
      'reviewCount': 112,
      'category': 'Dinner',
      'merchant': 'Sarap Inasal',
    },
    {
      'name': 'Pancit Palabok',
      'image': 'assets/images/palabok.jpg',
      'description': 'Rice noodles topped with a rich, garlicky shrimp sauce, crunchy chicharrón, boiled eggs, and fresh green onions — a classic crowd-pleaser bursting with flavor!',
      'price': 25.00,
      'rating': 4.7,
      'reviewCount': 134,
      'category': 'Dinner',
      'merchant': 'Sarap Inasal',
    },
    {
      'name': 'Filipino Spaghetti',
      'image': 'assets/images/pinoy_spaghetti.jpg',
      'description': 'Sweet-style spaghetti loaded with savory ground meat, sliced hotdogs, and a rich, tangy tomato sauce — a Filipino party favorite loved by kids and adults alike.',
      'price': 20.00,
      'rating': 4.5,
      'reviewCount': 145,
      'category': 'Dinner',
      'merchant': 'Sarap Inasal',
    },
    {
      'name': 'Balbacua',
      'image': 'assets/images/balbacua.jpg',
      'description': 'Slow-cooked beef stew simmered until tender with rich spices and collagen-rich tendons — a hearty, flavorful dish perfect for meat lovers craving deep Filipino flavors.',
      'price': 40.00,
      'rating': 4.6,
      'reviewCount': 88,
      'category': 'Dinner',
      'merchant': 'Sarap Inasal',
    },
    {
      'name': 'Sinigang na Hipon',
      'image': 'assets/images/sinigang-hipon.jpg',
      'description': 'A tangy tamarind-based soup loaded with fresh, juicy shrimp and crisp vegetables — a comforting Filipino classic that\'s both flavorful and refreshing.',
      'price': 28.00,
      'rating': 4.4,
      'reviewCount': 88,
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
      // Show all items (already filtered by search) - sort alphabetically
      filteredItems.sort((a, b) => a['name'].toString().compareTo(b['name'].toString()));
      return filteredItems;
    } else if (_selectedCategoryIndex == 1) {
      // Black Pinoy
      filteredItems = filteredItems.where((item) => item['merchant'] == 'Black Pinoy').toList();
      filteredItems.sort((a, b) => a['name'].toString().compareTo(b['name'].toString()));
      return filteredItems;
    } else if (_selectedCategoryIndex == 2) {
      // Sarap Inasal
      filteredItems = filteredItems.where((item) => item['merchant'] == 'Sarap Inasal').toList();
      filteredItems.sort((a, b) => a['name'].toString().compareTo(b['name'].toString()));
      return filteredItems;
    } else {
      // Filter by selected category, mapping plural to singular where needed
      String selectedCategory = _categories[_selectedCategoryIndex];
      if (selectedCategory == 'Desserts') selectedCategory = 'Dessert';
      filteredItems = filteredItems.where((item) => item['category'] == selectedCategory).toList();
      filteredItems.sort((a, b) => a['name'].toString().compareTo(b['name'].toString()));
      return filteredItems;
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
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar (moved up, less vertical padding)
            Container(
              color: AppConstants.primaryColor,
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
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppConstants.primaryColor,
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
              color: AppConstants.primaryColor,
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
                            color: isSelected ? AppConstants.primaryColor : Colors.white,
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
                                            : AppConstants.primaryColor.withAlpha(204),
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
                                              : AppConstants.primaryColor,
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
                                        color: Colors.black54,
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
                                          style: TextStyle(
                                            fontSize: 13, // reduced from 14
                                            fontWeight: FontWeight.bold,
                                            color: AppConstants.primaryColor,
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Added ${foodItem['name']} to cart!'),
                                  backgroundColor: AppConstants.primaryColor,
                                ),
                              );
                              Navigator.of(context).popUntil((route) => route.isFirst);
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
