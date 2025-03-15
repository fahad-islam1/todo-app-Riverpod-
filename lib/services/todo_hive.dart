import 'package:hive/hive.dart';
import 'package:todo_app/const.dart';
import 'package:todo_app/model/todo_model.dart';

class TodoHiveService {
  final Box<TodoModel> _box = Hive.box<TodoModel>(Appconst.todoBox);

 
  List<TodoModel> fetchTasks() {
    return _box.values.toList();
  }


  void addTask(TodoModel task) {
    _box.put(task.id, task);
  }


  void deleteTask(String taskId) {
    _box.delete(taskId);
  }

 
  void updateTask(String taskId, TodoModel updatedTask) {
    _box.put(taskId, updatedTask);
  }
  void updateTaskstatus(String taskId, TodoModel updatedTask) {
    _box.put(taskId, updatedTask);
  }
}
