import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'task.dart';
import 'dart:convert';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo List'),
      ),
      body: tasks.isEmpty
          ? Center(
              child: Text('Нет запланированных задач'),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index].title),
                  subtitle: Text(tasks[index].description),
                  trailing: Checkbox(
                    value: tasks[index].isCompleted,
                    onChanged: (value) {
                      setState(() {
                        tasks[index].isCompleted = value!;
                      });
                      _saveTasks(); // Сохраняем задачи после изменения
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailScreen(
                          task: tasks[index],
                          onTaskUpdated: (updatedTask) {
                            setState(() {
                              tasks[index] = updatedTask;
                            });
                            _saveTasks(); // Сохраняем задачи после изменения
                          },
                          onTaskDeleted: () {
                            setState(() {
                              tasks.removeAt(index);
                            });
                            _saveTasks(); // Сохраняем задачи после удаления
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToTaskDetailScreen();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _navigateToTaskDetailScreen() async {
    Task? newTask;

    newTask = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(
          onTaskUpdated: (dynamic updatedTask) {
            if (updatedTask is Task) {
              if (tasks.contains(updatedTask)) {
                setState(() {
                  tasks[tasks.indexOf(updatedTask)] = updatedTask;
                });
              } else {
                setState(() {
                  tasks.add(updatedTask);
                });
              }
              _saveTasks(); // Сохраняем задачи после обновления или добавления
            }
          },
          onTaskDeleted: () {
            if (newTask != null && tasks.contains(newTask)) {
              setState(() {
                tasks.remove(newTask);
              });
              _saveTasks(); // Сохраняем задачи после удаления
            }
          },
        ),
      ),
    );
    if (newTask != null && !tasks.contains(newTask)) {
      setState(() {
        tasks.add(newTask!);
      });
      _saveTasks(); // Сохраняем задачи после добавления
    }
  }

  void _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskStrings = prefs.getStringList('tasks');

    if (taskStrings != null) {
  setState(() {
    tasks = taskStrings.map((taskString) {
      Map<String, dynamic> jsonMap = jsonDecode(taskString);
      return Task.fromJson(jsonMap);
    }).toList();
  });
}
}

  void _saveTasks() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> taskStrings = tasks.map((task) => jsonEncode(task.toJson())).toList();
  prefs.setStringList('tasks', taskStrings);
}
}
