import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_with_cubit/core/init/theme/to_do_theme.dart';
import 'package:to_do_app_with_cubit/features/cubit/to_do/to_do_cubit.dart';
import 'package:to_do_app_with_cubit/features/cubit/to_do/to_do_state.dart';
import 'package:to_do_app_with_cubit/features/view/bottom_nav_bar.dart';

import 'product/service/locator.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ToDoCubit(InitialAppState()),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ToDoTheme.defaultTheme,
        home: BottomNavBar(),
      ),
    );
  }
}
