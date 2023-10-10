import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app_with_cubit/features/cubit/to_do/to_do_cubit.dart';
import 'package:to_do_app_with_cubit/product/service/local_storage.dart';
import '../../features/cubit/to_do/to_do_state.dart';
import '../../features/model/task_model.dart';
import '../service/locator.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final TextEditingController taskNameController;
  const TaskItem(
      {Key? key, required this.task, required this.taskNameController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubit = ToDoCubit.get(context);
        Future.microtask(() {
          taskNameController.text = task.name;
        }); //Futuremicrotask

        /*Exception has occurred.
        FlutterError (setState() or markNeedsBuild() called during build.
        This AnimatedBuilder widget cannot be marked as needing to build because the framework is already in the process of building widgets. A widget can be marked as needing to be built during the build phase only if one of its ancestors is currently building. This exception is allowed because the framework builds parent widgets before children, which means a dirty descendant will always be built. Otherwise, the framework might not visit this widget during this build phase.
        The widget on which setState() or markNeedsBuild() was called was:
          AnimatedBuilder
        The widget which was currently being built when the offending call was made was:
          BlocBuilder<ToDoCubit, ToDoState>) */
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.2),
                blurRadius: 10, //dağıtmaya yarıyor.
              ),
            ],
          ),
          child: ListTile(
            title: task.isCompleted
                ? Text(
                    task.name,
                    style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey),
                  )
                : TextField(
                    controller: taskNameController,
                    minLines: 1,
                    maxLines: null,
                    textInputAction: TextInputAction
                        .done, //klavyede tik işareti olmasını sağlar.
                    decoration: const InputDecoration(border: InputBorder.none),
                    onSubmitted: (newValue) async {
                      if (newValue.length > 3) {
                        cubit.setName(newValue, task);
                        if (state is SetNameState) {
                          task.name = state.newName;
                        } else {
                          const SnackBar(content: Text("An error"));
                        }
                      }
                    },
                  ),
            leading: GestureDetector(
              onTap: () async {
                cubit.setCompleted(task);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: task.isCompleted
                      ? Colors.green
                      : Colors.white, //state ile nasıl ulaşacağımı çözemedim
                  border: Border.all(color: Colors.grey, width: 0.8),
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
            ),
            trailing: Text(
              DateFormat("hh: mm a").format(task.createdAt!),
            ),
          ),
        );
      },
    );
  }
}
