import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:samachar_plus_ott_app/env/env.dart';
import 'package:samachar_plus_ott_app/services/whatsapp_otp_service.dart';

/// Supabase Authentication Service
///
/// This service handles all Supabase-specific authentication operations.
/// Used as the primary auth method with Firebase Auth as fallback.
/// Now supports WhatsApp OTP for phone-based authentication.
class SupabaseAuthService {
  static final SupabaseAuthService _instance = SupabaseAuthService._internal();
  static SupabaseAuthService get instance => _instance;

  SupabaseAuthService._internal();

  final SupabaseClient _client = Supabase.instance.client;
  final WhatsAppOtpService _whatsappOtp = WhatsAppOtpService.instance;
  
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
  
  /// Check if user exists by phone number
  Future<bool> userExistsByPhone(String phone) async {
    try {
      final response = await _client
          .from('public_users')
          .select('id')
          .eq('phone', phone)
          .maybeSingle();
      return response != null;
    } catch (e) {
      print('Error checking user existence: $e');
      return false;
    }
  }

  /// Send OTP to phone number via WhatsApp
  Future<bool> sendOtp(String phone) async {
    return await _whatsappOtp.sendOtp(phone);
  }

  /// Verify OTP and authenticate user (sign in or sign up)
  Future<AuthResponse> verifyOtpAndAuth(String phone, String otp, {String? name}) async {
    try {
      // Verify OTP
      final isValid = _whatsappOtp.verifyOtp(phone, otp);
      if (!isValid) {
        throw Exception('Invalid or expired OTP');
      }

      // Check if user exists
      final userExists = await userExistsByPhone(phone);

      if (userExists) {
        // Sign in existing user
        // Workaround: use dummy email since Supabase requires email for auth
        final dummyEmail = '$phone@dummy.samacharplus.com';
        return await signInWithEmailAndPassword(dummyEmail, 'dummy_password');
      } else {
        // Sign up new user
        final dummyEmail = '$phone@dummy.samacharplus.com';
        final response = await createUserWithEmailAndPassword(dummyEmail, 'dummy_password');

        // Create public_users record
        if (response.user != null) {
          await _client.from('public_users').insert({
            'id': response.user!.id,
            'phone': phone,
            'name': name ?? '',
          });
        }

        return response;
      }
    } catch (e) {
      throw Exception('OTP verification and auth failed: $e');
    }
  }

  /// Check if Supabase is properly configured
  bool get isConfigured {
    return Env.supabaseUrl.isNotEmpty &&
            Env.supabaseAnonKey.isNotEmpty &&
            Env.supabaseUrl != 'https://yrmfnwouyzxteswiocmg.supabase.co'; // placeholder check
  }
}