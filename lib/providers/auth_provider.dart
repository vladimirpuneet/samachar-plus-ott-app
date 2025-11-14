import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:samachar_plus_ott_app/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  UserModel? _userProfile;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  UserModel? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _init();
  }

  void _init() {
    _user = _auth.currentUser;
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
      if (user != null) {
        _loadUserProfile(user.uid);
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);

      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        await _loadUserProfile(result.user!.uid);
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp(String email, String password, String name, String phone) async {
    try {
      _setLoading(true);
      _setError(null);

      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // Create user profile
        UserModel userModel = UserModel(
          uid: result.user!.uid,
          email: email,
          name: name,
          phone: phone,
          createdAt: DateTime.now(),
        );

        await result.user!.updateDisplayName(name);
        await _saveUserProfile(userModel);
        _userProfile = userModel;
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _userProfile = null;
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> _loadUserProfile(String uid) async {
    try {
      // Load user profile from Firestore
      // Implementation would depend on your Firestore structure
      // For now, this is a placeholder
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> _saveUserProfile(UserModel user) async {
    try {
      // Save user profile to Firestore
      // Implementation would depend on your Firestore structure
      // For now, this is a placeholder
    } catch (e) {
      _setError(e.toString());
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