class HabitStatusModel{
  int? id; // id
  int habitId;
  String habitTitle;
  DateTime date; // ngày lưu
  bool completed;

  HabitStatusModel({
    this.id,
    required this.habitId,
    required this.habitTitle,
    required this.date,
    required this.completed
  });
}