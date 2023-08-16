import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_with_cubit/core/constants/application_constants.dart';
import 'package:to_do_app_with_cubit/product/data/local_storage.dart';
import 'package:to_do_app_with_cubit/features/cubit/to_do_cubit.dart';
import 'package:to_do_app_with_cubit/features/cubit/to_do_state.dart';
import 'package:to_do_app_with_cubit/features/model/task_model.dart';
import 'package:to_do_app_with_cubit/features/view/all_todos_view.dart';
import 'package:to_do_app_with_cubit/features/view/archive_view.dart';
import 'package:to_do_app_with_cubit/product/widget/task_list_item.dart';
import '../../product/service/locator.dart';
import 'done_view.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  List<Widget> screenList = const [
    AllToDosPage(),
    DonePage(),
    ArchivePage(),
  ];

  final LocalStorage _localStorage = locator<LocalStorage>();

  /* @override
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
  } */

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubit = ToDoCubit.get(context);
        return Scaffold(
            appBar: AppBar(
              title: GestureDetector(
                  onTap: () => _showAddTaskBottomSheet(context),
                  child: const Text(ApplicationConstants.QUESTION)),
              centerTitle: false,
              actions: [
                IconButton(
                    onPressed: () => cubit.showSearchDelegate(context),
                    icon: const Icon(Icons.search)),
                IconButton(
                    onPressed: () =>
                        _showAddTaskBottomSheet(context), //sor bu kısmı
                    icon: const Icon(Icons.add)),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.setBottomIndex(index);
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined), label: "Home"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.done_outlined), label: "Done"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined), label: "Archived"),
                ]),
            body: cubit.allTasks!.isNotEmpty
                ? ListView.builder(
                    itemBuilder: (context, index) {
                      var thisTask = cubit.allTasks![index];
                      cubit.setListIndex(index);
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
                          //cubit.deleteTask();
                          cubit.allTasks!.removeAt(index);
                          _localStorage.deleteTask(task: thisTask);
                        },
                        child: TaskItem(task: thisTask),
                      );
                    },
                    itemCount: cubit.allTasks!.length,
                  )
                : const Center(
                    child: Text(ApplicationConstants.ADD_TASK),
                  ));
      },
    );
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
            child: BlocConsumer<ToDoCubit, ToDoState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                var cubit = ToDoCubit.get(context);
                return ListTile(
                  title: TextField(
                    autofocus: true,
                    style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                      hintText: ApplicationConstants.TYPE_TASK,
                      border: InputBorder.none, //alttatki çizgiyi kaldırdı
                    ),
                    onSubmitted: (value) {
                      Navigator.of(context).pop();
                      if (value.length > 3) {
                        cubit.setDate(context, value);

                        /* DatePicker.showTimePicker(
                                  context,
                                  showSecondsColumn: false,
                                  onConfirm: (time) async {
                                    var newAddedTask =
                                        Task.create(name: value, createdAt: time);
                                    _allTasks!.insert(0, newAddedTask);
                                    await _localStorage.addTask(task: newAddedTask);
                                    setState(() {});
                                  },
                                ); */
                      }
                    },
                  ),
                );
              },
            ),
          );
        });
  }
}
