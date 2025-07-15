import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tasks_app_adavanced/cubit/taskes_cubit.dart';
import 'package:tasks_app_adavanced/screens/homeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      home: BlocProvider(
        create: (context) {
          final cubit = TaskesCubit();
          cubit.loadTasksFromPrefs();
          return cubit;
        },
        child: const HomeScreen(),
      ),
    );
  }
}
