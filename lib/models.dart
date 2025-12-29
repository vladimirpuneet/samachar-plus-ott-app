export 'package:samachar_plus_ott_app/models/news_model.dart';

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
