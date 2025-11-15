import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // DEPRECATED: Will be removed in next iteration
import 'package:samachar_plus_ott_app/models/user_model.dart';
import 'package:samachar_plus_ott_app/services/firebase_service.dart'; // DEPRECATED: Will be removed in next iteration
import 'package:samachar_plus_ott_app/services/supabase_auth_service.dart';

/// Authentication Provider for Samachar Plus OTT App
///
/// This provider manages user authentication state using Supabase Auth as primary
/// with Firebase Auth as fallback during migration period.
///
/// TODO in next iteration: Remove all Firebase Auth dependencies
class AuthProvider extends ChangeNotifier {
  final SupabaseAuthService _supabaseAuth = SupabaseAuthService.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance; // DEPRECATED: Firebase Auth fallback only
  final FirebaseService _firebaseService = FirebaseService.instance; // DEPRECATED: User profile fallback only

  // Current authenticated user (abstracted from underlying auth provider)
  User? _currentUser;
  UserModel? _userProfile;
  bool _isLoading = false;
  String? _error;
  bool _usingSupabase = false; // Track which auth provider is being used

  // Public interface - same as before migration
  User? get user => _currentUser;
  UserModel? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => (_currentUser != null);
  bool get isUsingSupabase => _usingSupabase; // New property to track which provider is active

  AuthProvider() {
    _init();
  }

  void _init() {
    // Listen to Supabase Auth state changes (primary)
    _supabaseAuth.userStateChanges.listen((User? user) {
      _currentUser = user;
      _usingSupabase = true;
      notifyListeners();
      
      if (user != null) {
        _loadUserProfile(user.id);
      } else {
        _userProfile = null;
      }
    });

    // Listen to Firebase Auth state changes (fallback only)
    _firebaseAuth.authStateChanges().listen((User? user) {
      // Only use Firebase if not using Supabase and user exists in Firebase
      if (!_usingSupabase && user != null) {
        _currentUser = user;
        _usingSupabase = false;
        notifyListeners();
        _loadUserProfile(user.uid);
      }
    });
  }

  /// Sign in with email and password
  ///
  /// Attempts Supabase Auth first, falls back to Firebase Auth if Supabase fails
  Future<void> signIn(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);

      // Try Supabase Auth first
      try {
        final result = await _supabaseAuth.signInWithEmailAndPassword(email, password);
        if (result.user != null) {
          _usingSupabase = true;
          await _loadUserProfile(result.user!.id);
          return;
        }
      } catch (e) {
        print('Supabase sign in failed: $e');
        // Fall through to Firebase fallback
      }

      // Firebase Auth fallback (DEPRECATED - will be removed)
      final firebaseResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (firebaseResult.user != null) {
        _usingSupabase = false;
        await _loadUserProfile(firebaseResult.user!.uid);
      }
    } catch (e) {
      _setError('Sign in failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Sign up with email and password
  Future<void> signUp(String email, String password, String name, String phone) async {
    try {
      _setLoading(true);
      _setError(null);

      // Try Supabase Auth first
      try {
        final result = await _supabaseAuth.createUserWithEmailAndPassword(email, password);
        if (result.user != null) {
          _usingSupabase = true;
          
          // Create user profile
          UserModel userModel = UserModel(
            uid: result.user!.id,
            email: email,
            name: name,
            phone: phone,
            createdAt: DateTime.now(),
          );

          await _saveUserProfile(userModel);
          _userProfile = userModel;
          return;
        }
      } catch (e) {
        print('Supabase sign up failed: $e');
        // Fall through to Firebase fallback
      }

      // Firebase Auth fallback (DEPRECATED - will be removed)
      final firebaseResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (firebaseResult.user != null) {
        _usingSupabase = false;
        
        // Update display name
        await firebaseResult.user!.updateDisplayName(name);
        
        // Create user profile
        UserModel userModel = UserModel(
          uid: firebaseResult.user!.uid,
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

  /// Sign out from current auth provider
  Future<void> signOut() async {
    try {
      _setLoading(true);
      _setError(null);

      if (_usingSupabase) {
        await _supabaseAuth.signOut();
      } else {
        // Firebase Auth fallback (DEPRECATED)
        await _firebaseAuth.signOut();
      }

      _userProfile = null;
    } catch (e) {
      _setError('Sign out failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Load user profile from appropriate storage
  ///
  /// Currently tries Supabase user_profiles first, falls back to Firebase Firestore
  /// TODO in next iteration: Remove Firebase profile loading
  Future<void> _loadUserProfile(String uid) async {
    try {
      // For now, user profile loading is not implemented in this iteration
      // This will be added in the next iteration when user profile migration is done
      print('User profile loading not implemented yet - will be added in next iteration');
    } catch (e) {
      _setError('Failed to load user profile: $e');
    }
  }

  /// Save user profile to appropriate storage
  ///
  /// Currently uses Firebase Firestore as profile storage
  /// TODO in next iteration: Migrate to Supabase database
  Future<void> _saveUserProfile(UserModel user) async {
    try {
      // For now, save to Firebase Firestore (will be migrated to Supabase in next iteration)
      await _firebaseService.setDocument('user_profiles', user.uid, user.toJson());
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