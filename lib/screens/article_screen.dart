import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:samachar_plus_ott_app/providers/news_provider.dart';
import 'package:samachar_plus_ott_app/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class ArticleScreen extends StatelessWidget {
  final String articleId;

  const ArticleScreen({super.key, required this.articleId});

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    
    // Find article in provider's lists
    final article = [...newsProvider.articles, ...newsProvider.filteredArticles]
        .firstWhere((a) => a.id == articleId, orElse: () => newsProvider.articles.first);

    if (article == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Article Not Found')),
        body: const Center(child: Text('Could not find the requested article.')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Modern Header AppBar with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.gray900),
                  onPressed: () => context.canPop() ? context.pop() : context.go('/news'),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.fadeTitle,
              ],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: article.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: AppTheme.gray100),
                    errorWidget: (context, url, error) => Container(
                      color: AppTheme.gray100,
                      child: const Icon(Icons.newspaper_rounded, size: 64, color: AppTheme.gray300),
                    ),
                  ),
                  // Gradient Overlay
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Article Content
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meta Info Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.red500.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          article.category.toUpperCase(),
                          style: const TextStyle(
                            color: AppTheme.red500,
                            fontWeight: FontWeight.w900,
                            fontSize: 11,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.access_time_rounded, size: 14, color: AppTheme.gray400),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM dd, yyyy').format(article.publishedAt),
                        style: const TextStyle(color: AppTheme.gray500, fontSize: 13),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Title
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.gray900,
                      height: 1.2,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Author & Source
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: AppTheme.red500.withOpacity(0.1),
                        child: const Icon(Icons.person, size: 14, color: AppTheme.red500),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'By ${article.author}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.gray800,
                          fontSize: 14,
                        ),
                      ),
                      const Text('  •  ', style: TextStyle(color: AppTheme.gray300)),
                      Text(
                        article.source,
                        style: const TextStyle(
                          color: AppTheme.gray500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  
                  const Divider(height: 48, thickness: 1, color: AppTheme.gray100),
                  
                  // Main Body Content
                  Text(
                    article.content.isNotEmpty ? article.content : article.summary,
                    style: TextStyle(
                      fontSize: 17,
                      color: AppTheme.gray800,
                      height: 1.8,
                      letterSpacing: 0.2,
                    ),
                  ),
                  
                  // Tags
                  if (article.tags.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: article.tags.map((tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.gray50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.gray100),
                        ),
                        child: Text(
                          '#$tag',
                          style: const TextStyle(
                            color: AppTheme.gray600,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )).toList(),
                    ),
                  ],
                  
                  const SizedBox(height: 80), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
