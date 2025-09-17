import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class Task {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime? reminderDateTime;

  Task({
    String? id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.reminderDateTime,
  }) : id = id ?? _uuid.v4();

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? reminderDateTime,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      reminderDateTime: reminderDateTime ?? this.reminderDateTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'reminderDateTime': reminderDateTime?.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      isCompleted: map['isCompleted'] as bool,
      reminderDateTime: map['reminderDateTime'] != null
          ? DateTime.parse(map['reminderDateTime'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          isCompleted == other.isCompleted &&
          reminderDateTime == other.reminderDateTime;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      isCompleted.hashCode ^
      reminderDateTime.hashCode;
}
