import 'package:a_new_day/data/models/mood_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_flip/page_flip.dart';

import '../mood_widget/build_content_list_page.dart';
import '../mood_widget/build_cover_page.dart';
import '../mood_widget/build_first_page.dart';
import '../mood_widget/build_media_page.dart';

class MoodBookScreen extends ConsumerStatefulWidget {
  final List<MoodModel> listMood;

  const MoodBookScreen(this.listMood, {super.key});

  @override
  ConsumerState<MoodBookScreen> createState() => _MoodBookScreenState();
}

class _MoodBookScreenState extends ConsumerState<MoodBookScreen> {
  final controller = GlobalKey<PageFlipWidgetState>();

  List<Widget>? pages;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _preparePages();
  }

  Future<void> _preparePages() async {
    await Future.delayed(const Duration(milliseconds: 50));

    final builtPages = _buildAllPages(context);

    await Future.delayed(const Duration(seconds: 10));

    if (mounted) {
      setState(() {
        pages = builtPages;
        isLoading = false;
      });
    }
  }
  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            "Đang mở quyển sách...",
            style: TextStyle(fontSize: 14),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = GlobalKey<PageFlipWidgetState>();

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Quyển sách của tâm hồn",
            style: TextStyle(fontSize: 16),
          ),
        ),
        body: isLoading ?
        _buildLoading()
            :Center(
          child: PageFlipWidget(
            key: controller,
            backgroundColor: const Color(0xFFFBF6EF),
            lastPage: buildCoverPage(),
            children: _buildAllPages(context),
          ),
        ),
      )
    );
  }

  List<Widget> _buildAllPages(BuildContext context) {
    final List<Widget> pages = [];

    for (int i = 0; i < widget.listMood.length; i++) {
      final mood = widget.listMood[i];

      pages.add(buildFirstPage(m: mood,));

      pages.addAll(buildNotePages(context, mood.note));

      if (mood.image?.isNotEmpty == true ||
          mood.audio?.isNotEmpty == true ||
          mood.video?.isNotEmpty == true) {
        pages.add(
          BuildMediaPage(context, image: mood.image, audio: mood.audio, video: mood.video),
        );
      }
    }

    return pages;
  }
}