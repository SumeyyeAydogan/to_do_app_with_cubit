import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app_with_cubit/features/cubit/to_do_cubit.dart';
import 'package:to_do_app_with_cubit/product/data/local_storage.dart';
import '../../features/cubit/to_do_state.dart';
import '../../features/model/task_model.dart';
import '../service/locator.dart';

class TaskItem extends StatefulWidget {
  Task task;
  TaskItem({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  late LocalStorage _localStorage; //LateError (LateInitializationError: Field '_localStorage@43433232' has not been initialized.)

  @override
  void initState() {
    // TODO: implement initState
    //_localStorage = locator<LocalStorage>(); //bunu sadece cubitte oluşturmak yeterli mi?
    //taskNameController.text = widget.task.name;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubit = ToDoCubit.get(context);
        cubit.taskNameController.text = widget.task.name; //setstate build boyunca çalışıyormuş
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
            title: widget.task.isCompleted
                ? Text(
                    widget.task.name,
                    style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey),
                  )
                : TextField(
                    controller: cubit.taskNameController,
                    minLines: 1,
                    maxLines: null,
                    textInputAction: TextInputAction
                        .done, //klavyede tik işareti olmasını sağlar.
                    decoration: const InputDecoration(border: InputBorder.none),
                    onSubmitted: (newValue) async{
                      if (newValue.length > 3) {
                       //cubit.setName(newValue);
                        widget.task.name = newValue;
                        await _localStorage.updateTask(task: widget.task);
                      }
                    },
                  ),
            leading: GestureDetector(
              onTap: () async{
                //cubit.setCompleted();
                widget.task.isCompleted = !widget.task.isCompleted;
                await _localStorage.updateTask(task: widget.task);
                setState(() {});
              },
              child: Container(
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: widget.task.isCompleted ? Colors.green : Colors.white,
                  border: Border.all(color: Colors.grey, width: 0.8),
                ),
              ),
            ),
            trailing: Text(
              DateFormat("hh: mm a").format(cubit.initialDate),
            ),
          ),
        );
      },
    );
  }
}
