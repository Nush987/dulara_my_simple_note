class Note {
  final int id;
  final String title;
  final String content;
  final DateTime modifiedTime;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.modifiedTime,
  });

  // Convert a Map to a Note
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      modifiedTime: DateTime.parse(map['date']),
    );
  }
}
