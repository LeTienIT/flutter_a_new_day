import 'dart:io';

import 'package:a_new_day/core/utils/image_utils.dart';
import 'package:a_new_day/core/utils/video_utils.dart';
import 'package:a_new_day/data/database/dao/mood_dao.dart';
import 'package:a_new_day/data/models/mood_model.dart';
import 'package:a_new_day/features/mood_journal/mood_list/mood_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
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

  Future<String?> _confirmAudio(String? currentAudioPath) async {
    if (currentAudioPath == null) return null;

    try {
      final directory = await getApplicationDocumentsDirectory();
      final savedPath = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';

      final file = await File(currentAudioPath).copy(savedPath);

      return file.path;
    } catch (e) {
      print('Error confirming audio: $e');
      return null;
    }
  }

  Future<void> insertMood(MoodModel m) async {
    if(m.image?.isNotEmpty == true){
      final ImageUtils imageUtil = ImageUtils();
      final original = File(m.image!);
      final saved = await imageUtil.compressAndSaveIcon(original);
      if(saved!=null){
        m.image = saved.path;
      }
      else{
        m.image = null;
      }
    }

    if (m.video?.isNotEmpty == true) {
      final VideoUtils videoUtil = VideoUtils();
      final original = File(m.video!);
      final saved = await videoUtil.saveVideo(original);
      if (saved != null) {
        m.video = saved.path;
      } else {
        m.video = null;
      }
    }

    if(m.audio != null && m.audio!.isNotEmpty){
      final path = await _confirmAudio(m.audio);
      if(path != null){
        m.audio = path;
      }
    }

    await moodDao.insertMood(m);
    await _loadData();
  }

  Future<void> updateMood(MoodModel mLast, MoodModel m) async {
    final ImageUtils imageUtil = ImageUtils();
    final VideoUtils videoUtil = VideoUtils();

    // Xóa ảnh cũ nếu khác với ảnh mới
    if (mLast.image?.isNotEmpty == true && mLast.image != m.image) {
      await imageUtil.deleteFile(mLast.image!);
    }

    // Xóa video cũ nếu khác
    if (mLast.video?.isNotEmpty == true && mLast.video != m.video) {
      await videoUtil.deleteVideo(mLast.video!);
    }

    // Xóa audio cũ nếu khác
    if (mLast.audio?.isNotEmpty == true && mLast.audio != m.audio) {
      await imageUtil.deleteFile(mLast.audio!);
    }

    // Xử lý ảnh mới
    if (m.image?.isNotEmpty == true) {
      final original = File(m.image!);
      final saved = await imageUtil.compressAndSaveIcon(original);
      if (saved != null) {
        m.image = saved.path;
      } else {
        m.image = null;
      }
    }

    if (m.video?.isNotEmpty == true) {
      final original = File(m.video!);
      final saved = await videoUtil.saveVideo(original);
      if (saved != null) {
        m.video = saved.path;
      } else {
        m.video = null;
      }
    }

    // Xử lý audio mới
    if (m.audio?.isNotEmpty == true) {
      final path = await _confirmAudio(m.audio);
      if (path != null) {
        m.audio = path;
      }
    }

    await moodDao.updateMood(m);
    await _loadData();
  }

  Future<void> deleteMood(MoodModel mLast) async{
    final ImageUtils imageUtil = ImageUtils();
    final VideoUtils videoUtil = VideoUtils();

    if (mLast.image?.isNotEmpty == true ) {
      await imageUtil.deleteFile(mLast.image!);
    }

    if (mLast.video?.isNotEmpty == true ) {
      await videoUtil.deleteVideo(mLast.video!);
    }

    if (mLast.audio?.isNotEmpty == true ) {
      await imageUtil.deleteFile(mLast.audio!);
    }

    await moodDao.deleteMood(mLast.id!);
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