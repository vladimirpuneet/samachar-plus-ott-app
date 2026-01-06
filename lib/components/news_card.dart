import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:samachar_plus_ott_app/models.dart';
import 'package:samachar_plus_ott_app/theme.dart';

class NewsCard extends StatelessWidget {
  final NewsArticle article;
  final bool isFullScreen;

  const NewsCard({super.key, required this.article, this.isFullScreen = false});

  @override
  Widget build(BuildContext context) {
    // Check if the article is "new" (published within last 24 hours)
    final bool isNew = DateTime.now().difference(article.publishedAt).inHours < 24;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () => context.go('/article/${article.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section with Badges - Reduced size for more text
              Expanded(
                flex: isFullScreen ? 18 : 20, // Reduced from 3 to ~1.8 equivalent (using 18/40 total)
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: article.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: AppTheme.gray100),
                      errorWidget: (context, url, error) => Container(
                        color: AppTheme.gray100,
                        child: const Icon(Icons.newspaper_rounded, color: AppTheme.gray300, size: 50),
                      ),
                    ),
                    // Dark overlay for text readability if needed
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.2),
                          ],
                        ),
                      ),
                    ),
                    // Category Badge
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.red500,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.red500.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Text(
                          article.category.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                    // New Indicator
                    if (isNew)
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF22C55E), // Greener accent
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.bolt, color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text(
                                'NEW',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Content Section
              Expanded(
                flex: 22, // Increased flex for more text space
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        style: TextStyle(
                          fontSize: isFullScreen ? 22 : 18,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.gray900,
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      // Summary / Content
                      Expanded(
                        child: Text(
                          article.summary,
                          style: TextStyle(
                            fontSize: isFullScreen ? 15 : 14,
                            color: AppTheme.gray600,
                            height: 1.6,
                          ),
                          maxLines: isFullScreen ? 8 : 3, // Reduced maxLines slightly to fit icons
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                      // Hashtags & Social Icons (Visible in Full Screen)
                      if (isFullScreen) ...[
                        const SizedBox(height: 12),
                        // Dynamic Hashtags
                        Wrap(
                          spacing: 8,
                          children: article.tags.take(3).map((tag) => Text(
                            '#${tag.toLowerCase()}',
                            style: TextStyle(
                              color: AppTheme.red500.withValues(alpha: 0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          )).toList(),
                        ),
                        const SizedBox(height: 16),
                        // Social Media Icons
                        Row(
                          children: [
                            _buildSocialIcon(Icons.facebook, const Color(0xFF1877F2)),
                            const SizedBox(width: 20),
                            _buildSocialIcon(const IconData(0xe33c, fontFamily: 'MaterialIcons'), const Color(0xFFE4405F)), // Instagram-ish (using camera or specific icon)
                            const SizedBox(width: 20),
                            _buildSocialIcon(const IconData(0xe6b0, fontFamily: 'MaterialIcons'), const Color(0xFFFF0000)), // YouTube-ish
                          ],
                        ),
                      ],
                      
                      const SizedBox(height: 16),
                      // Footer (Time only, no readmore button)
                      Container(
                        padding: const EdgeInsets.only(top: 16),
                        decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: AppTheme.gray100, width: 1)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time_rounded, size: 14, color: AppTheme.gray400),
                            const SizedBox(width: 6),
                            Text(
                              _getTimeAgo(article.publishedAt),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.gray500
                              ),
                            ),
                            const Spacer(),
                            Icon(Icons.open_in_new_rounded, size: 16, color: AppTheme.gray300),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return Icon(
      icon,
      size: 24,
      color: color.withValues(alpha: 0.9),
    );
  }
}
