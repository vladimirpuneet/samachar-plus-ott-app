import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samachar_plus_ott_app/components/news_card.dart';
import 'package:samachar_plus_ott_app/providers/news_provider.dart';
import 'package:samachar_plus_ott_app/widgets/custom_spinner.dart';
import 'package:samachar_plus_ott_app/theme.dart';

class RegionalNewsScreen extends StatefulWidget {
  const RegionalNewsScreen({super.key});

  @override
  State<RegionalNewsScreen> createState() => _RegionalNewsScreenState();
}

class _RegionalNewsScreenState extends State<RegionalNewsScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure we are filtering for Regional news
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newsProvider = Provider.of<NewsProvider>(context, listen: false);
      newsProvider.setCategory('REGIONAL');
      newsProvider.setSelectedRegion('REGIONAL');
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
                'Regional News',
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
                        : 'No regional news available right now.',
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
