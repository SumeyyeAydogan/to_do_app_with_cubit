import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_with_cubit/core/constants/application_constants.dart';
import 'package:to_do_app_with_cubit/core/extension/context_extension.dart';
import 'package:to_do_app_with_cubit/features/cubit/tab/tab_cubit.dart';
import 'package:to_do_app_with_cubit/features/cubit/to_do/to_do_cubit.dart';
import 'package:to_do_app_with_cubit/features/cubit/to_do/to_do_state.dart';
import 'package:to_do_app_with_cubit/features/view/all_todos_view.dart';
import 'package:to_do_app_with_cubit/features/view/archive_view.dart';
import 'done_view.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

@override
void initState() {}

class _BottomNavBarState extends State<BottomNavBar>
    with TickerProviderStateMixin {
  List<Widget> screenList = [
    const AllToDosPage(),
    const DonePage(),
    ArchivePage(),
  ];

  @override
  Widget build(BuildContext context) {
    context.read<ToDoCubit>().getAllTaskFromDb();
    return BlocProvider(
      create: (context) => TabCubit(TabController(length: 3, vsync: this)),
      child: BlocBuilder<TabCubit, TabState>(
        builder: (context, state) {
          if (state is TabInitial) {
            return Scaffold(
                appBar: AppBar(
                  title: GestureDetector(
                      onTap: () => _showAddTaskBottomSheet(context),
                      child: const Text(ApplicationConstants.QUESTION)),
                  centerTitle: false,
                  actions: [
                    IconButton(
                        onPressed: () => context
                            .read<ToDoCubit>()
                            .showSearchDelegate(context),
                        icon: const Icon(
                          Icons
                              .search, /* color: context.theme.colorScheme.primary, */
                        )),
                    IconButton(
                        onPressed: () =>
                            _showAddTaskBottomSheet(context), //sor bu kısmı
                        icon: const Icon(Icons.add)),
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                    currentIndex: state.tabController!.index,
                    onTap: (index) {
                      context.read<TabCubit>().changeIndex(index: index);
                      //context.read<ToDoCubit>().setBottomIndex(index);
                      //cubit.setBottomIndex(index);
                    },
                    items: const [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home_outlined), label: "Home"),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.done_outlined), label: "Done"),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.archive_outlined),
                          label: "Archived"),
                    ]),
                body: screenList[state.tabController!.index]);
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: context.paddingTopKeyboard, //klavyenin üstüne koyar
            width: context.width,
            child: BlocConsumer<ToDoCubit, ToDoState>(
              listener: (context, state) {
                if (state is SetDateState) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Date was selected"),
                    backgroundColor: Colors.red,
                  ));
                }
                /* if (state is AddedTaskState) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Added Task"),
                    backgroundColor: Colors.green,
                  ));
                } */
                //Burayı dinlemiyor olabilir, bir kontrol et
              },
              builder: (context, state) {
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
                        /* context.select<ToDoCubit, ToDoState>(
                            (ToDoCubit cubit) => cubit.state.deger); 
                            Tek bir state ve tek değerr varsa içerisinde bu şekilde erişebiliriz.
                            */
                        await context.read<ToDoCubit>().setDate(context, value);
                        if (state is SetDateState) {
                          if (state.initialDate != null) {
                            await context
                                .read<ToDoCubit>()
                                .addTask(value, state.initialDate);
                          }
                        }

                        //context.watch<ToDoCubit>().setDate(context, value);

                        //*******************

                        //cubit.setDate(context, value);*/

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
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content:
                              Text(ApplicationConstants.VALIDATE_FORM_ERROR),
                          backgroundColor: Colors.red,
                        ));
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
