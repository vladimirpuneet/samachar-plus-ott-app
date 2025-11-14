class NewsArticle {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String imageUrl;
  final String? videoUrl;
  final String source;
  final DateTime publishedAt;
  final String category;
  final String? district;
  final String? subDistrict;
  final List<String> tags;
  final bool isBreaking;
  final String author;
  final int views;
  final List<String> imageUrls;
  final String? thumbnail;

  NewsArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.imageUrl,
    this.videoUrl,
    required this.source,
    required this.publishedAt,
    required this.category,
    this.district,
    this.subDistrict,
    required this.tags,
    this.isBreaking = false,
    required this.author,
    this.views = 0,
    required this.imageUrls,
    this.thumbnail,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['id'],
      title: json['title'],
      summary: json['summary'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      source: json['source'],
      publishedAt: DateTime.parse(json['publishedAt']),
      category: json['category'],
      district: json['district'],
      subDistrict: json['subDistrict'],
      tags: List<String>.from(json['tags'] ?? []),
      isBreaking: json['isBreaking'] ?? false,
      author: json['author'],
      views: json['views'] ?? 0,
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'content': content,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'source': source,
      'publishedAt': publishedAt.toIso8601String(),
      'category': category,
      'district': district,
      'subDistrict': subDistrict,
      'tags': tags,
      'isBreaking': isBreaking,
      'author': author,
      'views': views,
      'imageUrls': imageUrls,
      'thumbnail': thumbnail,
    };
  }

  NewsArticle copyWith({
    String? id,
    String? title,
    String? summary,
    String? content,
    String? imageUrl,
    String? videoUrl,
    String? source,
    DateTime? publishedAt,
    String? category,
    String? district,
    String? subDistrict,
    List<String>? tags,
    bool? isBreaking,
    String? author,
    int? views,
    List<String>? imageUrls,
    String? thumbnail,
  }) {
    return NewsArticle(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      source: source ?? this.source,
      publishedAt: publishedAt ?? this.publishedAt,
      category: category ?? this.category,
      district: district ?? this.district,
      subDistrict: subDistrict ?? this.subDistrict,
      tags: tags ?? this.tags,
      isBreaking: isBreaking ?? this.isBreaking,
      author: author ?? this.author,
      views: views ?? this.views,
      imageUrls: imageUrls ?? this.imageUrls,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }
}

class LiveChannel {
  final String id;
  final String name;
  final String logoUrl;
  final String streamUrl;
  final String category;
  final String description;
  final bool isLive;
  final int viewers;

  LiveChannel({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.streamUrl,
    required this.category,
    required this.description,
    this.isLive = true,
    this.viewers = 0,
  });

  factory LiveChannel.fromJson(Map<String, dynamic> json) {
    return LiveChannel(
      id: json['id'],
      name: json['name'],
      logoUrl: json['logoUrl'],
      streamUrl: json['streamUrl'],
      category: json['category'],
      description: json['description'],
      isLive: json['isLive'] ?? true,
      viewers: json['viewers'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'streamUrl': streamUrl,
      'category': category,
      'description': description,
      'isLive': isLive,
      'viewers': viewers,
    };
  }
}