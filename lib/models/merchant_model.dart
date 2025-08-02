import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fyndr/models/user_model.dart';

import 'message_model.dart';

class MerchantModel {
  final String? id;
  final Sender? sender;
  final String? merchant;
  final MessageModel? message;
  final bool? isAccepted;

  final String? name;
  final String? email;
  final String? number;
  final String? avatar;
  final String? whatsappNumber;
  final String? businessName;
  final String? businessAddress;
  final String? nin;
  final String? state;
  final String? lga;
  final List<String>? servicesOffered;
  final bool? isActive;
  final bool? isAvailable;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? businessLocation;
  final bool? idVerified;

  final Preferences? preferences;
  final Rating? rating;

  final List<DeviceToken>? deviceTokens;



  MerchantModel({
    this.id,
    this.sender,
    this.merchant,
    this.message,
    this.isAccepted,

    this.name,
    this.email,
    this.number,
    this.avatar,
    this.whatsappNumber,
    this.businessName,
    this.businessAddress,
    this.nin,
    this.state,
    this.lga,
    this.servicesOffered,
    this.isActive,
    this.isAvailable,
    this.createdAt,
    this.updatedAt,
    this.businessLocation,
    this.idVerified,
    this.preferences,
    this.rating,
    this.deviceTokens,

  });

  factory MerchantModel.fromJson(Map<String, dynamic> json) {
    return MerchantModel(
      id: json['_id'],
      sender: json['sender'] != null && json['sender'] is Map
          ? Sender.fromJson(json['sender'])
          : null,
      merchant: json['merchant'],
      message: json['message'] != null && json['message'] is Map
          ? MessageModel.fromJson(json['message'])
          : null,
      isAccepted: json['isAccepted'],

      name: json['name'],
      email: json['email'],
      number: json['number'],
      avatar: json['avatar'],
      whatsappNumber: json['whatsappNumber'],
      businessName: json['businessName'],
      businessAddress: json['businessAddress'],
      nin: json['nin'],
      state: json['state'],
      lga: json['lga'],
      servicesOffered: List<String>.from(json['servicesOffered'] ?? []),
      isActive: json['isActive'],
      isAvailable: json['isAvailable'],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      businessLocation: json['businessLocation'],
      idVerified: json['idVerified'],
      preferences: json['preferences'] != null ? Preferences.fromJson(json['preferences']) : null,
      rating: json['rating'] != null ? Rating.fromJson(json['rating']) : null,
      deviceTokens: (json['deviceTokens'] as List?)
          ?.map((e) => DeviceToken.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'sender': sender?.toJson(),
      'email': email,
      'number': number,
      'avatar': avatar,
      'whatsappNumber': whatsappNumber,
      'businessName': businessName,
      'businessAddress': businessAddress,
      'nin': nin,
      'state': state,
      'lga': lga,
      'servicesOffered': servicesOffered,
      'isActive': isActive,
      'isAvailable': isAvailable,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'businessLocation': businessLocation,
      'idVerified': idVerified,
      'preferences': preferences?.toJson(),
      'rating': rating?.toJson(),
    };
  }

  MerchantModel copyWith({
    String? id,
    String? merchant,
    MessageModel? message,
    bool? isAccepted,
    String? name,
    String? email,
    String? number,
    String? avatar,
    String? whatsappNumber,
    String? businessName,
    String? businessAddress,
    String? nin,
    String? state,
    String? lga,
    List<String>? servicesOffered,
    bool? isActive,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? businessLocation,
    bool? idVerified,
    Preferences? preferences,
    Rating? rating,
    List<DeviceToken>? deviceTokens,
  }) {
    return MerchantModel(
      id: id ?? this.id,
      merchant: merchant ?? this.merchant,
      message: message ?? this.message,
      isAccepted: isAccepted ?? this.isAccepted,
      name: name ?? this.name,
      email: email ?? this.email,
      number: number ?? this.number,
      avatar: avatar ?? this.avatar,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      businessName: businessName ?? this.businessName,
      businessAddress: businessAddress ?? this.businessAddress,
      nin: nin ?? this.nin,
      state: state ?? this.state,
      lga: lga ?? this.lga,
      servicesOffered: servicesOffered ?? this.servicesOffered,
      isActive: isActive ?? this.isActive,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      businessLocation: businessLocation ?? this.businessLocation,
      idVerified: idVerified ?? this.idVerified,
      preferences: preferences ?? this.preferences,
      rating: rating ?? this.rating,
      deviceTokens: deviceTokens ?? this.deviceTokens,
    );
  }
}

class InterestedMerchant {
  final MerchantModel? merchant;
  final MessageModel? message;
  final bool? isAccepted;
  final String? id;

  InterestedMerchant({
    this.merchant,
    this.message,
    this.isAccepted,
    this.id,
  });

  factory InterestedMerchant.fromJson(Map<String, dynamic> json) {
    return InterestedMerchant(
      merchant: json['merchant'] != null
          ? MerchantModel.fromJson(json['merchant'])
          : null,
      message: json['message'] != null
          ? MessageModel.fromJson(json['message'])
          : null,
      isAccepted: json['isAccepted'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'merchant': merchant?.toJson(),
      'message': message?.toJson(),
      'isAccepted': isAccepted,
      '_id': id,
    };
  }
}

class Preferences {
  final NotificationPrefs? notifications;

  Preferences({this.notifications});

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      notifications: json['notifications'] != null
          ? NotificationPrefs.fromJson(json['notifications'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications?.toJson(),
    };
  }
}

class NotificationPrefs {
  final bool? email;
  final bool? whatsApp;
  final bool? inApp;

  NotificationPrefs({this.email, this.whatsApp, this.inApp});

  factory NotificationPrefs.fromJson(Map<String, dynamic> json) {
    return NotificationPrefs(
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

class Rating {
  final double? average;
  final int? count;
  final Map<String, int>? breakdown;

  Rating({this.average, this.count, this.breakdown});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      average: (json['average'] ?? 0).toDouble(),
      count: json['count'] ?? 0,
      breakdown: Map<String, int>.from(json['breakdown'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average': average,
      'count': count,
      'breakdown': breakdown,
    };
  }
}