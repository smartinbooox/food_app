import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'admin_dashboard_screen.dart';
import '../auth/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../../core/constants/app_constants.dart';

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
    // Add missing closing parenthesis at the end of the build method
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Foods'),
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: _isLoadingFoods
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async => _fetchFoods(),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return ListView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Your Foods', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ..._foods.map((food) => Card(
                              child: ListTile(
                                leading: food['image_url'] != null
                                    ? Image.network(food['image_url'], width: 50, height: 50, fit: BoxFit.cover)
                                    : const Icon(Icons.fastfood, size: 40),
                                title: Text(food['name'] ?? ''),
                                subtitle: Text('SAR  ${food['price']?.toStringAsFixed(2) ?? ''}\n${food['description'] ?? ''}'),
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
                    );
                  },
                ),
              ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 86.0), // Move FAB above the bottom nav
          child: FloatingActionButton(
            onPressed: () async {
              final result = await _showAddOrEditFoodDialog();
              if (result == true && mounted) {
                _scaffoldMessengerKey.currentState?.showSnackBar(
                  const SnackBar(
                    content: Text('Food added successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            backgroundColor: AppConstants.primaryColor,
            child: const Icon(Icons.add, color: Colors.white),
            tooltip: 'Add Food',
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    ); // <-- This closes the ScaffoldMessenger
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
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
        child: Center(
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
      ),
    );
  }
}

// Remove FoodManagementScreen and its state class entirely

class _SettingsScreen extends StatefulWidget {
  const _SettingsScreen();

  @override
  State<_SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<_SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  String _selectedRole = 'rider';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _addUser() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; });
    try {
      final uuid = Uuid();
      final userId = uuid.v4();
      final bytes = utf8.encode(_passwordController.text);
      final hashedPassword = sha256.convert(bytes).toString();
      final response = await Supabase.instance.client.from('users').insert({
        'id': userId,
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'password': hashedPassword,
        'contact': _contactController.text.trim(),
        'role': _selectedRole,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User added successfully!'), backgroundColor: AppConstants.primaryColor),
        );
        _formKey.currentState!.reset();
        _selectedRole = 'rider';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error:  ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() { _isLoading = false; });
    }
  }

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
            backgroundColor: AppConstants.primaryColor,
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
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Admin Settings',
              style: AppConstants.headingStyle,
            ),
            const SizedBox(height: 24),
            // Add User Form
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Colored header with icon
                  Container(
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.person_add, color: Colors.white),
                        const SizedBox(width: 12),
                        Text(
                          'Add User (Rider/Restaurant)',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppConstants.primaryColor, width: 2),
                              ),
                              prefixIcon: const Icon(Icons.person),
                            ),
                            validator: (value) => value == null || value.isEmpty ? 'Enter name' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppConstants.primaryColor, width: 2),
                              ),
                              prefixIcon: const Icon(Icons.email),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Enter email';
                              final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                              if (!emailRegex.hasMatch(value)) return 'Enter valid email';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppConstants.primaryColor, width: 2),
                              ),
                              prefixIcon: const Icon(Icons.lock),
                            ),
                            obscureText: true,
                            validator: (value) => value == null || value.isEmpty ? 'Enter password' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _contactController,
                            decoration: InputDecoration(
                              labelText: 'Contact',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppConstants.primaryColor, width: 2),
                              ),
                              prefixIcon: const Icon(Icons.phone),
                            ),
                            validator: (value) => value == null || value.isEmpty ? 'Enter contact' : null,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedRole,
                            items: const [
                              DropdownMenuItem(value: 'rider', child: Text('Rider')),
                              DropdownMenuItem(value: 'restaurant', child: Text('Restaurant')),
                            ],
                            onChanged: (value) {
                              if (value != null) setState(() { _selectedRole = value; });
                            },
                            decoration: InputDecoration(
                              labelText: 'Role',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppConstants.primaryColor, width: 2),
                              ),
                              prefixIcon: const Icon(Icons.group),
                            ),
                            dropdownColor: Colors.white,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _isLoading ? null : _addUser,
                              style: AppConstants.primaryButton,
                              icon: _isLoading
                                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                  : const Icon(Icons.person_add, color: Colors.white),
                              label: Text(
                                _isLoading ? 'Adding...' : 'Add User',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Settings Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.admin_panel_settings, color: AppConstants.primaryColor),
                    title: Text('Admin Panel', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('Manage system settings'),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.info, color: Colors.white),
                              const SizedBox(width: 8),
                              Text('Admin Panel coming soon!'),
                            ],
                          ),
                          backgroundColor: AppConstants.primaryColor,
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.security, color: AppConstants.primaryColor),
                    title: Text('Security', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('Manage security settings'),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.info, color: Colors.white),
                              const SizedBox(width: 8),
                              Text('Security settings coming soon!'),
                            ],
                          ),
                          backgroundColor: AppConstants.primaryColor,
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                    subtitle: Text('Sign out of admin account'),
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
      body: Stack(
        children: [
          // Main content (all screens)
          Positioned.fill(
            child: _screens[_currentIndex],
          ),
          // Floating bottom navigation bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              minimum: const EdgeInsets.all(8),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                    selectedItemColor: AppConstants.primaryColor,
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
            ),
          ),
        ],
      ),
    );
  }
} 