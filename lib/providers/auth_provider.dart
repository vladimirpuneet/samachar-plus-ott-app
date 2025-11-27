import 'package:flutter/material.dart';
import 'package:samachar_plus_ott_app/models/user_model.dart';
import 'package:samachar_plus_ott_app/services/supabase_auth_service.dart';

/// Authentication Provider for Samachar Plus OTT App
class AuthProvider extends ChangeNotifier {
  final SupabaseAuthService _supabaseAuth = SupabaseAuthService.instance;

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

  Future<void> signIn(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);

      final result = await _supabaseAuth.signInWithEmailAndPassword(email, password);
      if (result.user != null) {
        await _loadUserProfile(result.user!.id);
      }
    } catch (e) {
      _setError('Sign in failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp(String email, String password, String name, String phone) async {
    try {
      _setLoading(true);
      _setError(null);

      final result = await _supabaseAuth.createUserWithEmailAndPassword(email, password);
      if (result.user != null) {
        UserModel userModel = UserModel(
          uid: result.user!.id,
          email: email,
          name: name,
          phone: phone,
          createdAt: DateTime.now(),
        );

        await _saveUserProfile(userModel);
        _userProfile = userModel;
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
      print('User profile loading not implemented yet');
    } catch (e) {
      _setError('Failed to load user profile: $e');
    }
  }

  Future<void> _saveUserProfile(UserModel user) async {
    try {
      print('User profile saving not implemented yet');
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

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
