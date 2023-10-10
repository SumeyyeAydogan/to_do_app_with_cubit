import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_with_cubit/features/cubit/to_do/to_do_cubit.dart';

import '../../product/widget/task_list_item.dart';
import '../cubit/to_do/to_do_state.dart';

class AllToDosPage extends StatelessWidget {
  const AllToDosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoState>(
      listener: (context, state) {
        if (state is SetDateState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("${state.initialDate}"),
                        backgroundColor: Colors.red,
                      ));
          if (state.initialDate != null) {
                            context
                                .read<ToDoCubit>()
                                .addTask(state.newAddedTask.name, state.initialDate);
                          }            
        }
        if (state is AddedTaskState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("${state.newAddedTask.name}"),
                        backgroundColor: Colors.blue,
                      ));        
        }
      },
      builder: (context, state) {
        var cubit = ToDoCubit.get(context);
        return ListView.builder(
          itemBuilder: (context, index) {
            var thisTask = cubit.allTasks![index];
            //cubit.setListIndex(index);
            return Dismissible(
              //yana kaydırınca silmek için
              background: const Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.delete,
                    color: Colors.grey,
                  )),
              key: UniqueKey(), //key(this.id yapmıştım önce)
              onDismissed: (direction) {
                cubit.allTasks!.removeAt(index);
                cubit.deleteTask(thisTask);
              },
              child: TaskItem(
                  task: thisTask,
                  taskNameController: TextEditingController.fromValue(
                    TextEditingValue(text: thisTask.name),
                  )),
            );
          },
          itemCount: cubit.allTasks!.length,
        );
      },
    );
  }
}
