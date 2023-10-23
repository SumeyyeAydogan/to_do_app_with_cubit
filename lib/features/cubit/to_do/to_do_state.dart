import 'package:equatable/equatable.dart';

import '../../model/task_model.dart';

abstract class ToDoState extends Equatable {}
class InitialState extends ToDoState {
  @override
  List<Object?> get props => [];
}
class AddedTaskState extends ToDoState {
  AddedTaskState(this.newAddedTask);
  final Task newAddedTask;
  @override
  List<Object?> get props => [newAddedTask];
}
class SetCompletedState extends ToDoState {
  SetCompletedState(this.isCompleted);
  final bool isCompleted;
  @override
  List<Object?> get props => [isCompleted];
}
class SetNameState extends ToDoState {
  SetNameState(this.newName);
  final String newName;
  @override
  List<Object?> get props => [newName];
}
class DeleteTaskState extends ToDoState {
  final String index;
  @override
  List<Object?> get props => [index];
  DeleteTaskState(this.index);
}
class GetBoxState extends ToDoState {
  @override
  List<Object?> get props => [];
}
class SetDateState extends ToDoState {
  SetDateState(this.initialDate, this.newAddedTask);
  final Task newAddedTask;
  final DateTime? initialDate;
  @override
  List<Object?> get props => [initialDate, newAddedTask];
}
class GetAllTaskState extends ToDoState {
  GetAllTaskState(this.allTasks);
  final List<Task>? allTasks;
  @override
  List<Object?> get props => [allTasks];
}
