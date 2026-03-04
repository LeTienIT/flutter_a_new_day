import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../core/utils/tool.dart';
import '../../../data/models/mood_model.dart';
import '../mood_widget/full_image_screen.dart';
import '../mood_widget/input_audio.dart';
import '../mood_widget/video_input.dart';

class MoodMediaPage extends StatelessWidget {
  final List<MoodModel> moods;

  const MoodMediaPage(this.moods, {super.key});

  @override
  Widget build(BuildContext context) {
    final media = _extractMedia(moods);

    return Scaffold(
      appBar: AppBar(title: const Text("Thư viện")),
      body: GridView.builder(
        padding: const EdgeInsets.all(2),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: media.length,
        itemBuilder: (context, index) {
          final item = media[index];
          return _buildMediaItem(context, item);
        },
      ),
    );
  }

  List<Map<String, dynamic>> _extractMedia(List<MoodModel> moods) {
    final List<Map<String, dynamic>> media = [];

    for (final mood in moods) {
      if (mood.image != null) {
        media.add({
          "type": "image",
          "path": mood.image,
          "date": mood.date,
        });
      }

      if (mood.video != null) {
        media.add({
          "type": "video",
          "path": mood.video,
          "date": mood.date,
        });
      }

      if (mood.audio != null) {
        media.add({
          "type": "audio",
          "path": mood.audio,
          "date": mood.date,
        });
      }
    }

    media.sort((a, b) => b["date"].compareTo(a["date"]));
    return media;
  }

  Future<Uint8List?> generateThumbnail(String videoPath) async {
    return await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 300,
      quality: 75,
    );
  }

  Widget _buildMediaItem(BuildContext context, Map<String, dynamic> item) {
    final type = item["type"];
    final path = item["path"];

    if (type == "image") {
      return FutureBuilder<String?>(
        future: resolveFilePath(path),
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
      );
    }

    if (type == "video") {
      return FutureBuilder<String?>(
        future: resolveFilePath(path),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox();
          }

          final videoPath = snapshot.data!;

          return FutureBuilder<Uint8List?>(
            future: generateThumbnail(videoPath),
            builder: (context, thumbSnapshot) {
              if (!thumbSnapshot.hasData) {
                return Container(color: Colors.black12);
              }

              return GestureDetector(
                onTap: (){
                  _showAudioPopup(context, VideoInput(initialVideoPath: snapshot.data!, onVideoPicked: (path){}, enableEdit: false,));
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.memory(
                      thumbSnapshot.data!,
                      fit: BoxFit.cover,
                    ),
                    const Center(
                      child: Icon(
                        Icons.play_circle_fill,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    if (type == "audio") {
      return FutureBuilder<String?>(
        future: resolveFilePath(path),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return Text("Có lỗi gì đó.");
          }

          return GestureDetector(
            onTap: (){
              _showAudioPopup(context, AudioRecorderWidget(initialAudioPath: snapshot.data, onAudioSaved: (path) {}, enableEdit: false,));
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.graphic_eq,
                      color: Colors.blue,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "AUDIO",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return const SizedBox();
  }
  void _showAudioPopup(BuildContext context, Widget widgetChild) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: widgetChild,
          ),
        );
      },
    );
  }
}