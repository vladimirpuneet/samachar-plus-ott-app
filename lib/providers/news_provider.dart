import 'package:flutter/material.dart';
import 'package:samachar_plus_ott_app/models/news_model.dart';
import 'package:samachar_plus_ott_app/services/firebase_service.dart';

class NewsProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService.instance;

  List<NewsArticle> _articles = [];
  List<LiveChannel> _liveChannels = [];
  List<NewsArticle> _filteredArticles = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  List<NewsArticle> get articles => _articles;
  List<NewsArticle> get filteredArticles => _filteredArticles;
  List<LiveChannel> get liveChannels => _liveChannels;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  NewsProvider() {
    loadArticles();
    loadLiveChannels();
  }

  Future<void> loadArticles() async {
    try {
      _setLoading(true);
      _setError(null);

      final querySnapshot = await _firebaseService.getDocuments('articles');
      _articles = querySnapshot.docs
          .map((doc) => NewsArticle.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      _filterArticles();
    } catch (e) {
      _setError('Failed to load articles: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadLiveChannels() async {
    try {
      final querySnapshot = await _firebaseService.getDocuments('channels');
      _liveChannels = querySnapshot.docs
          .map((doc) => LiveChannel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load live channels: $e');
    }
  }

  List<NewsArticle> getArticlesByCategory(String category) {
    if (category == 'All') {
      return _articles;
    }
    return _articles.where((article) => article.category == category).toList();
  }

  List<NewsArticle> getBreakingNews() {
    return _articles.where((article) => article.isBreaking).toList();
  }

  List<NewsArticle> getArticlesByLocation(String? state, String? district) {
    return _articles.where((article) {
      if (state != null && article.district != null) {
        // Assuming article has state information or derive from district
        return true; // Simplified for now
      }
      return district != null && article.district == district;
    }).toList();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _filterArticles();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _filterArticles();
  }

  void _filterArticles() {
    _filteredArticles = _articles.where((article) {
      bool matchesCategory = _selectedCategory == 'All' || article.category == _selectedCategory;
      bool matchesSearch = _searchQuery.isEmpty || 
          article.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          article.summary.toLowerCase().contains(_searchQuery.toLowerCase());
      
      return matchesCategory && matchesSearch;
    }).toList();

    // Sort by published date (newest first)
    _filteredArticles.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    
    notifyListeners();
  }

  Future<void> refreshArticles() async {
    await loadArticles();
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

  // Get unique categories
  List<String> getCategories() {
    final categories = _articles.map((article) => article.category).toSet().toList();
    categories.insert(0, 'All');
    return categories;
  }

  // Get trending articles (most viewed in last 24 hours)
  List<NewsArticle> getTrendingArticles() {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    
    return _articles
        .where((article) => article.publishedAt.isAfter(yesterday))
        .toList()
      ..sort((a, b) => b.views.compareTo(a.views));
  }
}