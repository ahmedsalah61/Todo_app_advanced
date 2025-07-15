import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasks_app_adavanced/cubit/taskes_state.dart';
import 'package:tasks_app_adavanced/model/taskes.dart';

class TaskesCubit extends Cubit<TaskesState> {
  TaskesCubit()
    : super(
        TaskesState(
          taskes: [
            Taskes(
              id: 1,
              due: DateTime.now().add(Duration(hours: 1)),
              title: "play some thing",
              isDone: false,
            ),
            Taskes(
              id: 2,
              due: DateTime.now().add(Duration(hours: 2)),
              title: "study so mush",
              isDone: false,
            ),
            Taskes(
              id: 3,
              due: DateTime.now().add(Duration(hours: 4)),
              title: "play some thing",
              isDone: false,
            ),
            Taskes(
              id: 4,
              due: DateTime.now().add(Duration(hours: 5)),
              title: "play some thing",
              isDone: false,
            ),
            Taskes(
              id: 5,
              due: DateTime.now().add(Duration(hours: 5)),
              title: "play some thing",
              isDone: false,
            ),
          ],
        ),
      );
  void addTask(Taskes task) {
    final updated = List<Taskes>.from(state.taskes)..add(task);
    emit(state.copyWith(taskes: updated));
    _saveTaskePref();
  }

  void deleteTask(int id) {
    final updated = state.taskes.where((task) => task.id != id).toList();
    emit(state.copyWith(taskes: updated));
    _saveTaskePref();
  }

  void toggleDone(int id, bool isDone) {
    final updated = state.taskes.map((task) {
      if (task.id == id) {
        return Taskes(
          id: task.id,
          title: task.title,
          due: task.due,
          isDone: isDone,
        );
      }
      return task;
    }).toList();
    emit(state.copyWith(taskes: updated));
  }

  Future<void> _saveTaskePref() async {
    final pref = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList = state.taskes
        .map((e) => e.toJson())
        .toList();
    pref.setString('tasks', jsonEncode(jsonList));
  }

  Future<void> loadTasksFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? data = prefs.getString('tasks');

      if (data != null) {
        final List<dynamic> decoded = jsonDecode(data);
        final List<Taskes> loaded = decoded
            .map((e) => Taskes.fromJson(e))
            .toList();
        emit(TaskesState(taskes: loaded));
      }
    } catch (e) {
      debugPrint('Error loading tasks: $e');
      emit(TaskesState(taskes: []));
    }
  }
}
