import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:samachar_plus_ott_app/services/supabase_service.dart';

class AuthProvider with ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService.instance;
  User? _currentUser;

  User? get user => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    // Listen to auth state changes
    _supabaseService.client.auth.onAuthStateChange.listen((data) {
      _currentUser = data.session?.user;
      notifyListeners();
    });
  }

  Future<AuthResponse> signInWithEmailAndPassword(String email, String password) async {
    try {
      final response = await _supabaseService.signInWithEmailAndPassword(email, password);
      _currentUser = response.user;
      notifyListeners();
      return response;
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  Future<AuthResponse> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final response = await _supabaseService.createUserWithEmailAndPassword(email, password);
      _currentUser = response.user;
      notifyListeners();
      return response;
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _supabaseService.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  void clear() {
    _currentUser = null;
    notifyListeners();
  }
}