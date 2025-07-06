import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import 'supabase_service.dart';

class AuthService {
  static final SupabaseClient _client = SupabaseService.client;

  // Get current user
  static User? get currentUser => _client.auth.currentUser;

  // Get auth state changes stream
  static Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // Sign up with email and password
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? fullName,
    String? phoneNumber,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'phone_number': phoneNumber,
        },
      );

      if (response.user != null) {
        // Create user profile
        await _createUserProfile(response.user!);
      }

      return response;
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  // Sign in with email and password
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  // Get user profile
  static Future<UserModel?> getUserProfile() async {
    try {
      final user = currentUser;
      if (user == null) return null;

      final response = await _client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  // Update user profile
  static Future<void> updateUserProfile({
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    try {
      final user = currentUser;
      if (user == null) throw Exception('No user logged in');

      final updateData = <String, dynamic>{};
      if (fullName != null) updateData['full_name'] = fullName;
      if (phoneNumber != null) updateData['phone_number'] = phoneNumber;
      if (avatarUrl != null) updateData['avatar_url'] = avatarUrl;

      await _client
          .from('profiles')
          .update(updateData)
          .eq('id', user.id);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Reset password
  static Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  // Create user profile (called after sign up)
  static Future<void> _createUserProfile(User user) async {
    try {
      await _client.from('profiles').insert({
        'id': user.id,
        'email': user.email,
        'full_name': user.userMetadata?['full_name'],
        'phone_number': user.userMetadata?['phone_number'],
        'role': 'customer',
      });
    } catch (e) {
      print('Error creating user profile: $e');
    }
  }

  // Check if user is authenticated
  static bool get isAuthenticated => currentUser != null;

  // Get user role
  static Future<String> getUserRole() async {
    try {
      final profile = await getUserProfile();
      return profile?.role ?? 'customer';
    } catch (e) {
      return 'customer';
    }
  }

  // Check if user is admin
  static Future<bool> isAdmin() async {
    final role = await getUserRole();
    return role == 'admin';
  }

  // Check if user is vendor
  static Future<bool> isVendor() async {
    final role = await getUserRole();
    return role == 'vendor';
  }
} 