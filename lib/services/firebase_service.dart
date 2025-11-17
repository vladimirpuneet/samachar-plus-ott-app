/// Firebase Service (COMPLETELY DEPRECATED)
///
/// This service has been completely replaced by Supabase services.
/// All functionality has been migrated:
///
/// - Auth: Use SupabaseService or SupabaseAuthService
/// - Database: Use SupabaseService or SupabaseNewsService
/// - Storage: Use SupabaseService with Cloudflare R2 or MediaService
/// - Notifications: Use NotificationService (Supabase Realtime)
///
/// This file is kept only for reference and will be removed in the next cleanup.
class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance => _instance ??= FirebaseService._();

  FirebaseService._();

  // All Firebase functionality has been removed and replaced with Supabase

  @Deprecated('Use NotificationService instead')
  dynamic get messaging => throw UnsupportedError(
    'Firebase Messaging is deprecated. Use NotificationService with Supabase Realtime instead.'
  );

  @Deprecated('Use SupabaseService.signInWithEmailAndPassword instead')
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    throw UnsupportedError('Firebase Auth is deprecated. Use SupabaseService instead.');
  }

  @Deprecated('Use SupabaseService.createUserWithEmailAndPassword instead')
  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    throw UnsupportedError('Firebase Auth is deprecated. Use SupabaseService instead.');
  }

  @Deprecated('Use SupabaseService.signOut instead')
  Future<void> signOut() async {
    throw UnsupportedError('Firebase Auth is deprecated. Use SupabaseService instead.');
  }

  @Deprecated('Use SupabaseService.currentUser instead')
  dynamic get currentUser => throw UnsupportedError('Firebase Auth is deprecated. Use SupabaseService instead.');

  @Deprecated('Use SupabaseService.setDocument instead')
  Future<void> setDocument(String collection, String docId, Map<String, dynamic> data) async {
    throw UnsupportedError('Firebase Firestore is deprecated. Use SupabaseService instead.');
  }

  @Deprecated('Use SupabaseService.getDocument instead')
  Future<dynamic> getDocument(String collection, String docId) async {
    throw UnsupportedError('Firebase Firestore is deprecated. Use SupabaseService instead.');
  }

  @Deprecated('Use SupabaseService.getDocuments instead')
  Future<dynamic> getDocuments(String collection, {dynamic query}) async {
    throw UnsupportedError('Firebase Firestore is deprecated. Use SupabaseService instead.');
  }

  @Deprecated('Use SupabaseService.streamDocuments instead')
  Stream<dynamic> streamDocuments(String collection, {dynamic query}) {
    throw UnsupportedError('Firebase Firestore is deprecated. Use SupabaseService instead.');
  }

  @Deprecated('Use SupabaseService.updateDocument instead')
  Future<void> updateDocument(String collection, String docId, Map<String, dynamic> data) async {
    throw UnsupportedError('Firebase Firestore is deprecated. Use SupabaseService instead.');
  }

  @Deprecated('Use SupabaseService.deleteDocument instead')
  Future<void> deleteDocument(String collection, String docId) async {
    throw UnsupportedError('Firebase Firestore is deprecated. Use SupabaseService instead.');
  }

  @Deprecated('Use SupabaseService.uploadFile with R2 instead')
  Future<String> uploadFile(String path, String filePath) async {
    throw UnsupportedError('Firebase Storage is deprecated. Use SupabaseService with Cloudflare R2 instead.');
  }

  @Deprecated('Use SupabaseService.uploadFileFromBytes with R2 instead')
  Future<String> uploadFileFromBytes(String path, List<int> bytes, {String? contentType}) async {
    throw UnsupportedError('Firebase Storage is deprecated. Use SupabaseService with Cloudflare R2 instead.');
  }

  @Deprecated('Use MediaService.getMediaUrl instead')
  Future<String> getDownloadURL(String path) async {
    throw UnsupportedError('Firebase Storage is deprecated. Use MediaService.getMediaUrl() instead.');
  }

  @Deprecated('Use SupabaseService.deleteFile with R2 instead')
  Future<void> deleteFile(String path) async {
    throw UnsupportedError('Firebase Storage is deprecated. Use SupabaseService with Cloudflare R2 instead.');
  }
}
