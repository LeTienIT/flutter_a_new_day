import 'dart:io';

import 'package:a_new_day/data/models/mood_model.dart';
import 'package:a_new_day/features/menu/menu.dart';
import 'package:a_new_day/features/mood_journal/mood_list/mood_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_flip/page_flip.dart';
import '../../../core/utils/tool.dart';
import '../mood_list/mood_list_controller.dart';
import '../mood_widget/build_content_list_page.dart';
import '../mood_widget/build_cover_page.dart';
import '../mood_widget/build_first_page.dart';
import '../mood_widget/build_media_page.dart';
import '../mood_widget/full_image_screen.dart';
import '../mood_widget/input_audio.dart';
import '../mood_widget/video_input.dart';

class MoodViewScreen extends ConsumerWidget {
  MoodModel mood;

  MoodViewScreen({super.key, required this.mood});

  final _controller = GlobalKey<PageFlipWidgetState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    MoodModel? mCurrent = mood;

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFBF6EF),
          title: Text(
            'Quyển sách của tâm hồn',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        body: Center(
          child: PageFlipWidget(
            key: _controller,
            backgroundColor: const Color(0xFFFBF6EF),
            lastPage: buildCoverPage(),
            children: [
              buildFirstPage(m: mCurrent),
              ...buildNotePages(context, mCurrent.note),
              if(mCurrent.image?.isNotEmpty == true || mCurrent.audio?.isNotEmpty == true || mCurrent.video?.isNotEmpty == true)
                BuildMediaPage(context, image: mCurrent.image, audio: mCurrent.audio, video:  mCurrent.video),
            ],
          ),
        ),
      ),
    );
  }

}
