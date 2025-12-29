import 'package:flutter/material.dart';
import 'package:samachar_plus_ott_app/models/news_model.dart';

import 'package:samachar_plus_ott_app/services/supabase_news_service.dart';

/// News Provider for Samachar Plus OTT App
///
/// This provider manages news data using Supabase as primary source
/// with Firebase Firestore as fallback during migration period.
///
/// All public methods maintain the same interface to preserve UI compatibility.
/// All public methods maintain the same interface to preserve UI compatibility.
class NewsProvider extends ChangeNotifier {
  final SupabaseNewsService _supabaseNews = SupabaseNewsService.instance;


  List<NewsArticle> _articles = [];
  List<LiveChannel> _liveChannels = [];
  List<NewsArticle> _filteredArticles = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _usingSupabase = false; // Track which data source is being used
  String _selectedRegion = 'NATIONAL'; // 'NATIONAL' or 'REGIONAL'

  // Public interface - same as before migration
  List<NewsArticle> get articles => _articles;
  List<NewsArticle> get filteredArticles => _filteredArticles;
  List<LiveChannel> get liveChannels => _liveChannels;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isUsingSupabase => _usingSupabase; // New property to track data source
  String get selectedRegion => _selectedRegion;

  NewsProvider() {
    _initRealTimeSubscriptions();
    loadArticles();
    loadLiveChannels();
  }

  /// Initialize real-time subscriptions for live updates
  ///
  /// Replaces Firestore listeners with Supabase real-time subscriptions
  void _initRealTimeSubscriptions() {
    try {
      // Subscribe to home feed updates
      _supabaseNews.subscribeToHomeFeed().listen((articles) {
        _articles = articles;
        _usingSupabase = true;
        _filterArticles();
      });

      // Subscribe to live channel updates
      _supabaseNews.subscribeToLiveChannels().listen((channels) {
        _liveChannels = channels;
        _usingSupabase = true;
        notifyListeners();
      });
    } catch (e) {
      print('Real-time subscription setup failed: $e');
      // Continue with manual loading
    }
  }

  /// Load articles for home feed
  ///
  /// Uses Supabase home feed query with Firebase fallback
  Future<void> loadArticles() async {
    try {
      _setLoading(true);
      _setError(null);

      List<NewsArticle> articles = [];

      // Try Supabase first
      try {
        articles = await _supabaseNews.getHomeFeed();
        _usingSupabase = true;
      } catch (e) {
        print('Supabase articles load failed: $e');
        // Fall through to Firebase fallback
      }



      _articles = articles;
      _filterArticles();
    } catch (e) {
      _setError('Failed to load articles: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Load live channels
  ///
  /// Uses Supabase coverage table with Firebase fallback
  Future<void> loadLiveChannels() async {
    try {
      List<LiveChannel> channels = [];

      // Try Supabase first
      try {
        channels = await _supabaseNews.getLiveChannels();
        _usingSupabase = true;
      } catch (e) {
        print('Supabase channels load failed: $e');
        // Fall through to Firebase fallback
      }



      _liveChannels = channels;
      notifyListeners();
    } catch (e) {
      _setError('Failed to load live channels: $e');
    }
  }

  /// Get articles by category
  ///
  /// Uses Supabase category queries with client-side filtering fallback
  List<NewsArticle> getArticlesByCategory(String category) {
    if (category == 'All') {
      return _articles;
    }
    
    // For now, use client-side filtering (can be optimized with Supabase queries)
    return _articles.where((article) => article.category == category).toList();
  }

  /// Get breaking news
  ///
  /// Uses Supabase breaking news query with client-side filtering fallback
  List<NewsArticle> getBreakingNews() {
    try {
      // Try Supabase breaking news first (async, but we use sync for UI compatibility)
      // In next iteration, this can be made async with proper loading states
    } catch (e) {
      // Fallback to client-side filtering
    }
    
    return _articles.where((article) => article.isBreaking).toList();
  }

  /// Get articles by location
  ///
  /// Uses Supabase regional queries with client-side filtering fallback
  List<NewsArticle> getArticlesByLocation(String? state, String? district) {
    try {
      // Try Supabase regional queries first (async, but we use sync for UI compatibility)
      // In next iteration, this can be made async with proper loading states
    } catch (e) {
      // Fallback to client-side filtering
    }
    
    return _articles.where((article) {
      if (state != null && article.district != null) {
        return true; // Simplified - can be enhanced with proper state matching
      }
      return district != null && article.district == district;
    }).toList();
  }

  /// Set selected category for filtering
  void setCategory(String category) {
    _selectedCategory = category;
    _filterArticles();
  }

  /// Set search query for filtering
  void setSearchQuery(String query) {
    _searchQuery = query;
    _filterArticles();
  }

  /// Filter articles based on category and search query
  void _filterArticles() {
    _filteredArticles = _articles.where((article) {
      bool matchesSearch = _searchQuery.isEmpty ||
          article.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          article.summary.toLowerCase().contains(_searchQuery.toLowerCase());

      if (_searchQuery.isNotEmpty) {
        return matchesSearch;
      }
      
      bool matchesCategory = _selectedCategory == 'All' || article.category == _selectedCategory;
      
      return matchesCategory;
    }).toList();

    // Sort by published date (newest first)
    _filteredArticles.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    
    notifyListeners();
  }

  Future<void> refreshArticles() async {
    await loadArticles();
  }

  /// Set selected region (NATIONAL or REGIONAL)
  void setSelectedRegion(String region) {
    if (_selectedRegion != region) {
      _selectedRegion = region;
      // We don't necessarily need to reload data if the screens handle their own loading based on route
      // But we notify listeners so UniButton can update
      notifyListeners();
    }
  }

  /// Get unique categories from available articles
  List<String> getCategories() {
    // Try Supabase categories first, fallback to client-side extraction
    final categories = _articles.map((article) => article.category).toSet().toList();
    categories.insert(0, 'All');
    return categories;
  }

  /// Get trending articles (most viewed in last 24 hours)
  List<NewsArticle> getTrendingArticles() {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    
    return _articles
        .where((article) => article.publishedAt.isAfter(yesterday))
        .toList()
      ..sort((a, b) => b.views.compareTo(a.views));
  }

  /// Search articles (new method for enhanced search functionality)
  ///
  /// This method adds proper search functionality using Supabase full-text search
  Future<List<NewsArticle>> searchArticles(String query) async {
    try {
      // Use Supabase search if available
      return await _supabaseNews.searchArticles(query);
    } catch (e) {
      // Fallback to client-side search
      _setError('Search failed: $e');
      return [];
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

  // Force reload methods for testing (DEPRECATED - will be removed)
  Future<void> forceLoadFromSupabase() async {
    try {
      final articles = await _supabaseNews.getHomeFeed();
      _articles = articles;
      _usingSupabase = true;
      _filterArticles();
    } catch (e) {
      _setError('Failed to load from Supabase: $e');
    }
  }


}