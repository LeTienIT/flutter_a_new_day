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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _iconFile != null
              ? Image.file(
            _iconFile!,
            fit: BoxFit.cover,
            width: 200, // Bạn có thể thêm width cố định nếu cần
          )
              : const Icon(Icons.photo, size: 50),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _pickIcon,
            icon: const Icon(Icons.image),
            label: const Text('Tấm ảnh đẹp nhất hôm nay'),
          ),
          SizedBox(height: 10,),
          if(_iconFile!=null)
            ElevatedButton.icon(
              onPressed: _iconFile!=null ? _deleteVideo : null,
              icon: const Icon(Icons.delete),
              label: const Text('Xóa ảnh hiện tại'),
            ),
        ],
      ),
    );
  }
}