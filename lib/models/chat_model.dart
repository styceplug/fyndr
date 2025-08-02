import 'request_model.dart';
import 'user_model.dart';
import 'merchant_model.dart';
import 'message_model.dart';

class ChatModel {
  final String? id;
  final RequestModel? request;
  final UserModel? user;
  final MerchantModel? merchant;
  final MessageModel? lastMessage;
  final List<MessageModel>? messages;
  final int? userUnreadCount;
  final int? merchantUnreadCount;
  final bool? userAccepted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ChatModel({
    this.id,
    this.request,
    this.user,
    this.merchant,
    this.lastMessage,
    this.messages,
    this.userUnreadCount,
    this.merchantUnreadCount,
    this.userAccepted,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'],
      request: json['request'] != null ? RequestModel.fromJson(json['request']) : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      merchant: json['merchant'] != null ? MerchantModel.fromJson(json['merchant']) : null,
      lastMessage: json['lastMessage'] != null ? MessageModel.fromJson(json['lastMessage']) : null,
      messages: json['messages'] != null
          ? List<MessageModel>.from(json['messages'].map((x) => MessageModel.fromJson(x)))
          : [],
      userUnreadCount: json['userUnreadCount'],
      merchantUnreadCount: json['merchantUnreadCount'],
      userAccepted: json['userAccepted'],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'request': request?.toJson(),
      'user': user?.toJson(),
      'merchant': merchant?.toJson(),
      'lastMessage': lastMessage?.toJson(),
      'messages': messages?.map((m) => m.toJson()).toList(),
      'userUnreadCount': userUnreadCount,
      'merchantUnreadCount': merchantUnreadCount,
      'userAccepted': userAccepted,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  ChatModel copyWith({
    String? id,
    RequestModel? request,
    UserModel? user,
    MerchantModel? merchant,
    MessageModel? lastMessage,
    List<MessageModel>? messages,
    int? userUnreadCount,
    int? merchantUnreadCount,
    bool? userAccepted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatModel(
      id: id ?? this.id,
      request: request ?? this.request,
      user: user ?? this.user,
      merchant: merchant ?? this.merchant,
      lastMessage: lastMessage ?? this.lastMessage,
      messages: messages ?? this.messages,
      userUnreadCount: userUnreadCount ?? this.userUnreadCount,
      merchantUnreadCount: merchantUnreadCount ?? this.merchantUnreadCount,
      userAccepted: userAccepted ?? this.userAccepted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}