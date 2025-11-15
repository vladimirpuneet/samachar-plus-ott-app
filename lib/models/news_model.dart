import 'package:samachar_plus_ott_app/services/media_service.dart'; // For media URL resolution

class NewsArticle {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String featuredImageAssetId; // Media asset ID instead of direct URL
  final String? videoAssetId; // Media asset ID for video content
  final String source;
  final DateTime publishedAt;
  final String category;
  final String? district;
  final String? subDistrict;
  final List<String> tags;
  final bool isBreaking;
  final String author;
  final int views;
  final List<String> imageAssetIds; // List of media asset IDs
  final String? thumbnailAssetId; // Media asset ID for thumbnail

  // Backward compatibility properties (deprecated)
  String get imageUrl => featuredImageAssetId; // For backward compatibility
  String? get videoUrl => videoAssetId; // For backward compatibility
  List<String> get imageUrls => imageAssetIds; // For backward compatibility
  String? get thumbnail => thumbnailAssetId; // For backward compatibility

  NewsArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.featuredImageAssetId,
    this.videoAssetId,
    required this.source,
    required this.publishedAt,
    required this.category,
    this.district,
    this.subDistrict,
    required this.tags,
    this.isBreaking = false,
    required this.author,
    this.views = 0,
    required this.imageAssetIds,
    this.thumbnailAssetId,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    // Handle both Firebase and Supabase formats
    String id = json['id'] ?? '';
    DateTime publishedAt = json['publishedAt'] != null
        ? DateTime.parse(json['publishedAt'])
        : DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String());

    return NewsArticle(
      id: id,
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      content: json['content'] ?? '',
      featuredImageAssetId: json['featured_image_asset_id'] ?? json['imageUrl'] ?? '',
      videoAssetId: json['video_asset_id'] ?? json['videoUrl'],
      source: json['source'] ?? '',
      publishedAt: publishedAt,
      category: json['category'] ?? '',
      district: json['district'],
      subDistrict: json['sub_district'],
      tags: List<String>.from(json['tags'] ?? []),
      isBreaking: json['is_breaking'] ?? json['isBreaking'] ?? false,
      author: json['author'] ?? '',
      views: json['views'] ?? 0,
      imageAssetIds: List<String>.from(json['image_asset_ids'] ?? json['imageUrls'] ?? []),
      thumbnailAssetId: json['thumbnail_asset_id'] ?? json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'content': content,
      'featured_image_asset_id': featuredImageAssetId,
      'video_asset_id': videoAssetId,
      'source': source,
      'publishedAt': publishedAt.toIso8601String(),
      'created_at': publishedAt.toIso8601String(),
      'category': category,
      'district': district,
      'sub_district': subDistrict,
      'tags': tags,
      'is_breaking': isBreaking,
      'author': author,
      'views': views,
      'image_asset_ids': imageAssetIds,
      'thumbnail_asset_id': thumbnailAssetId,
      
      // Backward compatibility fields (for Firebase format)
      'imageUrl': featuredImageAssetId,
      'videoUrl': videoAssetId,
      'imageUrls': imageAssetIds,
      'thumbnail': thumbnailAssetId,
      'isBreaking': isBreaking,
      'subDistrict': subDistrict,
    };
  }

  NewsArticle copyWith({
    String? id,
    String? title,
    String? summary,
    String? content,
    String? featuredImageAssetId,
    String? videoAssetId,
    String? source,
    DateTime? publishedAt,
    String? category,
    String? district,
    String? subDistrict,
    List<String>? tags,
    bool? isBreaking,
    String? author,
    int? views,
    List<String>? imageAssetIds,
    String? thumbnailAssetId,
  }) {
    return NewsArticle(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      featuredImageAssetId: featuredImageAssetId ?? this.featuredImageAssetId,
      videoAssetId: videoAssetId ?? this.videoAssetId,
      source: source ?? this.source,
      publishedAt: publishedAt ?? this.publishedAt,
      category: category ?? this.category,
      district: district ?? this.district,
      subDistrict: subDistrict ?? this.subDistrict,
      tags: tags ?? this.tags,
      isBreaking: isBreaking ?? this.isBreaking,
      author: author ?? this.author,
      views: views ?? this.views,
      imageAssetIds: imageAssetIds ?? this.imageAssetIds,
      thumbnailAssetId: thumbnailAssetId ?? this.thumbnailAssetId,
    );
  }

  // Media URL resolution methods
  /// Get the resolved featured image URL (async)
  Future<String> getFeaturedImageUrl() async {
    final mediaService = MediaService.instance;
    return await mediaService.getFeaturedImageUrl(featuredImageAssetId) ??
           mediaService.getMediaUrlSync(featuredImageAssetId, assetType: 'image');
  }

  /// Get the resolved video URL (async)
  Future<String?> getVideoUrl() async {
    if (videoAssetId == null) return null;
    final mediaService = MediaService.instance;
    return await mediaService.getVideoUrl(videoAssetId!);
  }

  /// Get the resolved thumbnail URL (async)
  Future<String?> getThumbnailUrl() async {
    if (thumbnailAssetId == null) return null;
    final mediaService = MediaService.instance;
    return await mediaService.getThumbnailUrl(thumbnailAssetId!);
  }

  /// Get all resolved image URLs (async)
  Future<List<String>> getImageUrls() async {
    final mediaService = MediaService.instance;
    return await mediaService.getArticleImages(imageAssetIds);
  }

  // Sync methods for UI convenience
  /// Get the featured image URL (sync - may be placeholder)
  String getFeaturedImageUrlSync() {
    final mediaService = MediaService.instance;
    return mediaService.getMediaUrlSync(featuredImageAssetId, assetType: 'image');
  }

  /// Get the thumbnail URL (sync - may be placeholder)
  String? getThumbnailUrlSync() {
    if (thumbnailAssetId == null) return null;
    final mediaService = MediaService.instance;
    return mediaService.getMediaUrlSync(thumbnailAssetId!, assetType: 'thumbnail');
  }

  /// Get all image URLs (sync - may be placeholders)
  List<String> getImageUrlsSync() {
    final mediaService = MediaService.instance;
    return imageAssetIds.map((id) =>
      mediaService.getMediaUrlSync(id, assetType: 'image')
    ).toList();
  }
}

class LiveChannel {
  final String id;
  final String name;
  final String logoAssetId; // Media asset ID instead of direct URL
  final String streamUrl; // Stream URLs are direct URLs, not media assets
  final String category;
  final String description;
  final bool isLive;
  final int viewers;

  // Backward compatibility property (deprecated)
  String get logoUrl => logoAssetId; // For backward compatibility

  LiveChannel({
    required this.id,
    required this.name,
    required this.logoAssetId,
    required this.streamUrl,
    required this.category,
    required this.description,
    this.isLive = true,
    this.viewers = 0,
  });

  factory LiveChannel.fromJson(Map<String, dynamic> json) {
    // Handle both Firebase and Supabase formats
    String id = json['id'] ?? '';

    return LiveChannel(
      id: id,
      name: json['name'] ?? '',
      logoAssetId: json['logo_asset_id'] ?? json['logoUrl'] ?? '',
      streamUrl: json['stream_url'] ?? json['streamUrl'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      isLive: json['is_live'] ?? json['isLive'] ?? true,
      viewers: json['viewer_count'] ?? json['viewers'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo_asset_id': logoAssetId,
      'stream_url': streamUrl,
      'category': category,
      'description': description,
      'is_live': isLive,
      'viewer_count': viewers,
      
      // Backward compatibility fields (for Firebase format)
      'logoUrl': logoAssetId,
      'streamUrl': streamUrl,
      'isLive': isLive,
      'viewers': viewers,
    };
  }

  LiveChannel copyWith({
    String? id,
    String? name,
    String? logoAssetId,
    String? streamUrl,
    String? category,
    String? description,
    bool? isLive,
    int? viewers,
  }) {
    return LiveChannel(
      id: id ?? this.id,
      name: name ?? this.name,
      logoAssetId: logoAssetId ?? this.logoAssetId,
      streamUrl: streamUrl ?? this.streamUrl,
      category: category ?? this.category,
      description: description ?? this.description,
      isLive: isLive ?? this.isLive,
      viewers: viewers ?? this.viewers,
    );
  }

  // Media URL resolution methods
  /// Get the resolved logo URL (async)
  Future<String> getLogoUrl() async {
    final mediaService = MediaService.instance;
    return await mediaService.getLogoUrl(logoAssetId) ??
           mediaService.getMediaUrlSync(logoAssetId, assetType: 'logo');
  }

  /// Get the logo URL (sync - may be placeholder)
  String getLogoUrlSync() {
    final mediaService = MediaService.instance;
    return mediaService.getMediaUrlSync(logoAssetId, assetType: 'logo');
  }
}