
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/providers/todo_provider.dart';
import 'package:todo_app/screens/add_task.dart';
class TodoHomeScreen extends ConsumerWidget {
  const TodoHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text('No tasks availables', style: TextStyle(fontSize: 20)),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${task.description}\nDue: ${task.date} at ${task.time}'),
                      leading: Checkbox(
                        value: task.status == "completed",
                        onChanged: (bool? value) {
                   


                        },
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddTaskScreen(
                                    isEditing: true,
                                    taskTitle: task.title,
                                    taskDescription: task.description,
                                    selectedDate: DateTime.parse(task.date),
                                    selectedTime: TimeOfDay(
                                      hour: int.parse(task.time.split(":")[0]),
                                      minute: int.parse(task.time.split(":")[1]),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              ref.read(taskProvider.notifier).deleteTask(task.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddTaskScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
