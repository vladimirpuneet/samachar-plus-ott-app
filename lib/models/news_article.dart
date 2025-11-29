class NewsArticle {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final String category;
  final String? state;
  final String? district;
  final DateTime createdAt;
  final DateTime? publishedAt;
  final bool isBreaking;
  final String? videoUrl;
  final int viewCount;

  NewsArticle({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.category,
    this.state,
    this.district,
    required this.createdAt,
    this.publishedAt,
    this.isBreaking = false,
    this.videoUrl,
    this.viewCount = 0,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String?,
      category: json['category'] as String,
      state: json['state'] as String?,
      district: json['district'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'] as String)
          : null,
      isBreaking: json['is_breaking'] as bool? ?? false,
      videoUrl: json['video_url'] as String?,
      viewCount: json['view_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'category': category,
      'state': state,
      'district': district,
      'created_at': createdAt.toIso8601String(),
      'published_at': publishedAt?.toIso8601String(),
      'is_breaking': isBreaking,
      'video_url': videoUrl,
      'view_count': viewCount,
    };
  }
}
