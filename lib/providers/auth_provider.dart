import 'package:flutter/material.dart';
import 'package:samachar_plus_ott_app/models/user_model.dart';
import 'package:samachar_plus_ott_app/services/supabase_auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Authentication Provider for Samachar Plus OTT App
class AuthProvider extends ChangeNotifier {
  final SupabaseAuthService _supabaseAuth = SupabaseAuthService.instance;
  final SupabaseClient _client = Supabase.instance.client;

  dynamic _currentUser;
  UserModel? _userProfile;
  bool _isLoading = false;
  String? _error;

  dynamic get user => _currentUser;
  UserModel? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => (_currentUser != null);

  AuthProvider() {
    _init();
  }

  void _init() {
    _supabaseAuth.userStateChanges.listen((user) {
      _currentUser = user;
      notifyListeners();
      
      if (user != null) {
        _loadUserProfile(user.id);
      } else {
        _userProfile = null;
      }
    });
  }

  Future<void> sendOtp(String phone) async {
    try {
      _setLoading(true);
      _setError(null);

      final success = await _supabaseAuth.sendOtp(phone);
      if (!success) {
        throw Exception('Failed to send OTP');
      }
    } catch (e) {
      _setError('Failed to send OTP: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> verifyOtpAndSignIn(String phone, String otp) async {
    try {
      _setLoading(true);
      _setError(null);

      final result = await _supabaseAuth.verifyOtpAndAuth(phone, otp);
      if (result.user != null) {
        await _loadUserProfile(result.user!.id);
      }
    } catch (e) {
      _setError('OTP verification failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> verifyOtpAndSignUp(String phone, String otp, String name) async {
    try {
      _setLoading(true);
      _setError(null);

      final result = await _supabaseAuth.verifyOtpAndAuth(phone, otp, name: name);
      if (result.user != null) {
        await _loadUserProfile(result.user!.id);
      }
    } catch (e) {
      _setError('Sign up failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      _setLoading(true);
      _setError(null);

      await _supabaseAuth.signOut();
      _userProfile = null;
    } catch (e) {
      _setError('Sign out failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadUserProfile(String uid) async {
    try {
      final response = await _client
          .from('public_users')
          .select('*')
          .eq('id', uid)
          .single();

      _userProfile = UserModel.fromJson({
        ...response,
        'email': '', // Not stored in public_users, but required by UserModel
      });
    } catch (e) {
      _setError('Failed to load user profile: $e');
    }
  }

  Future<void> _saveUserProfile(UserModel user) async {
    try {
      await _client.from('public_users').upsert({
        'id': user.uid,
        'phone': user.phone,
        'name': user.name,
        'state': user.preferences?.state ?? '',
        'district': user.preferences?.district ?? '',
        'preferences': user.preferences?.toJson() ?? {},
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _setError('Failed to save user profile: $e');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<bool> checkUserExists(String phone) async {
    return await _supabaseAuth.userExistsByPhone(phone);
  }

  Future<void> updateUserProfile(UserModel user) async {
    await _saveUserProfile(user);
    _userProfile = user;
    notifyListeners();
  }

  Future<void> bypassLogin() async {
    _setLoading(true);
    _setError(null);
    
    // Simulate a successful login with a mock user
    _currentUser = {
      'id': 'mock-dev-id',
      'email': 'dev@samacharplus.com',
    };
    
    // Create a robust mock profile
    _userProfile = UserModel(
      uid: 'mock-dev-id',
      email: 'dev@samacharplus.com',
      name: 'Developer Tester',
      phone: '+919999999999',
      createdAt: DateTime.now(),
      preferences: UserPreferences(
        categories: ['National', 'Local'],
        state: 'Rajasthan',
        district: 'Jaipur',
        notificationsEnabled: true,
      ),
    );
    
    _setLoading(false);
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
