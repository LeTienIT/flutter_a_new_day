class MoodModel{
  int? id;
  DateTime date;
  String emoji; // Biểu tượng cảm xúc
  String? image;
  String? audio;
  String? note;

  MoodModel({this.id, required this.date, required this.emoji, this.image, this.audio, this.note});

  @override
  String toString() {
    return 'MoodModel{id: $id, date: $date, emoji: $emoji, image: $image, audio: $audio, note: $note}';
  }
}