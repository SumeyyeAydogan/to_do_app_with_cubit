import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/model/task_model.dart';
import '../data/local_storage.dart';

final locator = GetIt.instance;

void setUp() {
  locator.registerSingleton<LocalStorage>(HiveLocalStorage());
}

Future<void> setUpHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  var taskBox = await Hive.openBox<Task>('tasks');
  /* taskBox.values.forEach((element) {
    if (element.createdAt!.hour != DateTime.now().day) {
      taskBox.delete(element.id);
    }
  }); */
}
