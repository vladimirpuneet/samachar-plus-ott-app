class UserModel {
  final String uid;
  final String email;
  final String name;
  final String phone;
  final String? profileImage;
  final UserPreferences? preferences;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.phone,
    this.profileImage,
    this.preferences,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle both Firebase and Supabase formats
    String uid = json['uid'] ?? json['id'] ?? '';
    DateTime createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String());
    DateTime? updatedAt = json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : (json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null);

    return UserModel(
      uid: uid,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profileImage'],
      preferences: json['preferences'] != null
          ? UserPreferences.fromJson(json['preferences'])
          : null,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'id': uid, // Supabase uses 'id' field
      'email': email,
      'name': name,
      'phone': phone,
      'profileImage': profileImage,
      'preferences': preferences?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(), // Supabase format
      'updatedAt': updatedAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(), // Supabase format
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? phone,
    String? profileImage,
    UserPreferences? preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserPreferences {
  final List<String> categories;
  final String state;
  final String district;
  final bool notificationsEnabled;
  final bool darkModeEnabled;
  final String language;

  UserPreferences({
    required this.categories,
    required this.state,
    required this.district,
    this.notificationsEnabled = true,
    this.darkModeEnabled = false,
    this.language = 'en',
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      categories: List<String>.from(json['categories'] ?? []),
      state: json['state'] ?? '',
      district: json['district'] ?? '',
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      darkModeEnabled: json['darkModeEnabled'] ?? false,
      language: json['language'] ?? 'en',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories,
      'state': state,
      'district': district,
      'notificationsEnabled': notificationsEnabled,
      'darkModeEnabled': darkModeEnabled,
      'language': language,
    };
  }

  UserPreferences copyWith({
    List<String>? categories,
    String? state,
    String? district,
    bool? notificationsEnabled,
    bool? darkModeEnabled,
    String? language,
  }) {
    return UserPreferences(
      categories: categories ?? this.categories,
      state: state ?? this.state,
      district: district ?? this.district,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      language: language ?? this.language,
    );
  }
}