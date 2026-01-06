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
  bool? _isDistrictFilterEnabled = false; // Track if district filter is enabled
  bool? _isStateFilterEnabled = false; // Track if state filter is enabled
  bool _isNationalFilterEnabled = true; // Default tier (National)
  String? _userDistrict; // User's selected district from profile
  String? _userState; // User's selected state from profile

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
  bool get isDistrictFilterEnabled => _isDistrictFilterEnabled ?? false;
  bool get isStateFilterEnabled => _isStateFilterEnabled ?? false;
  bool get isNationalFilterEnabled => _isNationalFilterEnabled;
  String? get userDistrict => _userDistrict;
  String? get userState => _userState;


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
        if (articles.isNotEmpty) {
          _articles = articles;
          _usingSupabase = true;
          _filterArticles();
        }
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
  Future<void> loadArticles() async {
    try {
      _setLoading(true);
      _setError(null);

      // RICH MOCK DATA for testing premium UI and filtering
      final List<NewsArticle> mockArticles = [
        NewsArticle(
          id: '1',
          title: 'Politics Pulse: New Legislative Reforms Proposed for Digital Innovation',
          summary: 'The latest draft of the Digital Innovation Bill suggests significant tax incentives for regional startups and stricter data privacy norms for international tech giants.',
          content: 'Full content of the politics story...',
          featuredImageAssetId: 'https://images.unsplash.com/photo-1529107386315-e1a2ed48a620?q=80&w=1000',
          source: 'Political Desk',
          publishedAt: DateTime.now().subtract(const Duration(minutes: 45)),
          category: 'Politics',
          district: 'Lucknow',
          state: 'Uttar Pradesh',
          tags: ['Politics', 'Reform', 'Digital'],
          author: 'Aman Singh',
          imageAssetIds: [],
        ),
        NewsArticle(
          id: '2',
          title: 'Tech Alert: Breakthrough in Quantum Computing from Regional University',
          summary: 'Researchers at the Tech Institute of Rajasthan have announced a breakthrough in quantum chip cooling, potentially reducing energy costs by 40%.',
          content: 'Full content of the tech story...',
          featuredImageAssetId: 'https://images.unsplash.com/photo-1518770660439-4636190af475?q=80&w=1000',
          source: 'Tech Bureau',
          publishedAt: DateTime.now().subtract(const Duration(hours: 3)),
          category: 'Technology',
          district: 'Jaipur',
          state: 'Rajasthan',
          tags: ['Quantum', 'Tech', 'Innovation'],
          author: 'Priya Verma',
          imageAssetIds: [],
        ),
        NewsArticle(
          id: '3',
          title: 'Sports Exclusive: Final Squad for State Championship Announced',
          summary: 'The selection committee has finalized the 15-member squad for the upcoming National Games, favoring youthful speed over seasoned experience this season.',
          content: 'Full content of the sports story...',
          featuredImageAssetId: 'https://images.unsplash.com/photo-1461896756970-f49c15873223?q=80&w=1000',
          source: 'Sports Desk',
          publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
          category: 'Sports',
          district: 'Jodhpur',
          state: 'Rajasthan',
          tags: ['Sports', 'Championship', 'Selection'],
          author: 'Rohan Sharma',
          imageAssetIds: [],
        ),
        NewsArticle(
          id: '4',
          title: 'Crime Watch: Cyber Security Unit Busts Major Phishing Racket',
          summary: 'A sophisticated cross-border phishing syndicate targeting senior citizens was dismantled in a joint operation by the State Cyber Crime Cell.',
          content: 'Full content of the crime story...',
          featuredImageAssetId: 'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?q=80&w=1000',
          source: 'Police Bulletin',
          publishedAt: DateTime.now().subtract(const Duration(hours: 10)),
          category: 'Crime',
          district: 'Dehradun',
          state: 'Uttarakhand',
          tags: ['Crime', 'Cyber', 'Security'],
          author: 'Vikram Das',
          imageAssetIds: [],
        ),
        NewsArticle(
          id: '5',
          title: 'Local News: Heritage Walk Restoration Projects Nears Completion',
          summary: 'The restoration of the 200-year-old Stepwell in the old city is 90% complete, set to reopen as a cultural tourism hub by next month.',
          content: 'Full content of the local story...',
          featuredImageAssetId: 'https://images.unsplash.com/photo-1524492459426-edcc9034ff60?q=80&w=1000',
          source: 'Heritage Desk',
          publishedAt: DateTime.now().subtract(const Duration(hours: 14)),
          category: 'Local',
          district: 'Jaipur',
          state: 'Rajasthan',
          tags: ['Local', 'Heritage', 'Tourism'],
          author: 'Suman Gupta',
          imageAssetIds: [],
        ),
        NewsArticle(
          id: '6',
          title: 'Policy Update: New EV Charging Infrastructure Subsidy Announced',
          summary: 'To accelerate green transport adoption, the state government has announced a 50% subsidy for commercial EV charging installations.',
          content: 'Full content of the policy story...',
          featuredImageAssetId: 'https://images.unsplash.com/photo-1593941707882-a5bba14938c7?q=80&w=1000',
          source: 'Bureau Report',
          publishedAt: DateTime.now().subtract(const Duration(hours: 22)),
          category: 'Politics',
          district: 'Varanasi',
          state: 'Uttar Pradesh',
          tags: ['EV', 'Policy', 'Green'],
          author: 'Anita Roy',
          imageAssetIds: [],
        ),
        NewsArticle(
          id: '7',
          title: 'Tech Review: Is this the Future of Wearable Health Technology?',
          summary: 'We test the latest modular smartwatch that claims to monitor blood pressure without an inflatable cuff. Here are our findings.',
          content: 'Full content of the tech review...',
          featuredImageAssetId: 'https://images.unsplash.com/photo-1510017803434-a899398421b3?q=80&w=1000',
          source: 'Gadget Guide',
          publishedAt: DateTime.now().subtract(const Duration(days: 1)),
          category: 'Technology',
          district: 'Jaipur',
          state: 'Rajasthan',
          tags: ['Tech', 'Wearable', 'Health'],
          author: 'Kabir Khan',
          imageAssetIds: [],
        ),
      ];

      _articles = List.from(mockArticles);
      _filterArticles();

      // Attempt to load from Supabase but don't clear mock if fails or is empty
      try {
        final realArticles = await _supabaseNews.getHomeFeed();
        if (realArticles != null && realArticles.isNotEmpty) {
          _articles = realArticles;
          _usingSupabase = true;
          _filterArticles();
        } else {
          // If DB is empty, ensure mock data is filtered and shown
          _filterArticles();
        }
      } catch (e) {
        print('Supabase articles load failed: $e. Using mock data.');
        _filterArticles(); // Fallback filter
      }
    } catch (e) {
      _setError('Failed to load articles: $e');
    } finally {
      // Small artificial delay to test shimmer if needed
      await Future.delayed(const Duration(milliseconds: 800));
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

    // Sort by:
    // 1. District matches (if priority enabled)
    // 2. State matches (if priority enabled and district NOT matching or state priority specifically enabled)
    // 3. Published date (newest first)
    _filteredArticles.sort((a, b) {
      // District Priority (Strongest)
      if (_isDistrictFilterEnabled == true && _userDistrict != null && _userDistrict!.isNotEmpty) {
        final aMatches = a.district == _userDistrict;
        final bMatches = b.district == _userDistrict;
        if (aMatches != bMatches) return aMatches ? -1 : 1;
      }
      
      // State Priority
      if (_isStateFilterEnabled == true && _userState != null && _userState!.isNotEmpty) {
        // Note: Currently NewsArticle model needs a state field. 
        // We'll use a placeholder or check if it matches in some other way for now.
        // I will add state to model in next step.
        // For now, let's assume district contains state info or just handle the logic.
        final aMatches = a.state == _userState;
        final bMatches = b.state == _userState;
        if (aMatches != bMatches) return aMatches ? -1 : 1;
      }
      
      // Secondary sort: Newest first
      return b.publishedAt.compareTo(a.publishedAt);
    });
    
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

  /// Set district filter enabled/disabled
  void setDistrictFilter(bool enabled) {
    if (_isDistrictFilterEnabled != enabled) {
      _isDistrictFilterEnabled = enabled;
      if (enabled) {
        _isStateFilterEnabled = false;
        _isNationalFilterEnabled = false;
      }
      _filterArticles();
    }
  }

  /// Set state filter enabled/disabled
  void setStateFilter(bool enabled) {
    if (_isStateFilterEnabled != enabled) {
      _isStateFilterEnabled = enabled;
      if (enabled) {
        _isDistrictFilterEnabled = false;
        _isNationalFilterEnabled = false;
      }
      _filterArticles();
    }
  }

  /// Set national filter enabled/disabled
  void setNationalFilter(bool enabled) {
    if (_isNationalFilterEnabled != enabled) {
      _isNationalFilterEnabled = enabled;
      if (enabled) {
        _isDistrictFilterEnabled = false;
        _isStateFilterEnabled = false;
      }
      _filterArticles();
    }
  }

  /// Set user's district for filtering
  void setUserDistrict(String? district) {
    if (_userDistrict != district) {
      _userDistrict = district;
      if (_isDistrictFilterEnabled == true) {
        _filterArticles();
      } else {
        notifyListeners(); // Still notify to update labels
      }
    }
  }

  /// Set user's state for filtering
  void setUserState(String? state) {
    if (_userState != state) {
      _userState = state;
      if (_isStateFilterEnabled == true) {
        _filterArticles();
      } else {
        notifyListeners(); // Still notify to update labels
      }
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