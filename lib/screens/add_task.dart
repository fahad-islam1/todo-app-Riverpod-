import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/providers/todo_provider.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  final bool isEditing;
  final TodoModel? task;

  AddTaskScreen({this.isEditing = false, this.task});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  String? selectedDate; 
  String? selectedTime; 
  String? status; 

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task?.title ?? '');
    descriptionController = TextEditingController(text: widget.task?.description ?? '');
    selectedDate = widget.task?.date;
    selectedTime = widget.task?.time;
    status = widget.task?.status;
  }

  Future<void> _pickDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          selectedDate = DateFormat('yyyy-MM-dd').format(pickedDate); 
          selectedTime = pickedTime.format(context); 
        });
      }
    }
  }

  void _saveTask() {
    final todoNotifier = ref.read(taskProvider.notifier);

    final newTask = TodoModel(
      id: widget.isEditing ? widget.task!.id : DateTime.now().millisecondsSinceEpoch.toString(),
      title: titleController.text,
      description: descriptionController.text,
      date: selectedDate ?? DateFormat('yyyy-MM-dd').format(DateTime.now()), // Default to today
      time: selectedTime ?? TimeOfDay.now().format(context), 
      status:status??"",
    );

    if (widget.isEditing) {
      todoNotifier.updateTask(widget.task!.id, newTask);
    } else {
      todoNotifier.addTask(newTask);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isEditing ? 'Edit Task' : 'Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate == null || selectedTime == null
                        ? 'Select Date & Time'
                        : '$selectedDate at $selectedTime',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _pickDateTime(context),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
                child: Text(widget.isEditing ? 'Update Task' : 'Add Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
