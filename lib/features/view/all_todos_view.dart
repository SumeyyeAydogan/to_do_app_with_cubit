import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_with_cubit/features/cubit/to_do_cubit.dart';

import '../../product/widget/task_list_item.dart';
import '../cubit/to_do_state.dart';

class AllToDosPage extends StatelessWidget {
  const AllToDosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoState>(
      listener: (context, state) {
        // TODO: implement listener
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
              key: Key(thisTask.id),
              onDismissed: (direction) {
                cubit.deleteTask(thisTask);
                if (state is DeleteTaskState) {
                  cubit.allTasks!.removeAt(index);
                }
              },
              child: TaskItem(task: thisTask),
            );
          },
          itemCount: cubit.allTasks!.length,
        );
      },
    );
    /* ListView.builder(
      itemBuilder: (context, index) {
        return Text(index.toString() + "all todos page");
      },
      itemCount: 20,
      shrinkWrap: true,
    ); */
  }
}
