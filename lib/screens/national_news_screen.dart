import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samachar_plus_ott_app/components/news_card.dart';
import 'package:samachar_plus_ott_app/providers/news_provider.dart';
import 'package:samachar_plus_ott_app/widgets/custom_spinner.dart';
import 'package:samachar_plus_ott_app/theme.dart';

class NationalNewsScreen extends StatefulWidget {
  const NationalNewsScreen({super.key});

  @override
  State<NationalNewsScreen> createState() => _NationalNewsScreenState();
}

class _NationalNewsScreenState extends State<NationalNewsScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure we are filtering for National news
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newsProvider = Provider.of<NewsProvider>(context, listen: false);
      // Only reset category if we are NOT currently searching.
      // If we are searching, the search query takes precedence and we shouldn't reset it or re-trigger filter without it.
      // However, we DO want to ensure we are in National mode.
      newsProvider.setSelectedRegion('NATIONAL');
      
      if (newsProvider.searchQuery.isEmpty) {
        newsProvider.setCategory('NATIONAL');
      } else {
        // If we have a Search Query, we ensure we are effectively searching (which ignores category in current logic),
        // OR we might want to ensure we search WITHIN National.
        // Current logic: _filterArticles uses searchQuery if present.
        // We just ensure we don't accidentally clear it or reset logic that might conflict.
        // We set category to NATIONAL anyway to ensure if search is cleared, we stay on National.
        newsProvider.setCategory('NATIONAL');
        // Re-apply search to ensure it filters correctly effectively
        newsProvider.setSearchQuery(newsProvider.searchQuery);
      }
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

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'National News',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.gray800,
                ),
              ),
              const SizedBox(height: 16),
              if (news.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: news.length,
                  itemBuilder: (context, index) {
                    return NewsCard(article: news[index]);
                  },
                )
              else
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: Text(
                      newsProvider.searchQuery.isNotEmpty 
                        ? 'No match found for "${newsProvider.searchQuery}"'
                        : 'No national news available right now.',
                      style: const TextStyle(color: AppTheme.gray500),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
