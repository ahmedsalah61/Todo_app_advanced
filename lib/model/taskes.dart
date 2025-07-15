class Taskes {
  final int id;
  final String title;
  final DateTime due;
  final bool isDone;

  Taskes({
    required this.id,
    required this.title,
    required this.due,
    required this.isDone,
  });

  Taskes copyWith({int? id, String? title, DateTime? due, bool? isDone}) {
    return Taskes(
      id: id ?? this.id,
      title: title ?? this.title,
      due: due ?? this.due,
      isDone: isDone ?? this.isDone,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'due': due.toIso8601String(),
      'isDone': isDone,
    };
  }

  factory Taskes.fromJson(Map<String, dynamic> json) {
    return Taskes(
      id: json['id'],
      title: json['title'],
      due: DateTime.parse(json['due']),
      isDone: json['isDone'],
    );
  }
}
