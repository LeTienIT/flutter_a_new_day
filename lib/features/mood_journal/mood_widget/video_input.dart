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
    Widget videoContent;

    if (_isLoading) {
      videoContent = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_controller != null &&
        _chewieController != null &&
        _controller!.value.isInitialized) {
      videoContent = Chewie(controller: _chewieController!);
    } else {
      videoContent = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.videocam, size: 60, color: Colors.grey),
          SizedBox(height: 8),
          Text(
            'Chạm để chọn video',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: widget.enableEdit ? _pickVideo : null,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.black,
          ),
          child: Stack(
            children: [
              /// VIDEO / PLACEHOLDER
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: videoContent,
                ),
              ),

              /// OVERLAY nhẹ khi chưa có video
              if (_videoFile == null)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.black.withOpacity(0.4),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

              /// DELETE BUTTON
              if (_videoFile != null && widget.enableEdit)
                Positioned(
                  top: 33,
                  right: 13,
                  child: GestureDetector(
                    onTap: _deleteVideo,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),

              /// DOWNLOAD BUTTON (giữ logic cũ)
              if (_videoFile != null)
                Positioned(
                  top: 33,
                  left: 13,
                  child: GestureDetector(
                    onTap: () async {
                      final status = await saveVideoToGallery(_videoFile!);
                      if (!mounted) return;

                      String msg = '';
                      if (status == 1) {
                        msg = 'Đã lưu video vào thư viện';
                      } else if (status == 0) {
                        msg = 'Lưu video thất bại';
                      } else {
                        msg = 'Chưa cấp quyền';
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(msg)),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.download,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
