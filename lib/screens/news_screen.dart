import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/news_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/header.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/news_card.dart';
import '../widgets/top_news_slideshow.dart';
import '../widgets/category_news_carousel.dart';
import '../utils/app_routes.dart';
import '../models/news_model.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  int _selectedIndex = 0;

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

                final articles = newsProvider.filteredArticles;
                final topArticles = articles.take(5).toList();
                final regionalArticles = authProvider.user != null 
                  ? articles.where((article) => 
                      article.district != null && article.district!.isNotEmpty).toList()
                  : <NewsArticle>[];

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Stories Slideshow
                              if (topArticles.isNotEmpty) ...[
                                const Text(
                                  'Top Stories',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TopNewsSlideshow(articles: topArticles),
                                const SizedBox(height: 32),
                              ],

                              // Category News Carousel
                              const Text(
                                'News by Category',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const CategoryNewsCarousel(),
                              const SizedBox(height: 32),

                              // Regional News
                              if (regionalArticles.isNotEmpty) ...[
                                Text(
                                  'News from your region',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ...regionalArticles.map((article) => 
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 16.0),
                                    child: NewsCard(
                                      article: article,
                                      onTap: () => context.go(
                                        '${AppRoutes.article}/${article.id}'
                                      ),
                                    ),
                                  ),
                                ),
                              ] else if (authProvider.user == null) ...[
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.person_outline,
                                        size: 48,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Sign in to see news from your region',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () => context.go(AppRoutes.auth),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red[600],
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text('Sign In'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Consumer2<NewsProvider, AuthProvider>(
        builder: (context, newsProvider, authProvider, child) {
          return BottomNavigationBar(
            onProfileClick: () => context.go(AppRoutes.profile),
            unreadCount: 0, // TODO: Implement notifications counter
          );
        },
      ),
    );
  }
}