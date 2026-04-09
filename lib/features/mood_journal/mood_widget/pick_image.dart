import 'dart:io';
import 'package:flutter/material.dart';

import '../../../core/utils/image_utils.dart';

class ImageInput extends StatefulWidget{
  final void Function(String? path) onIconPicked;
  final String? initialIconPath;

  const ImageInput({super.key, required this.onIconPicked, this.initialIconPath,});

  @override
  State<StatefulWidget> createState() {
    return _ImageInput();
  }

}

class _ImageInput extends State<ImageInput>{
  File? _iconFile;
  final ImageUtils _imageUtil = ImageUtils();

  @override
  void initState() {
    super.initState();
    if (widget.initialIconPath != null && widget.initialIconPath!.isNotEmpty) {
      _iconFile = File(widget.initialIconPath!);
    }
  }

  Future<void> _pickIcon() async {
    final file = await _imageUtil.pickImageFromGallery();
    if (file == null) return;

    setState(() {
      _iconFile = file;
    });

    widget.onIconPicked(file.path);
  }

  Future<void> _deleteVideo() async {
    setState(() {
      _iconFile = null;
    });
    widget.onIconPicked(null);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickIcon,
      child: AspectRatio(
        aspectRatio: 1, // vuông, bạn có thể đổi 16/9
        child: Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey.shade200,
          ),
          child: Stack(
            children: [
              /// IMAGE / PLACEHOLDER
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _iconFile != null
                      ? Image.file(
                    _iconFile!,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    color: Colors.grey.shade300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.image,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Chạm để chọn ảnh',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// OVERLAY nhẹ cho đẹp
              if (_iconFile == null)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.05),
                          Colors.black.withOpacity(0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

              /// DELETE BUTTON
              if (_iconFile != null)
                Positioned(
                  top: 8,
                  right: 8,
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
            ],
          ),
        ),
      ),
    );
  }
}