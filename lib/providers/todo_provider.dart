import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/services/todo_hive.dart';

class TodoNotifier extends StateNotifier<List<TodoModel>> {
  final TodoHiveService _todoService;
  TodoNotifier(this._todoService) : super([]) {
    voidLoadTodo();
  }
  voidLoadTodo() {
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
    state =
        state.map((task) => task.id == taskId ? updatedTask : task).toList();
  }
}
