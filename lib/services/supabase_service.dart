import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/env_constants.dart';
import '../models/user_model.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;

  // Get Supabase client instance
  static SupabaseClient get client => _client;

  // Authentication methods
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? userData,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: userData,
    );
  }

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    await _client.auth.signOut();
  }

  static User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  static Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // User profile methods
  static Future<UserModel?> getUserProfile(String userId) async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      
      return UserModel.fromJson(response);
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  static Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _client
          .from('profiles')
          .update(data)
          .eq('id', userId);
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }

  // Real-time subscriptions
  static RealtimeChannel subscribeToTable(String tableName) {
    return _client.channel('public:$tableName');
  }

  // Generic CRUD operations
  static Future<List<Map<String, dynamic>>> fetchData(
    String tableName, {
    String? select,
    Map<String, dynamic>? filters,
    String? orderBy,
    int? limit,
  }) async {
    try {
      var query = _client.from(tableName).select(select ?? '*');
      
      if (filters != null) {
        filters.forEach((key, value) {
          query = query.eq(key, value);
        });
      }
      
      if (orderBy != null) {
        query = query.order(orderBy);
      }
      
      if (limit != null) {
        query = query.limit(limit);
      }
      
      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching data from $tableName: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> insertData(
    String tableName,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client
          .from(tableName)
          .insert(data)
          .select()
          .single();
      
      return response;
    } catch (e) {
      print('Error inserting data to $tableName: $e');
      rethrow;
    }
  }

  static Future<void> updateData(
    String tableName,
    Map<String, dynamic> data,
    String column,
    dynamic value,
  ) async {
    try {
      await _client
          .from(tableName)
          .update(data)
          .eq(column, value);
    } catch (e) {
      print('Error updating data in $tableName: $e');
      rethrow;
    }
  }

  static Future<void> deleteData(
    String tableName,
    String column,
    dynamic value,
  ) async {
    try {
      await _client
          .from(tableName)
          .delete()
          .eq(column, value);
    } catch (e) {
      print('Error deleting data from $tableName: $e');
      rethrow;
    }
  }
} 