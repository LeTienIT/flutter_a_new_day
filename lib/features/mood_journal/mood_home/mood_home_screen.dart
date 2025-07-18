import 'dart:io';

import 'package:a_new_day/data/models/mood_model.dart';
import 'package:a_new_day/features/menu/menu.dart';
import 'package:a_new_day/features/mood_journal/mood_list/mood_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_flip/page_flip.dart';
import '../../../core/utils/tool.dart';
import '../mood_list/mood_list_controller.dart';
import '../mood_widget/input_audio.dart';

class MoodHomeScreen extends ConsumerWidget {
  MoodHomeScreen({super.key});
  final _controller = GlobalKey<PageFlipWidgetState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(moodListProvider);
    final controller = ref.watch(moodListProvider.notifier);
    MoodModel? mCurrent = controller.getToDay()!.isEmpty ? null : controller.getToDay()!.first;
    // print(mCurrent.toString());
    return Scaffold(
      appBar: mCurrent == null ? AppBar(
          title: Text(
            formatVietnameseDate(DateTime.now()),
            style: const TextStyle(fontSize: 16),
          ),
        )
          : null,
      body: switch (state) {
        MoodListLoading() => const Center(child: CircularProgressIndicator()),

        MoodListData() => (mCurrent==null) ?
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFa8edea), Color(0xFFfed6e3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.sentiment_satisfied_alt, size: 40, color: Colors.orange),
                    SizedBox(width: 10),
                    Text(
                      'Hôm nay bạn thế nào?',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, value, child) => Opacity(
                    opacity: value,
                    child: child,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.deepPurpleAccent,
                      elevation: 8,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {Navigator.pushNamedAndRemoveUntil(context, '/mood-add', (router)=>false);},
                    child: const Text(
                      'Lưu giữ lại ký ức hôm nay chứ?',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        : Center(
            child: PageFlipWidget(
              key: _controller,
              backgroundColor: const Color(0xFFFBF6EF), // Màu giấy ngà
              lastPage: _buildCoverPage(), // Trang cuối - bìa sau
              children: [
                _buildFirstPage(mCurrent),
                ..._buildNotePages(context, mCurrent.note),
                _buildImageAudio(context, mCurrent.image, mCurrent.audio)
              ],
            ),
        ),

        MoodListError() => const Center(child: Text("Lỗi tải dữ liệu")),
        _ => const SizedBox(),
      },
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Transform.translate(
        offset: const Offset(-5, 5),
        child: FloatingActionButton(
          mini: true,
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            '/mood-list',
                (route) => false,
          ),
          child: const Icon(Icons.list, size: 16),
        ),
      ),
    );
  }

  Widget _buildPage(int number) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF6EF), // Màu giống giấy
        border: const Border(
          right: BorderSide(color: Color(0xFFD6C6B5), width: 6), // Viền bên phải
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withValues(alpha: 0.15),
            offset: const Offset(2, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Trang $number',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            fontFamily: 'Georgia',
            color: Colors.brown,
          ),
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
    const padding = EdgeInsets.all(24);
    const margin = EdgeInsets.all(20);
    final maxWidth = size.width - padding.horizontal - margin.horizontal - 40;
    final maxHeight = size.height - padding.vertical - margin.vertical;
    final style = const TextStyle(fontSize: 18, height: 1.5);

    final pages = splitNoteToPages(
      note: note,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      style: style,
    );

    int i = 1;
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
                width: 80,
                height: 20,
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              bottom: 0, 
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text('${i++}'),
                ),
              ),
            ),
          ]
      )
    ))
        .toList();
  }

  Widget _buildImageAudio(BuildContext context, String? image, String? audio) {
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
        child: Column(
          children: [
            if(image!.isNotEmpty)
              Image.file(
                File(image!),
                fit: BoxFit.cover,
              ),
            if(audio!.isNotEmpty)
              AudioRecorderWidget(
                initialAudioPath: audio,
                onAudioSaved: (path) {
                },
              ),
          ],
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
              'I LOVE YOU <3000',
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
