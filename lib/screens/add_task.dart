
import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  final bool isEditing;
  final String? taskTitle;
  final String? taskDescription;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;

  AddTaskScreen({this.isEditing = false, this.taskTitle, this.taskDescription, this.selectedDate, this.selectedTime});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.taskTitle ?? '');
    descriptionController = TextEditingController(text: widget.taskDescription ?? '');
    selectedDate = widget.selectedDate;
    selectedTime = widget.selectedTime;
  }

  Future<void> _pickDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime ?? TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          selectedDate = pickedDate;
          selectedTime = pickedTime;
        });
      }
    }
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
                    selectedDate == null
                        ? 'Select Date & Time'
                        : '${selectedDate!.toLocal()} at ${selectedTime!.format(context)}',
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
                onPressed: () {
                  Navigator.pop(context);
                },
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