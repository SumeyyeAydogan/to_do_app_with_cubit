import 'dart:ffi';

import 'package:hive_flutter/adapters.dart';
import 'package:to_do_app_with_cubit/features/model/task_model.dart';

abstract class LocalStorage {
  Future<void> addTask({required Task task});
  Future<Task?> getTask({required String id});
  Future<List<Task>?> getAllTask();
  Future<bool> deleteTask({required Task task});
  Future<Task?> updateTask({required Task task});
}

class HiveLocalStorage extends LocalStorage {
  late Box<Task> _taskBox;

  HiveLocalStorage() {
    _taskBox = Hive.box<Task>('tasks');
  }

  @override
  Future<void> addTask({required Task task}) async {
    await _taskBox.put(task.id, task);
  }

  @override
  Future<bool> deleteTask({required Task task}) async {
    await _taskBox.delete(task.id);
    return true;
  }

  @override
  Future<List<Task>?> getAllTask() async {
    List<Task> allTask = <Task>[];
    allTask = _taskBox.values.toList();

    if (allTask.isNotEmpty) {
      //_allTask.sort((Task a, Task b) => a.createdAt.compareTo(b.createdAt));
      //Burda non-nullable hatası alıyorum
    }
    return allTask;
  }

  @override
  Future<Task?> getTask({required String id}) async {
    if (_taskBox.containsKey(id)) {
      _taskBox.get(id);
    } else {
      return null;
    }
  }

  @override
  Future<Task?> updateTask({required Task task}) async{
    task.save();
  }
}
