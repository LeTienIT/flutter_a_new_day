import 'dart:io';

import 'package:a_new_day/data/models/mood_model.dart';
import 'package:a_new_day/features/menu/menu.dart';
import 'package:a_new_day/features/mood_journal/mood_list/mood_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_flip/page_flip.dart';
import '../../../core/utils/tool.dart';
import '../mood_list/mood_list_controller.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quyển sách của tâm hồn',
          style: const TextStyle(fontSize: 16),
        ),
      ),
      body: Center(
        child: PageFlipWidget(
          key: _controller,
          backgroundColor: const Color(0xFFFBF6EF),
          lastPage: _buildCoverPage(),
          children: [
            _buildFirstPage(mCurrent),
            ..._buildNotePages(context, mCurrent.note),
            if(mCurrent.image?.isNotEmpty == true || mCurrent.audio?.isNotEmpty == true || mCurrent.video?.isNotEmpty == true)
              _buildImageAudio(context, mCurrent.image, mCurrent.audio, mCurrent.video),
          ],
        ),
      ),
    );
  }
  Widget _buildFirstPage(MoodModel m) {
    final parts = m.emoji.split('|');
    final imagePath = parts.first;
    final slogan = parts.length > 1 ? parts.last : '';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFd7ccc8), Color(0xFFa1887f)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: const Border(
          right: BorderSide(color: Color(0xFFD6C6B5), width: 6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withValues(alpha: 0.15),
            offset: const Offset(2, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 30,
            child: Image.asset(
              'assets/sticker/hoa_sen.png',
              width: 80,
              height: 80,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/sticker/tra_sua.png',
              width: 80,
              height: 80,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 80,
            child: Image.asset(
              'assets/sticker/hoa_hong.png',
              width: 80,
              height: 80,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'NHẬT KÝ',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                formatVietnameseDate(m.date),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Image.asset(
                    imagePath,
                    width: 64,
                    height: 64,
                  ),
                  Text(
                    slogan,
                    style: const TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/emoji_default/arrow.png',
              width: 80,
              height: 20,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNotePages(BuildContext context, String? note) {
    if (note == null || note.trim().isEmpty) return [];

    final size = MediaQuery.of(context).size;
    const padding = EdgeInsets.all(18);
    const margin = EdgeInsets.all(16);
    final maxWidth = size.width - padding.horizontal - margin.horizontal - 80;
    final maxHeight = size.height - padding.vertical - margin.vertical;
    final style = const TextStyle(fontSize: 18, height: 1.2);

    final pages = splitNoteToPages(
      note: note,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      style: style,
    );

    return pages.map((pageText) => Container(
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          color: const Color(0xFFFBF6EF),
          border: const Border(
            right: BorderSide(color: Color(0xFFD6C6B5), width: 6),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withValues(alpha: 0.15),
              offset: const Offset(2, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Stack(
            children: [
              Text(
                pageText,
                style: style,
                textAlign: TextAlign.justify,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Image.asset(
                  'assets/emoji_default/arrow.png',
                  width: 30,
                  height: 20,
                  fit: BoxFit.fill,
                ),
              ),
            ]
        )
    ))
        .toList();
  }

  Widget _buildImageAudio(BuildContext context, String? image, String? audio, String? video) {
    if (image == null && audio == null) return SizedBox();
    const padding = EdgeInsets.all(24);
    const margin = EdgeInsets.all(20);
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: const Color(0xFFFBF6EF),
        border: const Border(
          right: BorderSide(color: Color(0xFFD6C6B5), width: 6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withValues(alpha: 0.15),
            offset: const Offset(2, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (image?.isNotEmpty == true) ...[
              Text('Bức ảnh đẹp nhất ngày đó'),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FullScreenImagePage(imagePath: image!),
                    ),
                  );
                },
                child: Image.file(
                  File(image!),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
            ],
            if (video?.isNotEmpty == true)...[
              Text('Khoảnh khắc kỷ niệm'),
              SizedBox(height: 10,),
              VideoInput(
                initialVideoPath: video,
                onVideoPicked: (path){},
                enableEdit: false,
              ),
              SizedBox(height: 20,),
            ],
            if (audio?.isNotEmpty == true)...[
              Text('Âm thanh của bạn'),
              SizedBox(height: 10,),
              AudioRecorderWidget(
                initialAudioPath: audio,
                onAudioSaved: (path) {},
                enableEdit: false,
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildCoverPage() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFd7ccc8), Color(0xFFa1887f)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: Image.asset(
              'assets/sticker/trai_tim.png',
              width: 60,
              height: 80,
            ),
          ),
          Positioned(
            top: 60,
            right: 20,
            child: Image.asset(
              'assets/sticker/buc_tranh.png',
              width: 100,
              height: 100,
            ),
          ),
          Positioned(
            bottom: 60,
            right: 20,
            child: Image.asset(
              'assets/sticker/hoa.png',
              width: 100,
              height: 100,
            ),
          ),
          Positioned(
            bottom: 60,
            left: 20,
            child: Image.asset(
              'assets/sticker/co_4_la.png',
              width: 100,
              height: 100,
            ),
          ),
          Center(
            child: Text(
              '<3 NHẬT KÝ CỦA TRÁI TIM S2',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: Colors.brown,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 3,
                    color: Colors.black26,
                  )
                ],
              ),
            ),
          ),
          const Positioned(
            bottom: 60,
            left: 16,
            right: 16,
            child: Text(
              '"Cảm xúc hôm nay là món quà của ngày mai"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
