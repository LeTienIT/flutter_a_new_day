import 'dart:io';
import 'package:flutter/material.dart';

import '../../../core/utils/image_utils.dart';

class IconInput extends StatefulWidget{
  final void Function(String? path) onIconPicked;
  final String? initialIconPath;

  const IconInput({super.key, required this.onIconPicked, this.initialIconPath,});

  @override
  State<StatefulWidget> createState() {
    return _IconInput();
  }

}

class _IconInput extends State<IconInput>{
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

    // final isValid = await _imageUtil.isValidIcon(file);
    // if (!isValid) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Ảnh không phù hợp làm icon. Vui lòng chọn ảnh khác')),
    //   );
    //   return;
    // }

    setState(() {
      _iconFile = file;
    });

    widget.onIconPicked(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 10,
      children: [
        _iconFile != null
            ? Image.file(
          _iconFile!,
          fit: BoxFit.cover,
        )
            : Icon(Icons.photo),
        ElevatedButton.icon(
          onPressed: _pickIcon,
          icon: const Icon(Icons.image),
          label: const Text('Tấm ảnh đẹp nhất hôm nay'),
        ),
      ],
    );
  }
}