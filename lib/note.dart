class Note {
  final String title;
  final String content;
  final DateTime createdAt;

  Note({
    required this.title,
    required this.content,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}