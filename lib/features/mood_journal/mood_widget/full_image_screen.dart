import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class FullScreenImagePage extends StatefulWidget {
  final String imagePath;

  const FullScreenImagePage({super.key, required this.imagePath});

  @override
  State<FullScreenImagePage> createState() => _FullScreenImagePageState();
}

class _FullScreenImagePageState extends State<FullScreenImagePage> {
  bool _isSaving = false;

  Future<void> _onDownloadPressed() async {
    setState(() {
      _isSaving = true;
    });

    int status = await saveImageToGallery(File(widget.imagePath));

    setState(() {
      _isSaving = false;
    });

    if (!mounted) return;

    if (status == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã lưu ảnh vào thư viện ảnh')),
      );
    } else if (status == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lưu ảnh thất bại')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Chưa được cấp quyền lưu ảnh')),
      );
    }
  }

  Future<int> saveImageToGallery(File imageFile) async {
    bool granted = false;

    if (Platform.isAndroid) {
      if (await Permission.photos.request().isGranted) {
        granted = true;
      } else if (await Permission.mediaLibrary.request().isGranted) {
        granted = true;
      } else if (await Permission.storage.request().isGranted) {
        granted = true;
      }
    } else if (Platform.isIOS) {
      if (await Permission.photos.request().isGranted) {
        granted = true;
      }
    }

    if (granted) {
      final result = await ImageGallerySaverPlus.saveFile(
        imageFile.path,
        name: "edited_image_${DateTime.now().millisecondsSinceEpoch}",
      );

      if (result['isSuccess'] == true || (result['filePath'] != null && result['filePath'] != "")) {
        return 1;
      } else {
        return 0;
      }
    } else {
      return -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ảnh full màn hình'),
        actions: [
          IconButton(
            icon: _isSaving ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
                : Icon(Icons.download),
            onPressed: _isSaving ? null : _onDownloadPressed,
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          boundaryMargin: EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 4,
          child: Image.file(
            File(widget.imagePath),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
