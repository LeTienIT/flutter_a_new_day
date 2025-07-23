import 'dart:io';
import 'package:a_new_day/core/utils/image_utils.dart';
import 'package:flutter/material.dart';

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
  final ImageUtils _imageService = ImageUtils();

  @override
  void initState() {
    super.initState();
    if (widget.initialIconPath != null && widget.initialIconPath!.isNotEmpty) {
      _iconFile = File(widget.initialIconPath!);
    }
  }

  Future<void> _pickIcon() async {
    final file = await _imageService.pickImageFromGallery();
    if (file == null) return;

    final isValid = await _imageService.isValidIcon(file);
    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ảnh không phù hợp làm icon. Vui lòng chọn ảnh khác')),
      );
      return;
    }

    setState(() {
      _iconFile = file;
    });

    widget.onIconPicked(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _iconFile != null
            ? CircleAvatar(backgroundImage: FileImage(_iconFile!), radius: 30,)
            : CircleAvatar(radius: 30, child: Icon(Icons.insert_emoticon_outlined),),
        ElevatedButton.icon(
          onPressed: _pickIcon,
          icon: const Icon(Icons.image),
          label: const Text('Chọn icon'),
        ),
      ],
    );
  }
}