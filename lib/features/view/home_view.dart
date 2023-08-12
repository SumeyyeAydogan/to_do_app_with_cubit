import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:to_do_app_with_cubit/data/local_storage.dart';
import 'package:to_do_app_with_cubit/features/model/task_model.dart';
import 'package:to_do_app_with_cubit/features/widget/task_list_item.dart';

import '../../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TimeOfDay nowTime;
  late List<Task>? _allTasks;
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    nowTime = TimeOfDay.now();
    _allTasks = <Task>[];
    _getAllTaskFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: GestureDetector(
              onTap: () => _showAddTaskBottomSheet(context),
              child: Text("What are going to do today?")),
          centerTitle: false,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            IconButton(
                onPressed: () =>
                    _showAddTaskBottomSheet(context), //sor bu kısmı
                icon: const Icon(Icons.add)),
          ],
        ),
        body: _allTasks!.isNotEmpty
            ? ListView.builder(
                itemBuilder: (context, index) {
                  var thisTask = _allTasks![index];
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
                      _allTasks!.removeAt(index);
                      _localStorage.deleteTask(task: thisTask);
                      setState(() {});
                    },
                    child: TaskItem(task: thisTask),
                  );
                },
                itemCount: _allTasks!.length,
              )
            : const Center(
                child: Text("Let's add task!"),
              ));
  }

  _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context)
                    .viewInsets
                    .bottom), //klavyenin üstüne koyar
            width: MediaQuery.of(context).size.width,
            child: ListTile(
              title: TextField(
                autofocus: true,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                  hintText: "Type task",
                  border: InputBorder.none, //alttatki çizgiyi kaldırdı
                ),
                onSubmitted: (value) {
                  Navigator.of(context).pop();
                  if (value.length > 3) {
                    /* showTimePicker(context: context, initialTime: nowTime)
                        .then((time) async {
                      var newAddedTask =
                          Task.create(name: value, createdAt: time);
                      //debugPrint(time!.format(context));
                      _allTasks!.insert(0, newAddedTask);
                      await _localStorage.addTask(task: newAddedTask);
                      setState(() {});
                    }); */
                    DatePicker.showTimePicker(context, showSecondsColumn: false, onConfirm: (time) async {
                      var newAddedTask =
                          Task.create(name: value, createdAt: time);
                      _allTasks!.insert(0, newAddedTask);
                      await _localStorage.addTask(task: newAddedTask);
                      setState(() {});    
                    },);
                  }

                  
                },
              ),
            ),
          );
        });
  }

  void _getAllTaskFromDb() async {
    _allTasks = await _localStorage.getAllTask();
    setState(() {});
  }
}
