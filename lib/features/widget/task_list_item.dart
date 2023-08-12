import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app_with_cubit/data/local_storage.dart';
import 'package:to_do_app_with_cubit/main.dart';

import '../model/task_model.dart';

class TaskItem extends StatefulWidget {
  Task task;
  TaskItem({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  late LocalStorage _localStorage;
  TextEditingController _taskNameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _localStorage = locator<LocalStorage>();
    _taskNameController.text = widget.task.name;
  }

  @override
  Widget build(BuildContext context) {
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
                    decoration: TextDecoration.lineThrough, color: Colors.grey),
              )
            : TextField(
                controller: _taskNameController,
                minLines: 1,
                maxLines: null,
                textInputAction: TextInputAction
                    .done, //klavyede tik işareti olmasını sağlar.
                decoration: const InputDecoration(border: InputBorder.none),
                onSubmitted: (newValue) {
                  if (newValue.length > 3) {
                    widget.task.name = newValue;
                    _localStorage.updateTask(task: widget.task);
                  }
                },
              ),
        leading: GestureDetector(
          onTap: () {
            widget.task.isCompleted = !widget.task.isCompleted;
            _localStorage.updateTask(task: widget.task);
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
            //DateFormat("hh: mm a").format()
            "time" //zamanı yazdıramadım
            ),
      ),
    );
  }
}
