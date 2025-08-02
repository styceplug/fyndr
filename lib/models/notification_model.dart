class NotificationModel {
  final String? id;
  final String? userId;
  final String? title;
  final String? message;
  final String? type;
  final bool? isRead;
  final NotificationRequestReference? request;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NotificationModel({
    this.id,
    this.userId,
    this.title,
    this.message,
    this.type,
    this.isRead,
    this.request,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      userId: json['userId'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      isRead: json['isRead'],
      request: json['requestId'] != null
          ? NotificationRequestReference.fromJson(json['requestId'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }
}

class NotificationRequestReference {
  final String? id;
  final String? title;

  NotificationRequestReference({this.id, this.title});

  factory NotificationRequestReference.fromJson(Map<String, dynamic> json) {
    return NotificationRequestReference(
      id: json['_id'],
      title: json['title'],
    );
  }
}