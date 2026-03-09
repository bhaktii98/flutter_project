import 'package:flutter/material.dart';

import '../../../auth/domain/entities/app_user.dart';
import '../../data/todo_repository.dart';
import '../../domain/entities/todo.dart';

class TodoNotifier extends ChangeNotifier {
  final TodoRepository _repository;

  AppUser? _user;
  List<Todo> _todos = [];
  bool _isLoading = false;
  String? _error;

  TodoNotifier({TodoRepository? repository})
      : _repository = repository ?? TodoRepository();

  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasUser => _user != null;

  void setUser(AppUser? user) {
    _user = user;
    if (_user != null) {
      loadTodos();
    } else {
      _todos = [];
      notifyListeners();
    }
  }

  Future<void> loadTodos() async {
    if (_user == null) return;
    _setLoading(true);
    try {
      _error = null;
      _todos = await _repository.loadTodos(_user!.id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addTodo(String title, String? description) async {
    if (_user == null) return;
    _setLoading(true);
    try {
      _error = null;
      final todo = Todo(
        id: '',
        title: title,
        description: description,
        isCompleted: false,
        status: 'todo',
        createdAt: DateTime.now(),
      );
      final created = await _repository.addTodo(_user!.id, todo);
      _todos = [created, ..._todos];
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateTodo(
    Todo todo, {
    String? title,
    String? description,
    bool? isCompleted,
    String? status,
  }) async {
    if (_user == null) return;
    _setLoading(true);
    try {
      _error = null;
      final updated = todo.copyWith(
        title: title ?? todo.title,
        description: description ?? todo.description,
        isCompleted: isCompleted ?? todo.isCompleted,
        status: status ?? todo.status,
      );
      await _repository.updateTodo(_user!.id, updated);
      _todos = _todos
          .map((t) => t.id == todo.id ? updated : t)
          .toList(growable: false);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteTodo(Todo todo) async {
    if (_user == null) return;
    _setLoading(true);
    try {
      _error = null;
      await _repository.deleteTodo(_user!.id, todo.id);
      _todos = _todos.where((t) => t.id != todo.id).toList(growable: false);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}


