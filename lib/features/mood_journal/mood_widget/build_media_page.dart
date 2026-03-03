import 'dart:io';

import 'package:a_new_day/features/mood_journal/mood_widget/video_input.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/tool.dart';
import 'full_image_screen.dart';
import 'input_audio.dart';

class BuildMediaPage extends StatelessWidget{
  BuildContext context;
  String? image;
  String? audio;
  String? video;

  BuildMediaPage(this.context, {super.key, this.image, this.audio, this.video});

  @override
  Widget build(BuildContext context) {
    if (image == null && audio == null && video == null) return SizedBox();
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
              FutureBuilder<String?>(
                future: resolveFilePath(image),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return Text("Có lỗi gì đó.");
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FullScreenImagePage(imagePath: snapshot.data!),
                        ),
                      );
                    },
                    child: Image.file(
                      File(snapshot.data!),
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
            ],
            if (video?.isNotEmpty == true)...[
              Text('Khoảnh khắc kỷ niệm'),
              SizedBox(height: 10,),
              FutureBuilder<String?>(
                future: resolveFilePath(video),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return Text("Có lỗi gì đó.");
                  }

                  return VideoInput(
                    initialVideoPath: snapshot.data!,
                    onVideoPicked: (path){},
                    enableEdit: false,
                  );
                },
              ),
              SizedBox(height: 20,),
            ],
            if (audio?.isNotEmpty == true)...[
              Text('Âm thanh của bạn'),
              SizedBox(height: 10,),
              FutureBuilder<String?>(
                future: resolveFilePath(audio),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return Text("Có lỗi gì đó.");
                  }

                  return AudioRecorderWidget(
                    initialAudioPath: snapshot.data!,
                    onAudioSaved: (path) {},
                    enableEdit: false,
                  );
                },
              ),
            ]
          ],
        ),
      ),
    );
  }


}