import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ImageUtils {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> isValidIcon(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded == null) return false;

      if (decoded.width < 48 || decoded.height < 48) {
        return false;
      }

      if (await file.length() > 1024 * 1024) {
        return false;
      }

      final ext = file.path.split('.').last.toLowerCase();
      if (!['jpg', 'jpeg', 'png', 'webp'].contains(ext)) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<File?> compressAndSaveIcon(File image, {String? fileName}) async {
    final dir = await getApplicationDocumentsDirectory();
    final targetPath = p.join(
      dir.path,
      fileName ?? 'image_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    final result = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      targetPath,
      quality: 100,
      format: CompressFormat.jpeg,
    );

    return result != null ? File(result.path) : null;
  }

  Future<String> getSavedIconPath(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, fileName);
  }

  Future<bool> deleteFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
