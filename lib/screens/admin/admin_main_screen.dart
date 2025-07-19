import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'admin_dashboard_screen.dart';
import '../auth/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _ManageScreen extends StatefulWidget {
  const _ManageScreen();

  @override
  State<_ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<_ManageScreen> {
  // Add a GlobalKey for the ScaffoldMessenger
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  XFile? _pickedImage;
  bool _isUploading = false;

  List<Map<String, dynamic>> _foods = [];
  bool _isLoadingFoods = false;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserId();
  }

  Future<void> _fetchCurrentUserId() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.id;
      });
      _fetchFoods();
    }
  }

  Future<void> _fetchFoods() async {
    if (_userId == null) return;
    setState(() => _isLoadingFoods = true);
    final response = await Supabase.instance.client
        .from('foods')
        .select()
        .eq('created_by', _userId!)
        .order('created_at', ascending: false);
    setState(() {
      _foods = List<Map<String, dynamic>>.from(response as List);
      _isLoadingFoods = false;
    });
  }

  Future<String?> _uploadImage(XFile image) async {
    final fileExt = image.path.split('.').last;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
    final filePath = 'foods/$fileName';
    final bytes = await image.readAsBytes();
    final response = await Supabase.instance.client.storage
        .from('images')
        .uploadBinary(filePath, bytes, fileOptions: const FileOptions(upsert: true));
    if (response != null && response is String) {
      final publicUrl = Supabase.instance.client.storage
          .from('images')
          .getPublicUrl(filePath);
      return publicUrl;
    }
    return null;
  }

  // Change _showAddOrEditFoodDialog to return a Future<bool?>
  Future<bool?> _showAddOrEditFoodDialog({Map<String, dynamic>? food}) async {
    final isEdit = food != null;
    _nameController.text = food?['name'] ?? '';
    _descController.text = food?['description'] ?? '';
    _priceController.text = food?['price']?.toString() ?? '';
    _pickedImage = null;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(isEdit ? 'Edit Food' : 'Add Food'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: _descController,
                      decoration: const InputDecoration(labelText: 'Description'),
                    ),
                    TextField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          setStateDialog(() {
                            _pickedImage = image;
                          });
                        }
                      },
                      child: _pickedImage != null
                          ? Image.file(
                              File(_pickedImage!.path),
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                          : (food != null && food['image_url'] != null)
                              ? Image.network(
                                  food['image_url'],
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  height: 100,
                                  width: 100,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image, size: 40),
                                ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _isUploading
                      ? null
                      : () async {
                          final name = _nameController.text.trim();
                          final desc = _descController.text.trim();
                          final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
                          if (name.isEmpty || price <= 0) return;
                          
                          // Show confirmation dialog
                          final confirmed = await _showConfirmationDialog(
                            isEdit ? 'Update Food' : 'Add Food',
                            isEdit 
                              ? 'Are you sure you want to update "${food!['name']}"?'
                              : 'Are you sure you want to add "${name}" to your menu?',
                          );
                          
                          if (!confirmed) return;
                          
                          setState(() => _isUploading = true);
                          String? imageUrl = food?['image_url'];
                          if (_pickedImage != null) {
                            imageUrl = await _uploadImage(_pickedImage!);
                          }
                          try {
                            if (isEdit) {
                              await Supabase.instance.client
                                  .from('foods')
                                  .update({
                                    'name': name,
                                    'description': desc,
                                    'price': price,
                                    'image_url': imageUrl,
                                  })
                                  .eq('id', food!['id']);
                              setState(() => _isUploading = false);
                              Navigator.pop(context, true);
                              _fetchFoods();
                            } else {
                              await Supabase.instance.client
                                  .from('foods')
                                  .insert({
                                    'name': name,
                                    'description': desc,
                                    'price': price,
                                    'image_url': imageUrl,
                                    'created_by': _userId,
                                  });
                              setState(() => _isUploading = false);
                              Navigator.pop(context, true);
                              _fetchFoods();
                            }
                          } catch (e) {
                            setState(() => _isUploading = false);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error ${isEdit ? 'updating' : 'adding'} food: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                  child: _isUploading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(isEdit ? 'Save' : 'Add'),
                ),
              ],
            );
          },
        );
      },
    );
    return result;
  }

  Future<bool> _showConfirmationDialog(String title, String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: title.toLowerCase().contains('delete') ? Colors.red : null,
            ),
            child: Text(
              title.toLowerCase().contains('delete') ? 'Delete' : 'Confirm',
              style: TextStyle(
                color: title.toLowerCase().contains('delete') ? Colors.white : null,
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _deleteFood(String foodId) async {
    // Find the food item to get its name for the confirmation message
    final food = _foods.firstWhere((f) => f['id'] == foodId);
    final foodName = food['name'] ?? 'this food item';
    
    // Show confirmation dialog
    final confirmed = await _showConfirmationDialog(
      'Delete Food',
      'Are you sure you want to delete "$foodName"? This action cannot be undone.',
    );
    
    if (!confirmed) return;
    
    try {
      await Supabase.instance.client.from('foods').delete().eq('id', foodId);
      _fetchFoods();
      
      // Show success message
      if (mounted) {
        _scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text('"$foodName" deleted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text('Error deleting food: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the Scaffold in a ScaffoldMessenger with the key
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        body: _isLoadingFoods
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async => _fetchFoods(),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Your Foods', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        // Add Food button (top right)
                        ElevatedButton.icon(
                          onPressed: () async {
                            final result = await _showAddOrEditFoodDialog();
                            if (result == true && mounted) {
                              // Show SnackBar using the ScaffoldMessenger key
                              _scaffoldMessengerKey.currentState?.showSnackBar(
                                const SnackBar(
                                  content: Text('Food added successfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add Food'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ..._foods.map((food) => Card(
                          child: ListTile(
                            leading: food['image_url'] != null
                                ? Image.network(food['image_url'], width: 50, height: 50, fit: BoxFit.cover)
                                : const Icon(Icons.fastfood, size: 40),
                            title: Text(food['name'] ?? ''),
                            subtitle: Text('SAR ${food['price']?.toStringAsFixed(2) ?? ''}\n${food['description'] ?? ''}'),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () async {
                                    final result = await _showAddOrEditFoodDialog(food: food);
                                    if (result == true && mounted) {
                                      _scaffoldMessengerKey.currentState?.showSnackBar(
                                        SnackBar(
                                          content: Text('"${food['name']}" updated successfully!'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteFood(food['id']),
                                ),
                              ],
                            ),
                          ),
                        )),
                    if (_foods.isEmpty)
                      const Center(child: Text('No foods found. Add your first food!')),
                  ],
                ),
              ),
      ),
    );
  }
}

// Placeholder screens for other tabs
class _ReportScreen extends StatelessWidget {
  const _ReportScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        backgroundColor: const Color(0xFF800000),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assessment,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Reports',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Coming soon...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// Remove FoodManagementScreen and its state class entirely

class _SettingsScreen extends StatelessWidget {
  const _SettingsScreen();

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _performLogout(context);
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _performLogout(BuildContext context) async {
    try {
      await Supabase.instance.client.auth.signOut();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged out successfully!'),
            backgroundColor: Color(0xFF800000),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error logging out: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF800000),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Admin Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings),
                    title: const Text('Admin Panel'),
                    subtitle: const Text('Manage system settings'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Admin Panel coming soon!')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text('Security'),
                    subtitle: const Text('Manage security settings'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Security settings coming soon!')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Logout', style: TextStyle(color: Colors.red)),
                    subtitle: const Text('Sign out of admin account'),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.red),
                    onTap: () => _showLogoutConfirmation(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Restore the _AdminMainScreenState class
class _AdminMainScreenState extends State<AdminMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const AdminDashboardScreen(),
    const _ReportScreen(),
    const _ManageScreen(), // Manage tab
    const _SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF800000),
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(fontSize: 0),
            unselectedLabelStyle: const TextStyle(fontSize: 0),
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assessment),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment), // Clipboard icon for Manage
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
} 