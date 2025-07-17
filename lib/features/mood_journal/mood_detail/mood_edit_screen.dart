import 'package:a_new_day/data/models/mood_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MoodEditScreen extends ConsumerStatefulWidget{
  final MoodModel mood;
  const MoodEditScreen({super.key, required this.mood});

  @override
  ConsumerState<MoodEditScreen> createState() => _MoodEditScreen();
}
class _MoodEditScreen extends ConsumerState<MoodEditScreen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}