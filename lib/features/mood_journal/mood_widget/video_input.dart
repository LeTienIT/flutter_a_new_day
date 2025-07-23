import 'dart:io';
import 'package:flutter/material.dart';
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
          videoWidget,
          if(widget.enableEdit)...[
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _pickVideo,
              icon: const Icon(Icons.video_library),
              label: const Text('Video đẹp nhất hôm nay'),
            ),
            const SizedBox(height: 10),
            if(_videoFile!=null)
              ElevatedButton.icon(
                onPressed: _videoFile!=null ? _deleteVideo : null,
                icon: const Icon(Icons.delete),
                label: const Text('Xóa video hiện tại'),
              )
          ],
        ],
      ),
    );
  }
}
