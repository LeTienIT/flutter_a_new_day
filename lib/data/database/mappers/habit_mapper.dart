import 'dart:convert';

import 'package:a_new_day/data/models/habit_status_model.dart';
import 'package:drift/drift.dart';

import '../../models/habit_model.dart';
import '../app_database.dart';

extension HabitMapper on Habit {
  HabitModel toModel() => HabitModel(
    id: id,
    name: name,
    repeatDays: List<int>.from(jsonDecode(repeatDays)),
    icon: icon,
    color: color,
    createdAt: createdAt,
  );
}

extension HabitModelMapper on HabitModel {
  HabitsCompanion toCompanion({bool nullToAbsent = false}) {
    return HabitsCompanion(
      id: id == null ? const Value.absent() : Value(id!),
      name: Value(name),
      repeatDays: Value(jsonEncode(repeatDays)),
      icon: icon == null ? const Value.absent() : Value(icon!),
      color: color == null ? const Value.absent() : Value(color!),
      createdAt: Value(createdAt),
    );
  }
}

extension HabitStatusMapper on HabitStatusData {
  HabitStatusModel toModel() => HabitStatusModel(
    id: id,
    habitId: habitId,
    habitTitle: habitTitle,
    date: date,
    completed: completed
  );
}

extension HabitStatusModelMapper on HabitStatusModel {
  HabitStatusCompanion toCompanion({bool nullToAbsent = false}) {
    return HabitStatusCompanion(
      id: id == null ? const Value.absent() : Value(id!),
      habitId: Value(habitId),
      habitTitle: Value(habitTitle),
      date : Value(date),
      completed : Value(completed),
    );
  }
}