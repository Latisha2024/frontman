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
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  String selectedPriority = 'Normal';
  String filterPriority = 'All';

  @override
  void initState() {
    super.initState();
    controller = SalesManagerAssignTasksController();
  }

  void onEditTask(Map<String, dynamic> task) {
    setState(() {
      showForm = true;
      isEditMode = true;
      editingTask = task;
      executiveIdController.text = task['executiveId'];
      descriptionController.text = task['description'];
      dueDateController.text = "${task['dueDate'].year}-${task['dueDate'].month.toString().padLeft(2, '0')}-${task['dueDate'].day.toString().padLeft(2, '0')}";
      selectedPriority = task['priority'];
    });
  }

  void onDeleteTask(Map<String, dynamic> task) {
    setState(() {
      controller.tasks.removeWhere((t) => t['id'] == task['id']);
    });
  }

  void onSubmitTask() {
    if (executiveIdController.text.isEmpty || descriptionController.text.isEmpty || dueDateController.text.isEmpty) return;
    if (isEditMode && editingTask != null) {
      final idx = controller.tasks.indexWhere((t) => t['id'] == editingTask!['id']);
      if (idx != -1) {
        controller.tasks[idx] = {
          'id': editingTask!['id'],
          'executiveId': executiveIdController.text,
          'description': descriptionController.text,
          'dueDate': DateTime.tryParse(dueDateController.text) ?? DateTime.now(),
          'priority': selectedPriority,
          'status': controller.tasks[idx]['status'],
        };
      }
    } else {
      controller.addTask(
        executiveId: executiveIdController.text,
        description: descriptionController.text,
        dueDate: DateTime.tryParse(dueDateController.text) ?? DateTime.now(),
        priority: selectedPriority,
      );
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
    descriptionController.clear();
    dueDateController.clear();
    selectedPriority = 'Normal';
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
                          descriptionController: descriptionController,
                          dueDateController: dueDateController,
                          selectedPriority: selectedPriority,
                          onPriorityChanged: (val) => setState(() => selectedPriority = val),
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
                          filterPriority: filterPriority,
                          onPriorityChanged: (val) => setState(() => filterPriority = val),
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