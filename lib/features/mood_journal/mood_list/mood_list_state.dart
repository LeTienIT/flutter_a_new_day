import 'package:a_new_day/data/models/mood_model.dart';

sealed class MoodListState{
  final int? activeItemId;
  const MoodListState({this.activeItemId});
}

class MoodListLoading extends MoodListState {}

class MoodListData extends MoodListState {
  final List<MoodModel> listData;
  MoodListData(this.listData,{super.activeItemId});
}

class MoodListError extends MoodListState{
  final String message;
  MoodListError(this.message);
}