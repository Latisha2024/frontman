import 'package:flutter/material.dart';
import '../controllers/assign_tasks.dart';
import 'sales_manager_drawer.dart';
import '../widgets/task_form.dart';
import '../widgets/task_list.dart';
import '../../constants/colors.dart';

class SalesManagerAssignTasksScreen extends StatefulWidget {
  const SalesManagerAssignTasksScreen({super.key});

  @override
  State<SalesManagerAssignTasksScreen> createState() => SalesManagerAssignTasksScreenState();
}

class SalesManagerAssignTasksScreenState extends State<SalesManagerAssignTasksScreen> {
  late SalesManagerAssignTasksController controller;
  bool showForm = false;
  bool isEditMode = false;
  Map<String, dynamic>? editingTask;

  final TextEditingController executiveIdController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  // No extra fields like priority/status per backend

  @override
  void initState() {
    super.initState();
    controller = SalesManagerAssignTasksController();
    // Rebuild UI when the search query changes
    searchController.addListener(() => setState(() {}));
    // Auto-load all tasks when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await onRefresh();
    });
  }

  @override
  void dispose() {
    executiveIdController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    dueDateController.dispose();
    searchController.dispose();
    super.dispose();
  }

    Future<void> onRefresh() async {
    try {
      await controller.loadAllTasks();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Loaded ${controller.tasks.length} task(s)')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load tasks: $e')),
        );
      }
    }
  }

  void onEditTask(Map<String, dynamic> task) {
    setState(() {
      showForm = true;
      isEditMode = true;
      editingTask = task;
      executiveIdController.text = task['executiveId'];
      titleController.text = task['title'] ?? '';
      descriptionController.text = task['description'];
      dueDateController.text = "${task['dueDate'].year}-${task['dueDate'].month.toString().padLeft(2, '0')}-${task['dueDate'].day.toString().padLeft(2, '0')}";
    });
  }

   void onDeleteTask(Map<String, dynamic> task) async {
    final taskId = task['id'] as String;
    try {
      await controller.deleteTaskRemote(taskId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task deleted')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete task: $e')),
        );
      }
    }
  }

  Future<void> onSubmitTask() async {
    if (executiveIdController.text.isEmpty || descriptionController.text.isEmpty || dueDateController.text.isEmpty) return;

    if (isEditMode && editingTask != null) {
      final taskId = editingTask!['id'] as String;
      try {
        await controller.updateTaskRemote(
          taskId: taskId,
          title: titleController.text,
          description: descriptionController.text,
          dueDate: DateTime.tryParse(dueDateController.text) ?? DateTime.now(),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Task updated successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update task: $e')),
          );
        }
        return;
      }
    } else {
      try {
        await controller.submitTaskByExecutiveName(
          executiveName: executiveIdController.text,
          title: titleController.text,
          description: descriptionController.text,
          dueDate: DateTime.tryParse(dueDateController.text) ?? DateTime.now(),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Task created successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create task: $e')),
          );
        }
        return;
      }
    }

    clearForm();
    setState(() {
      showForm = false;
      isEditMode = false;
      editingTask = null;
    });
  }

  void clearForm() {
    executiveIdController.clear();
    titleController.clear();
    descriptionController.clear();
    dueDateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            title: const Text(
              'Assign Tasks',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: AppColors.primaryBlue,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh, color: Colors.white),
                tooltip: 'Refresh Tasks',
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    showForm = !showForm;
                    if (!showForm) {
                      clearForm();
                      isEditMode = false;
                      editingTask = null;
                    }
                  });
                },
                icon: Icon(
                  showForm ? Icons.list : Icons.add,
                  color: Colors.white,
                ),
                tooltip: showForm ? 'View Tasks' : 'Add Task',
              ),
            ],
          ),
          drawer: const SalesManagerDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: (showForm || isEditMode)
                      ? TaskForm(
                          executiveIdController: executiveIdController,
                          titleController: titleController,
                          descriptionController: descriptionController,
                          dueDateController: dueDateController,
                          onSubmit: onSubmitTask,
                          isEditMode: isEditMode,
                          onCancel: () {
                            setState(() {
                              showForm = false;
                              isEditMode = false;
                              editingTask = null;
                            });
                            clearForm();
                          },
                        )
                      : TaskList(
                          tasks: controller.tasks,
                          searchController: searchController,
                          onEdit: onEditTask,
                          onDelete: onDeleteTask,
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 