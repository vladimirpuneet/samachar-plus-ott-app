import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/header.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/news_card.dart';
import '../utils/app_routes.dart';

class NationalNewsScreen extends StatelessWidget {
  const NationalNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(
            onLogoClick: () => context.go(AppRoutes.home),
          ),
          Expanded(
            child: Consumer2<NewsProvider, AuthProvider>(
              builder: (context, newsProvider, authProvider, child) {
                if (newsProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (newsProvider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${newsProvider.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => newsProvider.refreshArticles(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final articles = newsProvider.filteredArticles
                    .where((article) => 
                        article.category.toLowerCase() == 'national' ||
                        article.category.toLowerCase() == 'technology' ||
                        article.category.toLowerCase() == 'sports' ||
                        article.category.toLowerCase() == 'entertainment' ||
                        article.category.toLowerCase() == 'business')
                    .toList();

                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      color: Colors.red[50],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'National News',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Latest news from across the nation',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: articles.isEmpty
                          ? const Center(
                              child: Text(
                                'No national news available',
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: articles.length,
                              itemBuilder: (context, index) {
                                final article = articles[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: NewsCard(
                                    article: article,
                                    onTap: () => context.go(
                                      '${AppRoutes.article}/${article.id}'
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onProfileClick: () => context.go(AppRoutes.profile),
        unreadCount: 0,
      ),
    );
  }
}