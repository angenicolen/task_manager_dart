import 'dart:convert';
import 'dart:io';

import 'repository.dart';
import 'task.dart';

class TaskRepository implements Repository<Task> {
  final String filePath;
  final List<Task> _tasks = [];

  TaskRepository(this.filePath);

  @override
  List<Task> get items => List.unmodifiable(_tasks);

  @override
  void add(Task item) {
    _tasks.add(item);
    save();
  }

  @override
  void delete(String id) {
    final task = findById(id);
    _tasks.remove(task);
    save();
  }

  @override
  Task findById(String id) {
    try {
      return _tasks.firstWhere(
        (task) => task.id == id,
      );
    } catch (_) {
      throw TaskNotFoundException(id);
    }
  }

  void complete(String id) {
    final task = findById(id);
    task.isCompleted = true;
    save();
  }

  void save() {
    final file = File(filePath);

    final data = _tasks.map((task) {
      return {
        'id': task.id,
        'title': task.title,
        'priority': task.priority.name,
        'dueDate': task.dueDate?.toIso8601String(),
        'isCompleted': task.isCompleted,
      };
    }).toList();

    file.writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(data),
    );
  }

  void load() {
    final file = File(filePath);

    if (!file.existsSync()) {
      return;
    }

    final content = file.readAsStringSync();

    if (content.trim().isEmpty) {
      return;
    }

    final data = jsonDecode(content) as List;

    _tasks.clear();

    for (final item in data) {
      final map = item as Map<String, dynamic>;

      _tasks.add(
        Task(
          id: map['id'] as String,
          title: map['title'] as String,
          priority: Priority.values.firstWhere(
            (p) => p.name == map['priority'],
          ),
          dueDate: map['dueDate'] == null
              ? null
              : DateTime.parse(map['dueDate'] as String),
          isCompleted: map['isCompleted'] as bool? ?? false,
        ),
      );
    }
  }
}
