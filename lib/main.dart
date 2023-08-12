import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app_with_cubit/data/local_storage.dart';
import 'package:to_do_app_with_cubit/features/model/task_model.dart';
import 'package:to_do_app_with_cubit/features/view/home_view.dart';

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

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //runApp'ten önce çalışması gereken işlemler varsa yazılmalıdır.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  await setUpHive();
  setUp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.blue),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
