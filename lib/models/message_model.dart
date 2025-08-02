class MessageModel {
  final String? id;
  final String? content;
  final Sender? sender;
  final DateTime? createdAt;

  // Client-side only
  final bool isSending;
  final bool hasError;

  MessageModel({
    this.id,
    this.content,
    this.sender,
    this.createdAt,
    this.isSending = false,
    this.hasError = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final senderJson = json['sender'];

    return MessageModel(
      id: json['_id'],
      content: json['content'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      sender: senderJson is Map<String, dynamic>
          ? Sender.fromJson(senderJson)
          : senderJson is String
          ? Sender(senderType: senderJson)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'content': content,
      'createdAt': createdAt?.toIso8601String(),
      'sender': sender?.toJson(),
    };
  }

  MessageModel copyWith({
    String? id,
    String? content,
    Sender? sender,
    DateTime? createdAt,
    bool? isSending,
    bool? hasError,
  }) {
    return MessageModel(
      id: id ?? this.id,
      content: content ?? this.content,
      sender: sender ?? this.sender,
      createdAt: createdAt ?? this.createdAt,
      isSending: isSending ?? this.isSending,
      hasError: hasError ?? this.hasError,
    );
  }
}

class Sender {
  final SenderId? senderId;
  final String? senderType;
  final String? userId;

  Sender({
    this.senderId,
    this.senderType,
    this.userId,
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      senderId: json['senderId'] != null && json['senderId'] is Map
          ? SenderId.fromJson(json['senderId'])
          : null,
      senderType: json['senderType'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId?.toJson(),
      'senderType': senderType,
      'userId': userId,
    };
  }
}

class SenderId {
  final String? id;
  final String? name;
  final String? email;
  final String? avatar;
  final String? number;

  SenderId({
    this.id,
    this.name,
    this.email,
    this.avatar,
    this.number,
  });

  factory SenderId.fromJson(Map<String, dynamic> json) {
    return SenderId(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
      number: json['number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'number': number,
    };
  }
}