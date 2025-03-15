import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/services/todo_hive.dart';

class TodoNotifier extends StateNotifier<List<TodoModel>> {
  final TodoHiveService _todoService;
  
  TodoNotifier(this._todoService) : super([]) {
    loadTodos();
  }

  void loadTodos() {
    state = _todoService.fetchTasks();
  }

  void addTask(TodoModel task) {
    _todoService.addTask(task);
    state = [...state, task];
  }

  void deleteTask(String taskId) {
    _todoService.deleteTask(taskId);
    state = state.where((task) => task.id != taskId).toList();
  }

  void updateTask(String taskId, TodoModel updatedTask) {
    _todoService.updateTask(taskId, updatedTask);
    state = state.map((task) => task.id == taskId ? updatedTask : task).toList();
  }
void updatedTaskStatus(String taskId, String status) {
  final taskIndex = state.indexWhere((task) => task.id == taskId);
  if (taskIndex != -1) {
    final updatedTask = state[taskIndex].copyWith(status: status);
    _todoService.updateTaskstatus(taskId, updatedTask);
    state = [
      for (var task in state)
        if (task.id == taskId) updatedTask else task,
    ];
  }
}

}

final taskProvider = StateNotifierProvider<TodoNotifier, List<TodoModel>>(
  (ref) => TodoNotifier(TodoHiveService()),
);
