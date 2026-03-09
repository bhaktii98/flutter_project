import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/util/constants.dart';
import '../domain/entities/todo.dart';

/// Repository that talks directly to Firebase Realtime Database using REST.
/// No custom backend APIs are used – only Firebase.
class TodoRepository {
  const TodoRepository();

  String _baseUrlForUser(String userId) {
    return '${AppConstants.realtimeDatabaseBaseUrl}/users/$userId/todos';
  }

  Future<List<Todo>> loadTodos(String userId) async {
    final uri = Uri.parse('${_baseUrlForUser(userId)}.json');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load todos (${response.statusCode})');
    }

    if (response.body == 'null') return [];

    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;

    return data.entries
        .map(
          (e) => Todo.fromMap(
            e.key,
            Map<String, dynamic>.from(e.value as Map),
          ),
        )
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<Todo> addTodo(String userId, Todo todo) async {
    final uri = Uri.parse('${_baseUrlForUser(userId)}.json');
    final response = await http.post(
      uri,
      body: json.encode(todo.toMap()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create todo (${response.statusCode})');
    }

    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;
    final String id = data['name'] as String;
    return todo.copyWith(id: id);
  }

  Future<void> updateTodo(String userId, Todo todo) async {
    final uri = Uri.parse('${_baseUrlForUser(userId)}/${todo.id}.json');
    final response = await http.patch(
      uri,
      body: json.encode(todo.toMap()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update todo (${response.statusCode})');
    }
  }

  Future<void> deleteTodo(String userId, String todoId) async {
    final uri = Uri.parse('${_baseUrlForUser(userId)}/$todoId.json');
    final response = await http.delete(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete todo (${response.statusCode})');
    }
  }
}

