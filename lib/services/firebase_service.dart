import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_storage/firebase_storage.dart'; // DEPRECATED: Removed - no longer needed for media reading

/// Firebase Service (DEPRECATED)
///
/// This service is maintained for backward compatibility during migration.
/// Most functionality has been migrated to Supabase services.
///
/// TODO in next iteration: Remove all Firebase dependencies
class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance => _instance ??= FirebaseService._();

  FirebaseService._();

  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  // FirebaseStorage get storage => FirebaseStorage.instance; // DEPRECATED: No longer needed
  FirebaseMessaging get messaging => FirebaseMessaging.instance;

  // Auth methods
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    return await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    return await auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    return await auth.signOut();
  }

  User? get currentUser => auth.currentUser;

  // Firestore methods
  Future<void> setDocument(String collection, String docId, Map<String, dynamic> data) async {
    return await firestore.collection(collection).doc(docId).set(data);
  }

  Future<DocumentSnapshot> getDocument(String collection, String docId) async {
    return await firestore.collection(collection).doc(docId).get();
  }

  Future<QuerySnapshot> getDocuments(String collection, {Query? query}) async {
    return await (query ?? firestore.collection(collection)).get();
  }

  Stream<QuerySnapshot> streamDocuments(String collection, {Query? query}) {
    return (query ?? firestore.collection(collection)).snapshots();
  }

  Future<void> updateDocument(String collection, String docId, Map<String, dynamic> data) async {
    return await firestore.collection(collection).doc(docId).update(data);
  }

  Future<void> deleteDocument(String collection, String docId) async {
    return await firestore.collection(collection).doc(docId).delete();
  }

  // Storage methods - DEPRECATED (No longer used for media reading)
  // All media URLs now come directly from Supabase media_assets table and Cloudflare R2
  
  /// DEPRECATED: Media is now served via Supabase media_assets + Cloudflare R2
  /// This method will be removed in the next iteration
  @Deprecated('Media is now served via Supabase media_assets table and Cloudflare R2')
  Future<String> uploadFile(String path, String filePath) async {
    throw UnsupportedError('Firebase Storage upload is deprecated. Use Supabase + Cloudflare R2 instead.');
  }

  /// DEPRECATED: Media is now served via Supabase media_assets + Cloudflare R2
  /// This method will be removed in the next iteration
  @Deprecated('Media is now served via Supabase media_assets table and Cloudflare R2')
  Future<String> uploadFileFromBytes(String path, List<int> bytes, {String? contentType}) async {
    throw UnsupportedError('Firebase Storage upload is deprecated. Use Supabase + Cloudflare R2 instead.');
  }

  /// DEPRECATED: Media URLs now come directly from Supabase queries
  /// This method will be removed in the next iteration
  @Deprecated('Media URLs now come directly from Supabase media_assets table. Use MediaService instead.')
  Future<String> getDownloadURL(String path) async {
    throw UnsupportedError('Firebase Storage download URLs are deprecated. Use MediaService.getMediaUrl() instead.');
  }

  /// DEPRECATED: Media management moved to Supabase + Cloudflare R2
  /// This method will be removed in the next iteration
  @Deprecated('Media management moved to Supabase + Cloudflare R2')
  Future<void> deleteFile(String path) async {
    throw UnsupportedError('Firebase Storage deletion is deprecated. Use Supabase + Cloudflare R2 instead.');
  }
}