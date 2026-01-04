import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samachar_plus_ott_app/components/news_card.dart';
import 'package:samachar_plus_ott_app/providers/news_provider.dart';
import 'package:samachar_plus_ott_app/providers/auth_provider.dart';
import 'package:samachar_plus_ott_app/widgets/custom_spinner.dart';
import 'package:samachar_plus_ott_app/theme.dart';
import 'package:samachar_plus_ott_app/widgets/shimmer_loader.dart';
import 'package:samachar_plus_ott_app/services/geographic_service.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newsProvider = Provider.of<NewsProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Set user's district from their profile
      final userProfile = authProvider.userProfile;
      if (userProfile?.preferences?.district != null) {
        newsProvider.setUserDistrict(userProfile!.preferences!.district);
      }
      
      // Load all news (not filtered by category)
      newsProvider.setCategory('All');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        if (newsProvider.isLoading) {
          return const Center(child: CustomSpinner());
        }

        final news = newsProvider.filteredArticles;
        final isDistrictFilterEnabled = newsProvider.isDistrictFilterEnabled;
        final userDistrict = newsProvider.userDistrict;

        return Column(
          children: [
            // Category Toggles (Pills) - Fixed at top
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: _buildCategoryPills(newsProvider),
            ),
            
            const SizedBox(height: 16),

            // Vertical Paging News Feed
            Expanded(
              child: newsProvider.isLoading
                  ? ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: 3,
                      itemBuilder: (context, index) => const ShimmerNewsCard(),
                    )
                  : news.isNotEmpty
                      ? PageView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: news.length,
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                              child: NewsCard(article: news[index], isFullScreen: true),
                            );
                          },
                        )
                      : _buildEmptyState(newsProvider, isDistrictFilterEnabled, userDistrict),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuickNotification() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.red500.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.red500.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppTheme.red500,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BREAKING: New Policy Update',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.gray900,
                  ),
                ),
                Text(
                  'Check out the latest digital media guidelines.',
                  style: TextStyle(fontSize: 12, color: AppTheme.gray600),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.gray400),
        ],
      ),
    );
  }

  Widget _buildCategoryPills(NewsProvider newsProvider) {
    final categories = ['All', ...GeographicService.instance.getCategories()];
    
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = newsProvider.selectedCategory == cat;
          
          return GestureDetector(
            onTap: () => newsProvider.setCategory(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.red500 : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppTheme.red500 : AppTheme.gray200,
                  width: 1,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: AppTheme.red500.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ] : null,
              ),
              child: Center(
                child: Text(
                  cat.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: isSelected ? Colors.white : AppTheme.gray700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(NewsProvider newsProvider, bool isDistrictFilterEnabled, String? userDistrict) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48.0),
        child: Column(
          children: [
            const Icon(Icons.article_outlined, size: 80, color: AppTheme.gray200),
            const SizedBox(height: 20),
            Text(
              newsProvider.searchQuery.isNotEmpty
                  ? 'No results for "${newsProvider.searchQuery}"'
                  : isDistrictFilterEnabled && userDistrict != null
                      ? 'No news in $userDistrict at the moment.'
                      : 'Stay tuned for latest news!',
              style: const TextStyle(color: AppTheme.gray500, fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
