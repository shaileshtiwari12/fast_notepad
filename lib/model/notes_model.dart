import 'package:hive/hive.dart';

part 'notes_model.g.dart';

@HiveType(typeId: 0)
class NotesModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  String color;

  @HiveField(4)
  String dateTime;

  NotesModel({
    this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.dateTime,
  });

  // Compatibility methods (अगर कहीं sqflite वाला code use हो रहा है तो काम आएगा)
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "content": content,
      "color": color,
      "datetime": dateTime,
    };
  }

  factory NotesModel.fromMap(Map<String, dynamic> map) {
    return NotesModel(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      color: map['color'],
      dateTime: map['datetime'],
    );
  }
}
