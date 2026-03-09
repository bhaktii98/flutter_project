class Todo {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final String status; // todo, in_progress, done
  final DateTime createdAt;

  const Todo({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.status,
    required this.createdAt,
  });

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    String? status,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Todo.fromMap(String id, Map<String, dynamic> map) {
    return Todo(
      id: id,
      title: map['title'] as String? ?? '',
      description: map['description'] as String?,
      isCompleted: map['isCompleted'] as bool? ?? false,
      status: map['status'] as String? ?? 'todo',
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}


