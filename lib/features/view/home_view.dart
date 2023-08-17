import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_with_cubit/core/constants/application_constants.dart';
import 'package:to_do_app_with_cubit/product/service/local_storage.dart';
import 'package:to_do_app_with_cubit/features/cubit/to_do_cubit.dart';
import 'package:to_do_app_with_cubit/features/cubit/to_do_state.dart';
import 'package:to_do_app_with_cubit/features/view/all_todos_view.dart';
import 'package:to_do_app_with_cubit/features/view/archive_view.dart';
import 'package:to_do_app_with_cubit/product/widget/task_list_item.dart';
import '../../product/service/locator.dart';
import '../model/task_model.dart';
import 'done_view.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  List<Widget> screenList = const [
    AllToDosPage(),
    DonePage(),
    ArchivePage(),
  ];

  final LocalStorage _localStorage = locator<LocalStorage>();

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
            body: /* cubit.allTasks!.isNotEmpty
                ? */
                screenList[cubit.currentIndex]
            /* : const Center(
                    child: Text(ApplicationConstants.ADD_TASK),
                  ) */
            );
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
                if(state is SetDateState){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Date was selected, an error"),
                        backgroundColor: Colors.red,
                      ));
                }
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
                    onSubmitted: (value) async {
                      Navigator.of(context).pop();
                      if (value.length > 3) {
                        cubit.setDate(context, value);
                        /* if (state is SetDateState) {
                          var newAddedTask = Task.create(
                              name: value, createdAt: state.initialDate);
                          cubit.allTasks!.add(newAddedTask);
                        } */
                        /* await cubit.setDate(context);
                        if (state is SetDateState) {
                          await cubit.addTask(value, state.initialDate);
                        }
                        if (state is AddedTaskState) {
                          cubit.allTasks!.add(state.newAddedTask);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Task couldn't add, an error"),,
                        backgroundColor: Colors.red,
                      ));
                        } */
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(ApplicationConstants.VALIDATE_FORM_ERROR),
                        backgroundColor: Colors.red,
                      ));}
                      
                    },
                  ),
                );
              },
            ),
          );
        });
  }
}
