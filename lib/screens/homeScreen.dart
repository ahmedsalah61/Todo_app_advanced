import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tasks_app_adavanced/cubit/taskes_cubit.dart';
import 'package:tasks_app_adavanced/cubit/taskes_state.dart';
import 'package:tasks_app_adavanced/model/taskes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;
  final List<String> _filters = ['All', 'Done', 'Todo'];

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    DateTime? selectedDate;
    final cubit = context.read<TaskesCubit>();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: const Text('Add New Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Task Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedDate == null
                              ? 'No date selected'
                              : DateFormat(
                                  'EEE, MMM d • hh:mm a',
                                ).format(selectedDate!),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (date == null) return;

                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time == null) return;

                          setState(() {
                            selectedDate = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        },
                        child: const Text('Pick Date & Time'),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    if (title.isEmpty || selectedDate == null) return;

                    final task = Taskes(
                      id: DateTime.now().millisecondsSinceEpoch,
                      title: title,
                      due: selectedDate!,
                      isDone: false,
                    );

                    cubit.addTask(task);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('✅ Task added successfully!'),
                        backgroundColor: Colors.green.shade600,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 244, 244),
        appBar: AppBar(
          title: const Text(
            '📝 To-Do App',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromARGB(255, 253, 253, 253),
          elevation: 5,
          centerTitle: true,
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),

            // Filter Tabs
            ToggleButtons(
              isSelected: List.generate(
                3,
                (index) => index == _selectedTabIndex,
              ),
              onPressed: (index) {
                setState(() => _selectedTabIndex = index);
              },
              borderRadius: BorderRadius.circular(20),
              selectedColor: Colors.white,
              fillColor: const Color.fromARGB(255, 79, 56, 56),
              color: Colors.black,
              selectedBorderColor: const Color.fromARGB(255, 255, 255, 255),
              constraints: const BoxConstraints(minHeight: 40, minWidth: 80),
              children: _filters.map((e) => Text(e)).toList(),
            ),

            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<TaskesCubit, TaskesState>(
                builder: (context, state) {
                  final allTasks = state.taskes;
                  final filteredTasks = _selectedTabIndex == 1
                      ? allTasks.where((t) => t.isDone).toList()
                      : _selectedTabIndex == 2
                      ? allTasks.where((t) => !t.isDone).toList()
                      : allTasks;

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 3,
                        child: ListTile(
                          leading: Checkbox(
                            value: task.isDone,
                            onChanged: (value) {
                              context.read<TaskesCubit>().toggleDone(
                                task.id,
                                value ?? false,
                              );
                            },
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              decoration: task.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          subtitle: Text(
                            'Due: ${DateFormat('MMM d, yyyy - hh:mm a').format(task.due)}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              context.read<TaskesCubit>().deleteTask(task.id);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddTaskDialog,
          label: const Text(
            'Add Task',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
