import 'package:flutter/material.dart';
import 'task.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task? task;
  final Function(Task) onTaskUpdated;
  final Function() onTaskDeleted;

  TaskDetailScreen({
    this.task,
    required this.onTaskUpdated,
    required this.onTaskDeleted,
  });

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактирование задачи'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              widget.onTaskDeleted();
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              final updatedTask = Task(
                title: _titleController.text,
                description: _descriptionController.text,
                isCompleted: widget.task?.isCompleted ?? false,
              );

              widget.onTaskUpdated(updatedTask);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Заголовок'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Описание'),
            ),
          ],
        ),
      ),
    );
  }
}
