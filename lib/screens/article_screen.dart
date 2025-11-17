import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/news_provider.dart';
import '../widgets/header.dart';
import '../utils/app_routes.dart';
import '../models/news_model.dart';

class ArticleScreen extends StatefulWidget {
  final String articleId;

  const ArticleScreen({
    super.key,
    required this.articleId,
  });

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  bool _isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(
            onLogoClick: () => context.go(AppRoutes.home),
          ),
          Expanded(
            child: Consumer<NewsProvider>(
              builder: (context, newsProvider, child) {
                // Find the article by ID
                final article = newsProvider.articles
                    .where((a) => a.id == widget.articleId)
                    .firstOrNull;

                if (article == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.article_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Article not found',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.go(AppRoutes.home),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[600],
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Back to News'),
                        ),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Featured Image
                      if (article.getFeaturedImageUrlSync().isNotEmpty)
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            article.getFeaturedImageUrlSync(),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                    size: 48,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                      // Content
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Breaking news badge
                            if (article.isBreaking)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'BREAKING NEWS',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                            const SizedBox(height: 16),

                            // Title
                            Text(
                              article.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Meta information
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'By ${article.author} • ${_formatDate(article.publishedAt)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isBookmarked = !_isBookmarked;
                                    });
                                  },
                                  icon: Icon(
                                    _isBookmarked 
                                      ? Icons.bookmark 
                                      : Icons.bookmark_border,
                                    color: _isBookmarked ? Colors.red[600] : Colors.grey[600],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _shareArticle(article),
                                  icon: Icon(
                                    Icons.share,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Summary
                            if (article.summary.isNotEmpty) ...[
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey[200]!,
                                  ),
                                ),
                                child: Text(
                                  article.summary,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Content
                            Text(
                              _cleanContent(article.content),
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.6,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Tags
                            if (article.tags.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Tags:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: article.tags.map((tag) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          tag,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),

                            const SizedBox(height: 24),

                            // Related articles
                            Text(
                              'Related Articles',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Mock related articles - in real app this would be fetched from API
                            ..._buildRelatedArticles(newsProvider, article),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRelatedArticles(NewsProvider newsProvider, NewsArticle currentArticle) {
    // Get articles in the same category, excluding current article
    final relatedArticles = newsProvider.articles
        .where((article) => 
            article.category == currentArticle.category && 
            article.id != currentArticle.id)
        .take(3)
        .toList();

    if (relatedArticles.isEmpty) {
      return [];
    }

    return relatedArticles.map((article) {
      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: article.getFeaturedImageUrlSync().isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    article.getFeaturedImageUrlSync(),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.article,
                    color: Colors.grey,
                  ),
                ),
          title: Text(
            article.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            _formatDate(article.publishedAt),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
          onTap: () => context.go('${AppRoutes.article}/${article.id}'),
        ),
      );
    }).toList();
  }

  void _shareArticle(NewsArticle article) {
    // TODO: Implement sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality coming soon!'),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  String _cleanContent(String content) {
    return content.replaceAll(r'\"', '"');
  }
}

// Extension to handle firstOrNull for List<NewsArticle>
extension NewsArticleListExtension on List<NewsArticle> {
  NewsArticle? get firstOrNull {
    return isNotEmpty ? this[0] : null;
  }
}