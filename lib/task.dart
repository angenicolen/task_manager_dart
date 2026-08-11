enum Priority {
  low,
  medium,
  high,
}

class TaskException implements Exception {
  final String message;

  TaskException(this.message);

  @override
  String toString() => message;
}

class InvalidTaskException extends TaskException {
  InvalidTaskException(super.message);
}

class TaskNotFoundException extends TaskException {
  TaskNotFoundException(String id)
      : super('La tâche avec l\'ID $id est introuvable.');
}

class Task {
  final String id;
  String title;
  Priority priority;
  DateTime? dueDate;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    this.dueDate,
    this.isCompleted = false,
  }) {
    if (title.trim().isEmpty) {
      throw InvalidTaskException(
        'Le titre de la tâche ne peut pas être vide.',
      );
    }
  }
}

class UrgentTask extends Task {
  UrgentTask({
    required super.id,
    required super.title,
    required super.dueDate,
  }) : super(
          priority: Priority.high,
        );
}