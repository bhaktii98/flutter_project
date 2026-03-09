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
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.buildScaffoldGradient(),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.buildPrimaryGradient(),
                          ),
                          child: const Icon(
                            Icons.view_kanban,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Jira-style board',
                                style: AppTextStyles.h2),
                            const SizedBox(height: 2),
                            Text(
                              'Organise tasks by status',
                              style: AppTextStyles.body,
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      tooltip: 'Sign out',
                      icon: const Icon(Icons.logout, color: Colors.black87),
                      onPressed: () =>
                          context.read<AuthNotifier>().signOut(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ResponsiveCenter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Consumer<TodoNotifier>(
                      builder: (context, todos, _) {
                        if (!todos.hasUser) {
                          return const Center(
                            child: Text('Sign in to start adding your tasks.'),
                          );
                        }

                        if (todos.isLoading && todos.todos.isEmpty) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final todoItems = todos.todos
                            .where((t) => t.status == 'todo')
                            .toList();
                        final inProgressItems = todos.todos
                            .where((t) => t.status == 'in_progress')
                            .toList();
                        final doneItems = todos.todos
                            .where((t) => t.status == 'done')
                            .toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (todos.error != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8, left: 4, right: 4),
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
                                      onPressed: () => context
                                          .read<TodoNotifier>()
                                          .clearError(),
                                    ),
                                  ),
                                ),
                              ),
                            Expanded(
                              child: todos.todos.isEmpty
                                  ? const _EmptyState()
                                  : SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _KanbanColumn(
                                            title: 'To Do',
                                            color: Colors.grey.shade800,
                                            badgeColor: Colors.grey.shade300,
                                            todos: todoItems,
                                          ),
                                          _KanbanColumn(
                                            title: 'In Progress',
                                            color: Colors.deepPurple.shade700,
                                            badgeColor:
                                                Colors.deepPurple.shade100,
                                            todos: inProgressItems,
                                          ),
                                          _KanbanColumn(
                                            title: 'Done',
                                            color: Colors.green.shade700,
                                            badgeColor: Colors.green.shade100,
                                            todos: doneItems,
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
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
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    TodoListPage()
                        ._showAddOrEditDialog(context, todo: todo); // ignore: deprecated_member_use
                  } else if (value == 'delete') {
                    notifier.deleteTodo(todo);
                  } else {
                    notifier.updateTodo(todo, status: value);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'todo',
                    child: Text('Move to To Do'),
                  ),
                  const PopupMenuItem(
                    value: 'in_progress',
                    child: Text('Move to In Progress'),
                  ),
                  const PopupMenuItem(
                    value: 'done',
                    child: Text('Move to Done'),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KanbanColumn extends StatelessWidget {
  final String title;
  final Color color;
  final Color badgeColor;
  final List<Todo> todos;

  const _KanbanColumn({
    required this.title,
    required this.color,
    required this.badgeColor,
    required this.todos,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 26,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: badgeColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.h2.copyWith(color: color),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  todos.length.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (todos.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'No tasks',
                style: AppTextStyles.body,
              ),
            )
          else
            ...todos
                .map(
                  (t) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: _TodoTile(todo: t),
                  ),
                )
                .toList(),
        ],
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


