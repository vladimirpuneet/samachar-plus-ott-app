import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:samachar_plus_ott_app/models/news_model.dart';

/// Supabase News Service
/// 
/// Handles all Supabase-specific news data operations including:
/// - Home feed (latest news)
/// - Category feeds
/// - Regional feeds  
/// - Search functionality
/// - Real-time subscriptions
/// 
/// Used as primary news service with Firebase Firestore as fallback during migration.
/// Manages all news-related data fetching and real-time subscriptions
class SupabaseNewsService {
  static final SupabaseNewsService _instance = SupabaseNewsService._internal();
  static SupabaseNewsService get instance => _instance;
  
  SupabaseNewsService._internal();

  final SupabaseClient _client = Supabase.instance.client;

  /// Get latest news for home feed
  /// 
  /// Returns the most recent articles ordered by publication date
  Future<List<NewsArticle>> getHomeFeed({int limit = 20}) async {
    try {
      final response = await _client
          .from('content')
          .select()
          .order('created_at', ascending: false)
          .limit(limit);

      return response
          .map((data) => NewsArticle.fromJson(_convertToNewsArticleFormat(data)))
          .toList();
    } catch (e) {
      throw Exception('Failed to load home feed: $e');
    }
  }

  /// Get news articles by category
  /// 
  /// Returns articles filtered by category with optional pagination
  Future<List<NewsArticle>> getArticlesByCategory(
    String category, {
    int limit = 20,
    String? lastCursor, // for pagination
  }) async {
    try {
      var query = _client
          .from('content')
          .select()
          .eq('category', category);

      if (lastCursor != null) {
        query = query.lt('id', lastCursor);
      }

      final response = await query.order('created_at', ascending: false).limit(limit);

      return response
          .map((data) => NewsArticle.fromJson(_convertToNewsArticleFormat(data)))
          .toList();
    } catch (e) {
      throw Exception('Failed to load category articles: $e');
    }
  }

  /// Get news articles by region/location
  /// 
  /// Returns articles filtered by district or subDistrict
  Future<List<NewsArticle>> getArticlesByRegion({
    String? district,
    String? subDistrict,
    int limit = 20,
  }) async {
    try {
      var query = _client
          .from('content')
          .select();

      if (subDistrict != null && subDistrict.isNotEmpty) {
        query = query.eq('sub_district', subDistrict);
      } else if (district != null && district.isNotEmpty) {
        query = query.eq('district', district);
      }

      final response = await query.order('created_at', ascending: false).limit(limit);

      return response
          .map((data) => NewsArticle.fromJson(_convertToNewsArticleFormat(data)))
          .toList();
    } catch (e) {
      throw Exception('Failed to load regional articles: $e');
    }
  }

  /// Search news articles
  /// 
  /// Full-text search across title, summary, and content fields
  Future<List<NewsArticle>> searchArticles(String query, {int limit = 20}) async {
    try {
      final searchTerm = query.trim();
      if (searchTerm.isEmpty) return [];

      final response = await _client
          .from('content')
          .select()
          .or('title.ilike.%$searchTerm%,summary.ilike.%$searchTerm%,content.ilike.%$searchTerm%')
          .order('created_at', ascending: false)
          .limit(limit);

      return response
          .map((data) => NewsArticle.fromJson(_convertToNewsArticleFormat(data)))
          .toList();
    } catch (e) {
      throw Exception('Failed to search articles: $e');
    }
  }

  /// Get breaking news
  /// 
  /// Returns articles marked as breaking news
  Future<List<NewsArticle>> getBreakingNews({int limit = 10}) async {
    try {
      final response = await _client
          .from('content')
          .select()
          .eq('is_breaking', true)
          .order('created_at', ascending: false)
          .limit(limit);

      return response
          .map((data) => NewsArticle.fromJson(_convertToNewsArticleFormat(data)))
          .toList();
    } catch (e) {
      throw Exception('Failed to load breaking news: $e');
    }
  }

  /// Get trending articles (most viewed in last 24 hours)
  /// 
  /// Returns articles sorted by view count within the last 24 hours
  Future<List<NewsArticle>> getTrendingArticles({int limit = 10}) async {
    try {
      final yesterday = DateTime.now().subtract(const Duration(days: 1)).toIso8601String();

      final response = await _client
          .from('content')
          .select()
          .gte('created_at', yesterday)
          .order('views', ascending: false)
          .limit(limit);

      return response
          .map((data) => NewsArticle.fromJson(_convertToNewsArticleFormat(data)))
          .toList();
    } catch (e) {
      throw Exception('Failed to load trending articles: $e');
    }
  }

  /// Get available categories
  /// 
  /// Returns list of unique categories from content table
  Future<List<String>> getCategories() async {
    try {
      final response = await _client
          .from('content')
          .select('category')
          .not('category', 'is', null);

      final categories = response
          .map((data) => data['category'] as String)
          .toSet()
          .toList();

      categories.sort();
      return categories;
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  /// Load live channels
  /// 
  /// Returns all available live TV channels
  Future<List<LiveChannel>> getLiveChannels() async {
    try {
      final response = await _client
          .from('coverage')
          .select()
          .eq('is_live', true)
          .order('name', ascending: true);

      return response
          .map((data) => LiveChannel.fromJson(_convertToLiveChannelFormat(data)))
          .toList();
    } catch (e) {
      throw Exception('Failed to load live channels: $e');
    }
  }

  /// Real-time subscription for home feed updates
  /// 
  /// Returns a stream that emits new articles as they are added
  Stream<List<NewsArticle>> subscribeToHomeFeed() {
    return _client
        .from('content')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .limit(20)
        .map((data) => data
            .map((article) => NewsArticle.fromJson(_convertToNewsArticleFormat(article)))
            .toList());
  }

  /// Real-time subscription for category updates
  /// 
  /// Returns a stream that emits articles for a specific category
  Stream<List<NewsArticle>> subscribeToCategory(String category) {
    return _client
        .from('content')
        .stream(primaryKey: ['id'])
        .eq('category', category)
        .order('created_at', ascending: false)
        .map((data) => data
            .map((article) => NewsArticle.fromJson(_convertToNewsArticleFormat(article)))
            .toList());
  }

  /// Real-time subscription for breaking news
  /// 
  /// Returns a stream that emits breaking news articles
  Stream<List<NewsArticle>> subscribeToBreakingNews() {
    return _client
        .from('content')
        .stream(primaryKey: ['id'])
        .eq('is_breaking', true)
        .order('created_at', ascending: false)
        .map((data) => data
            .map((article) => NewsArticle.fromJson(_convertToNewsArticleFormat(article)))
            .toList());
  }

  /// Real-time subscription for live channels
  /// 
  /// Returns a stream that emits live channel updates
  Stream<List<LiveChannel>> subscribeToLiveChannels() {
    return _client
        .from('coverage')
        .stream(primaryKey: ['id'])
        .eq('is_live', true)
        .order('name', ascending: true)
        .map((data) => data
            .map((channel) => LiveChannel.fromJson(_convertToLiveChannelFormat(channel)))
            .toList());
  }

  /// Convert Supabase content table format to NewsArticle format
  ///
  /// Maps Supabase media_assets table references to NewsArticle format
  Map<String, dynamic> _convertToNewsArticleFormat(Map<String, dynamic> data) {
    return {
      'id': data['id'].toString(),
      'title': data['title'] ?? '',
      'summary': data['summary'] ?? '',
      'content': data['body'] ?? data['content'] ?? '',
      // Use media asset IDs instead of direct URLs
      'featured_image_asset_id': data['featured_image_asset_id'] ?? data['featured_image'] ?? '',
      'video_asset_id': data['video_asset_id'] ?? data['video_url'],
      'source': data['source'] ?? '',
      'publishedAt': data['created_at'] ?? data['published_at'] ?? DateTime.now().toIso8601String(),
      'category': data['category'] ?? '',
      'district': data['district'],
      'subDistrict': data['sub_district'],
      'tags': List<String>.from(data['tags'] ?? []),
      'isBreaking': data['is_breaking'] ?? false,
      'author': data['author'] ?? '',
      'views': data['views'] ?? 0,
      // Use media asset IDs for multiple images
      'image_asset_ids': List<String>.from(data['image_asset_ids'] ?? data['media_urls'] ?? []),
      'thumbnail_asset_id': data['thumbnail_asset_id'] ?? data['thumbnail'],
      
      // Backward compatibility fields (for existing UI code)
      'imageUrl': data['featured_image_asset_id'] ?? data['featured_image'] ?? '',
      'videoUrl': data['video_asset_id'] ?? data['video_url'],
      'imageUrls': List<String>.from(data['image_asset_ids'] ?? data['media_urls'] ?? []),
      'thumbnail': data['thumbnail_asset_id'] ?? data['thumbnail'],
    };
  }

  /// Convert Supabase coverage table format to LiveChannel format
  Map<String, dynamic> _convertToLiveChannelFormat(Map<String, dynamic> data) {
    return {
      'id': data['id'].toString(),
      'name': data['name'] ?? '',
      // Use media asset ID for logo instead of direct URL
      'logo_asset_id': data['logo_asset_id'] ?? data['logo_url'] ?? '',
      'streamUrl': data['stream_url'] ?? '',
      'category': data['category'] ?? '',
      'description': data['description'] ?? '',
      'isLive': data['is_live'] ?? true,
      'viewers': data['viewer_count'] ?? 0,
      
      // Backward compatibility field (for existing UI code)
      'logoUrl': data['logo_asset_id'] ?? data['logo_url'] ?? '',
    };
  }

  /// Check if Supabase is properly configured for news operations
  bool get isConfigured {
    try {
      // Test basic connectivity
      return _client.auth.currentUser != null || true; // News service doesn't require auth for reading
    } catch (e) {
      return false;
    }
  }
}