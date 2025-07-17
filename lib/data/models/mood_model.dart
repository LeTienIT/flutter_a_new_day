class MoodModel{
  int? id;
  DateTime date;
  String emoji; // Biểu tượng cảm xúc
  String? note;

  MoodModel({this.id, required this.date, required this.emoji, this.note});
}