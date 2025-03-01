import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String date;

  @HiveField(3)
  final String time;

  @HiveField(4)
  final String status;

  @HiveField(5)
  final String id;

  TodoModel({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.status,
    required this.id,
  });

  TodoModel copyWith({
    String? title,
    String? description,
    String? date,
    String? time,
    String? status,
    String? id,
  }) {
    return TodoModel(
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      id: id ?? this.id,
    );
  }
}
