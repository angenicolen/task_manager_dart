import 'dart:io';

import 'package:test/test.dart';
import 'package:task_manager_dart/task.dart';
import 'package:task_manager_dart/task_repository.dart';

void main() {
  test('Créer une tâche correctement', () {
    final task = Task(
      id: '1',
      title: 'Réviser Dart',
      priority: Priority.high,
    );

    expect(task.title, 'Réviser Dart');
    expect(task.priority, Priority.high);
    expect(task.isCompleted, false);
  });

  test('Refuser une tâche avec un titre vide', () {
    expect(
      () => Task(
        id: '1',
        title: '',
        priority: Priority.medium,
      ),
      throwsA(isA<InvalidTaskException>()),
    );
  });

  test('Ajouter une tâche au repository', () {
    final repository = TaskRepository('test_tasks.json');

    final task = Task(
      id: '1',
      title: 'Faire les tests',
      priority: Priority.medium,
    );

    repository.add(task);

    expect(repository.items.length, 1);
    expect(repository.items.first.title, 'Faire les tests');

    File('test_tasks.json').deleteSync();
  });

  test('Marquer une tâche comme terminée', () {
    final repository = TaskRepository('test_tasks.json');

    final task = Task(
      id: '1',
      title: 'Terminer le projet',
      priority: Priority.high,
    );

    repository.add(task);
    repository.complete('1');

    expect(repository.findById('1').isCompleted, true);

    File('test_tasks.json').deleteSync();
  });

  test('Supprimer une tâche', () {
    final repository = TaskRepository('test_tasks.json');

    final task = Task(
      id: '1',
      title: 'Supprimer cette tâche',
      priority: Priority.low,
    );

    repository.add(task);
    repository.delete('1');

    expect(repository.items, isEmpty);

    File('test_tasks.json').deleteSync();
  });

  test('Lever une exception si la tâche est introuvable', () {
    final repository = TaskRepository('test_tasks.json');

    expect(
      () => repository.findById('999'),
      throwsA(isA<TaskNotFoundException>()),
    );
  });
}