import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app_with_cubit/features/cubit/to_do/to_do_state.dart';

import '../../../product/service/local_storage.dart';
import '../../../product/service/locator.dart';
import '../../../product/widget/custom_search_delegate.dart';
import '../../model/task_model.dart';

class ToDoCubit extends Cubit<ToDoState> {
  ToDoCubit(super.initialState);
  final LocalStorage _localStorage = locator<LocalStorage>();


  late List<Task>? allTasks = <Task>[];
  DateTime initialDate = DateTime.now(); 
  List<int>? keys = [];


  setDate(BuildContext context, value) {
    
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((time) async {
      DateTime selectedDate = DateTime(DateTime.now().year,
          DateTime.now().month, DateTime.now().day, time!.hour, time.minute);
      var newAddedTask = Task.create(
        name: value,
        createdAt: selectedDate.toUtc(),
      );      
      emit(SetDateState(selectedDate, newAddedTask));     });
    }

    addTask(String value, DateTime? date) async {
      var newAddedTask = Task.create(
          name: value,
          createdAt: date);
      allTasks!.insert(0, newAddedTask);
      await _localStorage.addTask(task: newAddedTask);
      emit(AddedTaskState(newAddedTask));
    }



    setName(String newValue, Task task) {
      task.name = newValue;
      _localStorage.updateTask(task: task);
      emit(SetNameState(newValue));
    }

    setCompleted(Task task) async {
      task.isCompleted = !task.isCompleted;
      await _localStorage.updateTask(task: task);
      emit(SetCompletedState(task.isCompleted));
    }

    deleteTask(Task task, int currentListIndex) async {
    allTasks!.removeAt(currentListIndex);
    await _localStorage.deleteTask(task: task);
    emit(DeleteTaskState(task.id));
  }

    void getAllTaskFromDb() async {
      allTasks = await _localStorage.getAllTask();
    }

    void showSearchDelegate(BuildContext context) {
      showSearch(context: context, delegate: CustomSearchDelegate());
    }

    getBox() async {
      var box = await Hive.openBox<Task>('tasks');
      keys = [];
      keys = box.keys.cast<int>().toList();
      allTasks = [];
      for (var key in keys!) {
        allTasks!.add(box.get(key)!);
      }
      box.close();
      emit(GetBoxState());
    }
  }

