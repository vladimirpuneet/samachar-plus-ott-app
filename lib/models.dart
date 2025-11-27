class NewsArticle {
  final String id;
  final String title;
  final String? content;
  final String imageUrl;
  final DateTime? publishedAt;

  NewsArticle({
    required this.id,
    required this.title,
    this.content,
    required this.imageUrl,
    this.publishedAt,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String?,
      imageUrl: json['imageUrl'] as String? ?? '',
      publishedAt: json['publishedAt'] != null ? DateTime.parse(json['publishedAt']) : null,
    );
  }
}

class LiveChannel {
  final String id;
  final String name;
  final String logoUrl;
  final String streamUrl;
  final String category; // 'NATIONAL' or 'REGIONAL'
  final String? subCategory; // 'HINDI', 'ENGLISH' etc. or State name
  final List<String>? states; // For regional

  LiveChannel({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.streamUrl,
    required this.category,
    this.subCategory,
    this.states,
  });

  factory LiveChannel.fromJson(Map<String, dynamic> json) {
    return LiveChannel(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String,
      streamUrl: json['streamUrl'] as String,
      category: json['category'] as String,
      subCategory: json['subCategory'] is String ? json['subCategory'] : null,
      states: json['subCategory'] is List ? List<String>.from(json['subCategory']) : null,
    );
  }
}

class UserProfile {
  final String id;
  final String phone;
  final String? name;
  final String? state;
  final String? district;
  final bool receiveAllNews;
  final bool receiveBreaking;
  final bool receiveStateNews;
  final bool receiveDistrictNews;
  final String language;

  UserProfile({
    required this.id,
    required this.phone,
    this.name,
    this.state,
    this.district,
    required this.receiveAllNews,
    required this.receiveBreaking,
    required this.receiveStateNews,
    required this.receiveDistrictNews,
    required this.language,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final prefs = json['preferences'] as Map<String, dynamic>? ?? {};
    return UserProfile(
      id: json['id'] as String,
      phone: json['phone'] as String,
      name: json['name'] as String?,
      state: json['state'] as String?,
      district: json['district'] as String?,
      receiveAllNews: prefs['receive_all_news'] as bool? ?? true,
      receiveBreaking: prefs['receive_breaking'] as bool? ?? true,
      receiveStateNews: prefs['receive_state_news'] as bool? ?? true,
      receiveDistrictNews: prefs['receive_district_news'] as bool? ?? true,
      language: prefs['language'] as String? ?? 'hi',
    );
  }
}
