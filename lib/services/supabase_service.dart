import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:samachar_plus_ott_app/models/news_model.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  SupabaseClient get client => Supabase.instance.client;

  // Initialize Supabase
  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }

  // News Articles
  Future<List<NewsArticle>> getNews({
    String? category,
    String? state,
    String? district,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      var query = client
          .from('news_articles')
          .select()
          .eq('status', 'published');

      if (category != null && category.isNotEmpty) {
        query = query.eq('category', category);
      }

      if (state != null && state.isNotEmpty) {
        query = query.eq('state', state);
      }

      if (district != null && district.isNotEmpty) {
        query = query.eq('district', district);
      }

      final response = await query.order('published_at', ascending: false).range(offset, offset + limit - 1);
      return (response as List)
          .map((json) => NewsArticle.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching news: $e');
      return [];
    }
  }

  Future<NewsArticle?> getArticleById(String id) async {
    try {
      final response = await client
          .from('news_articles')
          .select()
          .eq('id', id)
          .single();

      return NewsArticle.fromJson(response);
    } catch (e) {
      print('Error fetching article: $e');
      return null;
    }
  }

  // Authentication
  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user;
    } catch (e) {
      print('Error signing in: $e');
      rethrow;
    }
  }

  Future<User?> signUpWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: data,
      );
      return response.user;
    } catch (e) {
      print('Error signing up: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  User? get currentUser => client.auth.currentUser;

  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;
}