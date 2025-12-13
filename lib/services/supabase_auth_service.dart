import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:samachar_plus_ott_app/env/env.dart';

/// Supabase Authentication Service
/// 
/// This service handles all Supabase-specific authentication operations.
/// Used as the primary auth method with Firebase Auth as fallback.
/// 
/// Used as the primary auth method.
class SupabaseAuthService {
  static final SupabaseAuthService _instance = SupabaseAuthService._internal();
  static SupabaseAuthService get instance => _instance;
  
  SupabaseAuthService._internal();

  final SupabaseClient _client = Supabase.instance.client;
  
  /// Get current authenticated user from Supabase
  User? get currentUser => _client.auth.currentUser;
  
  /// Check if user is authenticated in Supabase
  bool get isAuthenticated => currentUser != null;
  
  /// Get current user session
  Session? get currentSession => _client.auth.currentSession;
  
  /// Sign in with email and password using Supabase
  Future<AuthResponse> signInWithEmailAndPassword(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      
      return response;
    } catch (e) {
      throw Exception('Supabase sign in failed: $e');
    }
  }
  
  /// Sign up with email and password using Supabase
  Future<AuthResponse> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final response = await _client.auth.signUp(
        email: email.trim(),
        password: password,
      );
      
      return response;
    } catch (e) {
      throw Exception('Supabase sign up failed: $e');
    }
  }
  
  /// Sign out from Supabase
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw Exception('Supabase sign out failed: $e');
    }
  }
  
  /// Send password reset email
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(
        email.trim(),
        redirectTo: 'samacharplus://reset-password',
      );
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }
  
  /// Update user password
  Future<void> updatePassword(String newPassword) async {
    try {
      await _client.auth.updateUser(UserAttributes(password: newPassword));
    } catch (e) {
      throw Exception('Password update failed: $e');
    }
  }
  
  /// Update user email
  Future<void> updateEmail(String newEmail) async {
    try {
      await _client.auth.updateUser(UserAttributes(email: newEmail.trim()));
    } catch (e) {
      throw Exception('Email update failed: $e');
    }
  }
  
  /// Stream authentication state changes from Supabase
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
  
  /// Get auth state changes as a stream of User objects (compatible with Firebase interface)
  Stream<User?> get userStateChanges {
    return _client.auth.onAuthStateChange.map((event) => event.session?.user);
  }
  
  /// Check if Supabase is properly configured
  bool get isConfigured {
    return Env.supabaseUrl.isNotEmpty && 
           Env.supabaseAnonKey.isNotEmpty && 
           Env.supabaseUrl != 'https://yrmfnwouyzxteswiocmg.supabase.co'; // placeholder check
  }
}