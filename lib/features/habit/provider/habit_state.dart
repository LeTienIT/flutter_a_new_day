import 'package:a_new_day/data/models/habit_model.dart';

sealed class HabitListState {
  final int? activeItemId;
  const HabitListState({this.activeItemId});
}

class HabitListLoading extends HabitListState{}
class HabitListError extends HabitListState{
  final String message;
  HabitListError(this.message);
}
class HabitListData extends HabitListState{
  final List<HabitModel> listData;
  HabitListData(this.listData, {super.activeItemId});
}