class HabitModel{
  int? id;
  String name;
  List<int> repeatDays; // Ví dụ: [1, 3, 5] = T2, T4, T6
  String? icon;
  String? color;
  DateTime createdAt;

  HabitModel({
      this.id,
      required this.name,
      required this.repeatDays,
      this.icon,
      this.color,
      required this.createdAt
  });
}