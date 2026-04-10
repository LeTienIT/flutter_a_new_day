import 'dart:io';

import 'package:a_new_day/data/models/mood_model.dart';
import 'package:a_new_day/features/menu/menu.dart';
import 'package:a_new_day/features/mood_journal/mood_list/mood_list_state.dart';
import 'package:a_new_day/features/mood_journal/widget/tap_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_flip/page_flip.dart';
import '../../../core/utils/tool.dart';
import '../../setting/icon_edit/file_icon_controller.dart';
import '../mood_list/mood_list_controller.dart';
import '../mood_widget/full_image_screen.dart';
import '../mood_widget/input_audio.dart';
import '../mood_widget/video_input.dart';
import '../widget/cover_page.dart';
import '../widget/first_page.dart';

class MoodHomeScreen extends ConsumerStatefulWidget{
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MoodHomeScreen();
  }
}

class _MoodHomeScreen extends ConsumerState {
  _MoodHomeScreen();
  final _controller = GlobalKey<PageFlipWidgetState>();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(fileIconProvider.notifier).load(isAll: true);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showTopToast(context, "Chạm 3 lần liên tiếp để mở menu");
    });
  }

  @override
  Widget build(BuildContext context ) {
    final state = ref.watch(moodListProvider);
    final controller = ref.watch(moodListProvider.notifier);
    MoodModel? mCurrent = controller.getToDay()!.isEmpty ? null : controller.getToDay()!.first;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return TripleTapBackWrapper(
        onHandel: (){
          _scaffoldKey.currentState?.openDrawer();
        },
        child: SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            key: _scaffoldKey,
            appBar: mCurrent == null ? AppBar(
              title: Text(
                formatVietnameseDate(DateTime.now()),
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFa8edea),
                      Color(0xFFa8edea),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ) : null,
            drawer: Drawer(surfaceTintColor: Colors.black,child: Menu(),),
            drawerEnableOpenDragGesture: false,
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
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
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
                          onPressed: () {Navigator.pushNamed(context, '/mood-add');},
                          child: ShaderMask(
                            shaderCallback: (bounds) {
                              return const LinearGradient(
                                colors: [Color(0xFFa8edea), Color(0xFFfed6e3)],
                              ).createShader(bounds);
                            },
                            child: const Text(
                              'Lưu giữ lại ký ức hôm nay chứ?',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ) : Center(
                child: PageFlipWidget(
                  key: _controller,
                  backgroundColor: const Color(0xFFFBF6EF), // Màu giấy ngà
                  lastPage: const CoverPageView(),
                  children: [
                    FirstPageView(m: mCurrent),
                    ..._buildNotePages(context, mCurrent.note),
                    if(mCurrent.image?.isNotEmpty == true || mCurrent.audio?.isNotEmpty == true || mCurrent.video?.isNotEmpty == true)
                      _buildImageAudio(context, mCurrent.image, mCurrent.audio, mCurrent.video)
                  ],
                ),
              ),

              MoodListError() => const Center(child: Text("Lỗi tải dữ liệu")),
            },
          ),
        ),
    );
  }

  List<Widget> _buildNotePages(BuildContext context, String? note) {
    if (note == null || note.trim().isEmpty) return [];

    final size = MediaQuery.of(context).size;
    const padding = EdgeInsets.all(24);
    const margin = EdgeInsets.all(30);
    final maxWidth = size.width - padding.horizontal - margin.horizontal - 40;
    final maxHeight = size.height - padding.vertical - margin.vertical;
    final style = const TextStyle(fontSize: 18, height: 1.5, color: Colors.black);

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
                        builder: (_) => FullScreenImagePage(imagePath: image),
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

}
