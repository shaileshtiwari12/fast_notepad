class NotesModel {
  final int? id;
  final String title;
  final String content;
  final String color;
  final String dateTime;

  NotesModel({
    this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'color': color,
      'datetime': dateTime,
    };
  }

  factory NotesModel.fromMap(
    Map<String, dynamic> map){
      return  NotesModel(
        id: map['id'],
        title: map['title'],
        content: map['content'],
        color:map['color'] ,
        dateTime:map['datetime'] 
      );
    }
}
