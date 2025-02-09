import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String title;
  bool isCompleted;
  String priority;
  String userId;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.priority,
    required this.userId,
  });

  factory Task.fromDocument(DocumentSnapshot doc) {
    return Task(
      id: doc.id,
      title: doc['title'],
      isCompleted: doc['isCompleted'],
      priority: doc['priority'],
      userId: doc['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'priority': priority,
      'userId': userId,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    String? priority,
    String? userId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      userId: userId ?? this.userId,
    );
  }
}
