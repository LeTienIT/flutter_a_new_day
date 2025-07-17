import 'package:a_new_day/data/database/dao/mood_dao.dart';
import 'package:a_new_day/data/models/mood_model.dart';
import 'package:a_new_day/features/mood_journal/mood_list/mood_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/database/providers/database_providers.dart';

final moodListProvider = NotifierProvider<MoodListController, MoodListState>(
  MoodListController.new
);

class MoodListController extends Notifier<MoodListState>{
  late final MoodDAO moodDao;
  @override
  MoodListState build() {
    moodDao = ref.read(moodDaoProvider);
    Future.microtask(() => _loadData());
    return MoodListLoading();
  }

  Future<void> refresh() async => _loadData();

  Future<void> _loadData() async{
    try{
      state = MoodListLoading();
      final moods = await moodDao.getAllMood();
      state = MoodListData(moods);
    }catch(e){
      state = MoodListError(e.toString());
    }
  }

  void setActiveItem(int? id) {
    final currentState = state;
    if (currentState is MoodListData) {
      state = MoodListData(
        currentState.listData,
        activeItemId: id,
      );
    }
  }

  bool isActive(int id) {
    return state.activeItemId == id;
  }

  Future<void> insertMood(MoodModel m) async {
    await moodDao.insertMood(m);
    await _loadData();
  }

  List<MoodModel>? getToDay(){
    final currentState = state;
    final now = DateTime.now();
    if (currentState is MoodListData) {
      final rs = currentState.listData.where((t) => t.date.year==now.year&&t.date.month==now.month&&t.date.day==now.day).toList();
      return rs;
    }
    else{
      return [];
    }
  }
}