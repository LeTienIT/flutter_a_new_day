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
import '../widget/cover_page.dart';
import '../widget/first_page.dart';

class TripleTapBackWrapper extends StatefulWidget {
  final Widget child;

  const TripleTapBackWrapper({super.key, required this.child});

  @override
  State<TripleTapBackWrapper> createState() => _TripleTapBackWrapperState();
}

class _TripleTapBackWrapperState extends State<TripleTapBackWrapper> {
  int _tapCount = 0;
  DateTime? _lastTap;

  void _handleTap(BuildContext context) {
    final now = DateTime.now();

    if (_lastTap == null ||
        now.difference(_lastTap!) > const Duration(seconds: 1)) {
      _tapCount = 0;
    }

    _tapCount++;
    _lastTap = now;

    if (_tapCount >= 3) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _handleTap(context),
      child: widget.child,
    );
  }
}

class MoodViewScreen extends ConsumerStatefulWidget {
  final MoodModel mood;

  const MoodViewScreen({super.key, required this.mood});

  @override
  ConsumerState<MoodViewScreen> createState() => _MoodViewScreenState();
}


class _MoodViewScreenState extends ConsumerState<MoodViewScreen> {

  final _controller = GlobalKey<PageFlipWidgetState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showTopToast(context, "Chạm 3 lần để quay lại");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    MoodModel? mCurrent = widget.mood;

    return TripleTapBackWrapper(
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: const Color(0xFFFBF6EF),
          body: Center(
            child: PageFlipWidget(
              key: _controller,
              backgroundColor: const Color(0xFFFBF6EF),
              lastPage: CoverPageView(),
              children: [
                FirstPageView(m: mCurrent),
                ...buildNotePages(context, mCurrent.note),
                if(mCurrent.image?.isNotEmpty == true || mCurrent.audio?.isNotEmpty == true || mCurrent.video?.isNotEmpty == true)
                  BuildMediaPage(context, image: mCurrent.image, audio: mCurrent.audio, video:  mCurrent.video),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

