class GeoState {
  final String id;
  final int stateCode;
  final String stateNameEnglish;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  GeoState({
    required this.id,
    required this.stateCode,
    required this.stateNameEnglish,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GeoState.fromJson(Map<String, dynamic> json) {
    return GeoState(
      id: json['id'],
      stateCode: json['state_code'],
      stateNameEnglish: json['state_name_english'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'state_code': stateCode,
      'state_name_english': stateNameEnglish,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class GeoDistrict {
  final String id;
  final String stateId;
  final int? districtCode;
  final String districtNameEnglish;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  GeoDistrict({
    required this.id,
    required this.stateId,
    this.districtCode,
    required this.districtNameEnglish,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GeoDistrict.fromJson(Map<String, dynamic> json) {
    return GeoDistrict(
      id: json['id'],
      stateId: json['state_id'],
      districtCode: json['district_code'],
      districtNameEnglish: json['district_name_english'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'state_id': stateId,
      'district_code': districtCode,
      'district_name_english': districtNameEnglish,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
