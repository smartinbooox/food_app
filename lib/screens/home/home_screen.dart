import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Mappia'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // TODO: Navigate to cart
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // TODO: Navigate to profile
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to Mappia!',
                      style: AppConstants.headingStyle,
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    Text(
                      'Discover delicious food from the best restaurants in your area.',
                      style: AppConstants.bodyStyle,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),

            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for restaurants or dishes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusMedium,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),

            // Categories Section
            Text(
              'Categories',
              style: AppConstants.subheadingStyle,
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryCard('Fast Food', Icons.fastfood, Colors.orange),
                  _buildCategoryCard('Pizza', Icons.local_pizza, Colors.red),
                  _buildCategoryCard('Asian', Icons.rice_bowl, Colors.green),
                  _buildCategoryCard('Desserts', Icons.cake, Colors.pink),
                  _buildCategoryCard('Healthy', Icons.favorite, Colors.teal),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),

            // Popular Restaurants Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular Restaurants',
                  style: AppConstants.subheadingStyle,
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to all restaurants
                  },
                  child: Text(
                    'View All',
                    style: TextStyle(color: AppConstants.primaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingSmall),

            // Restaurant Cards
            Expanded(
              child: ListView(
                children: [
                  _buildRestaurantCard(
                    'Pizza Palace',
                    'Delicious pizzas and Italian cuisine',
                    '4.5',
                    '30-45 min',
                    'assets/images/pizza.jpg',
                  ),
                  _buildRestaurantCard(
                    'Burger House',
                    'Juicy burgers and fast food',
                    '4.3',
                    '20-30 min',
                    'assets/images/burger.jpg',
                  ),
                  _buildRestaurantCard(
                    'Sushi Express',
                    'Fresh sushi and Japanese cuisine',
                    '4.7',
                    '25-40 min',
                    'assets/images/sushi.jpg',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await AuthService.signOut();
        },
        backgroundColor: AppConstants.errorColor,
        child: const Icon(Icons.logout, color: Colors.white),
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, Color color) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: AppConstants.paddingMedium),
      child: Card(
        child: InkWell(
          onTap: () {
            // TODO: Navigate to category
          },
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: color,
                ),
                const SizedBox(height: AppConstants.paddingSmall),
                Text(
                  title,
                  style: AppConstants.bodyStyle.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantCard(
    String name,
    String description,
    String rating,
    String deliveryTime,
    String imageUrl,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to restaurant details
        },
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Row(
            children: [
              // Restaurant Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusSmall,
                  ),
                ),
                child: Icon(
                  Icons.restaurant,
                  size: 40,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),

              // Restaurant Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppConstants.subheadingStyle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppConstants.captionStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating,
                          style: AppConstants.captionStyle.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: AppConstants.paddingMedium),
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          deliveryTime,
                          style: AppConstants.captionStyle,
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
  }
} 