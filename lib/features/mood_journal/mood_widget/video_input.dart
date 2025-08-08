import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import '../../../core/utils/video_utils.dart';
import 'package:chewie/chewie.dart';

class VideoInput extends StatefulWidget {
  final void Function(String? path) onVideoPicked;
  String? initialVideoPath;
  bool enableEdit;
  VideoInput({super.key, required this.onVideoPicked, this.initialVideoPath, this.enableEdit = true});

  @override
  State<VideoInput> createState() => _VideoInputState();
}

class _VideoInputState extends State<VideoInput> {
  File? _videoFile;
  VideoPlayerController? _controller;
  final VideoUtils _videoUtil = VideoUtils();
  ChewieController? _chewieController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialVideoPath != null && widget.initialVideoPath!.isNotEmpty) {
      _videoFile = File(widget.initialVideoPath!);
      _initVideoController(_videoFile!);
    } else {
      _controller = null;
    }
  }

  Future<void> _initVideoController(File file) async {
    setState(() {
      _isLoading = true;
    });
    await _controller?.dispose();
    _chewieController?.dispose();

    final newController = VideoPlayerController.file(file);
    await newController.initialize();

    final newChewie = ChewieController(
      videoPlayerController: newController,
      autoPlay: false,
      looping: false,
    );

    setState(() {
      _controller = newController;
      _chewieController = newChewie;
      _isLoading = false;
    });
  }

  Future<void> _pickVideo() async {
    final file = await _videoUtil.pickVideoFromGallery();
    if (file == null) return;

    setState(() {
      _videoFile = file;
    });

    await _initVideoController(file);
    widget.onVideoPicked(file.path);
  }

  Future<void> _deleteVideo() async {
    _controller?.dispose();
    setState(() {
      _videoFile = null;
      _controller = null;
    });
    widget.onVideoPicked(null);
  }

  @override
  void dispose() {
    _controller?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<int> saveVideoToGallery(File videoFile) async {
    bool granted = false;

    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted) {
        granted = true;
      } else if (await Permission.photos.request().isGranted) {
        granted = true;
      } else if (await Permission.mediaLibrary.request().isGranted) {
        granted = true;
      }
    } else if (Platform.isIOS) {
      if (await Permission.photos.request().isGranted) {
        granted = true;
      }
    }

    if (!granted) return -1;

    final result = await ImageGallerySaverPlus.saveFile(
      videoFile.path,
      name: "saved_video_${DateTime.now().millisecondsSinceEpoch}",
    );

    if (result['isSuccess'] == true || (result['filePath'] != null && result['filePath'] != "")) {
      return 1;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget videoWidget;
    if (_isLoading) {
      videoWidget = const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (_controller != null &&
        _chewieController != null &&
        _controller!.value.isInitialized) {
      videoWidget = AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: Chewie(controller: _chewieController!),
      );
    } else {
      videoWidget = const Icon(Icons.videocam, size: 50);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              videoWidget,
              if (_videoFile != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(Icons.download, color: Colors.white),
                    onPressed: () async {
                      final status = await saveVideoToGallery(_videoFile!);
                      if (!mounted) return;
                      if (status == 1) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Đã lưu video vào thư viện')),
                        );
                      } else if (status == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Lưu video thất bại')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Chưa cấp quyền lưu video')),
                        );
                      }
                    },
                  ),
                ),
            ],
          ),
          if (widget.enableEdit) ...[
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _pickVideo,
              icon: const Icon(Icons.video_library),
              label: const Text('Video đẹp nhất hôm nay'),
            ),
            const SizedBox(height: 10),
            if (_videoFile != null)
              ElevatedButton.icon(
                onPressed: _deleteVideo,
                icon: const Icon(Icons.delete),
                label: const Text('Xóa video hiện tại'),
              )
          ],
        ],
      ),
    );
  }
}
