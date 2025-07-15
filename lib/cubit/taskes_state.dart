import 'package:tasks_app_adavanced/model/taskes.dart';

class TaskesState {
  final List<Taskes> taskes;

  TaskesState({required this.taskes});

  TaskesState copyWith({List<Taskes>? taskes}) {
    return TaskesState(taskes: taskes ?? this.taskes);
  }
}
