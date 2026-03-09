import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/res/app_colors.dart';
import '../../../../core/res/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/responsive_center.dart';
import '../../../auth/presentation/state/auth_notifier.dart';
import '../../domain/entities/todo.dart';
import '../state/todo_notifier.dart';

class TodoListPage extends StatelessWidget {
  static const String routeName = '/todos';

  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My tasks'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthNotifier>().signOut(),
          ),
        ],
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Consumer<TodoNotifier>(
              builder: (context, todos, _) {
                if (!todos.hasUser) {
                  return const Center(
                    child: Text('Sign in to start adding your tasks.'),
                  );
                }

                if (todos.isLoading && todos.todos.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today',
                      style: AppTextStyles.h1,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Capture everything you need to get done.',
                      style: AppTextStyles.body,
                    ),
                    const SizedBox(height: 16),
                    if (todos.error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Material(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                          child: ListTile(
                            dense: true,
                            leading: const Icon(Icons.error_outline,
                                color: Colors.red),
                            title: Text(
                              todos.error!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 13,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.close, size: 18),
                              onPressed: () =>
                                  context.read<TodoNotifier>().clearError(),
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: todos.todos.isEmpty
                          ? const _EmptyState()
                          : ListView.separated(
                              itemCount: todos.todos.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final todo = todos.todos[index];
                                return _TodoTile(todo: todo);
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddOrEditDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('New task'),
      ),
    );
  }

  Future<void> _showAddOrEditDialog(BuildContext context, {Todo? todo}) async {
    final titleController = TextEditingController(text: todo?.title ?? '');
    final descriptionController =
        TextEditingController(text: todo?.description ?? '');

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Consumer<TodoNotifier>(
              builder: (context, todos, _) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    Text(
                      todo == null ? 'New task' : 'Edit task',
                      style: AppTextStyles.h2,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: titleController,
                      label: 'Title',
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: descriptionController,
                      label: 'Description (optional)',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            label: 'Cancel',
                            expanded: true,
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppButton(
                            label: todo == null ? 'Add' : 'Save',
                            expanded: true,
                            isLoading: todos.isLoading,
                            onPressed: () async {
                              final title = titleController.text.trim();
                              final description =
                                  descriptionController.text.trim().isEmpty
                                      ? null
                                      : descriptionController.text.trim();
                              if (title.isEmpty) return;

                              if (todo == null) {
                                await todos.addTodo(title, description);
                              } else {
                                await todos.updateTodo(
                                  todo,
                                  title: title,
                                  description: description,
                                );
                              }

                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _TodoTile extends StatelessWidget {
  final Todo todo;

  const _TodoTile({required this.todo});

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<TodoNotifier>();

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () =>
            TodoListPage()._showAddOrEditDialog(context, todo: todo), // ignore: deprecated_member_use
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Checkbox(
                value: todo.isCompleted,
                onChanged: (_) =>
                    notifier.updateTodo(todo, isCompleted: !todo.isCompleted),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    if (todo.description != null &&
                        todo.description!.trim().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          todo.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () =>
                    TodoListPage()._showAddOrEditDialog(context, todo: todo), // ignore: deprecated_member_use
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => notifier.deleteTodo(todo),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.inbox_outlined,
            size: 56,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 12),
          Text(
            'No tasks yet',
            style: AppTextStyles.h2,
          ),
          const SizedBox(height: 4),
          Text(
            'Tap the “New task” button to add your first todo.',
            style: AppTextStyles.body,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


