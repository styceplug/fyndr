class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? number;
  final String? avatar;
  final String? state;
  final String? lga;
  final String? location;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final NotificationPreferences? preferences;
  final List<DeviceToken>? deviceTokens;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.number,
    this.avatar,
    this.state,
    this.lga,
    this.location,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.preferences,
    this.deviceTokens,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      number: json['number'],
      avatar: json['avatar'],
      state: json['state'],
      lga: json['lga'],
      location: json['location'],
      isActive: json['isActive'],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      preferences: json['preferences']?['notifications'] != null
          ? NotificationPreferences.fromJson(json['preferences']['notifications'])
          : null,
      deviceTokens: (json['deviceTokens'] as List?)
          ?.map((e) => DeviceToken.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'number': number,
      'avatar': avatar,
      'state': state,
      'lga': lga,
      'location': location,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'preferences': {
        'notifications': preferences?.toJson(),
      },
      'deviceTokens': deviceTokens?.map((e) => e.toJson()).toList(),
    };
  }


  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? number,
    String? avatar,
    String? state,
    String? lga,
    String? location,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    NotificationPreferences? preferences,
    List<DeviceToken>? deviceTokens,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      number: number ?? this.number,
      avatar: avatar ?? this.avatar,
      state: state ?? this.state,
      lga: lga ?? this.lga,
      location: location ?? this.location,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      preferences: preferences ?? this.preferences,
      deviceTokens: deviceTokens ?? this.deviceTokens,
    );
  }
}

class NotificationPreferences {
  final bool? email;
  final bool? whatsApp;
  final bool? inApp;

  NotificationPreferences({
    this.email,
    this.whatsApp,
    this.inApp,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      email: json['email'],
      whatsApp: json['whatsApp'],
      inApp: json['inApp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'whatsApp': whatsApp,
      'inApp': inApp,
    };
  }
}

class DeviceToken {
  final String? token;
  final String? platform;
  final DateTime? createdAt;

  DeviceToken({
    this.token,
    this.platform,
    this.createdAt,
  });

  factory DeviceToken.fromJson(Map<String, dynamic> json) {
    return DeviceToken(
      token: json['token'],
      platform: json['platform'],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'platform': platform,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}