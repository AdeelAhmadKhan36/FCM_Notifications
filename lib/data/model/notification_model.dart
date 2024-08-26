// notification_model.dart

class NotificationModel {
  final String title;
  final String body;
  final String tripID;

  NotificationModel({required this.title, required this.body, required this.tripID});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'] as String,
      body: json['body'] as String,
      tripID: json['tripID'] as String,
    );
  }
}
