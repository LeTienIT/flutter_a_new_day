import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:image_picker/image_picker.dart';

class VideoUtils {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickVideoFromGallery() async {
    try {
      final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e) {
      return null;
    }
  }

  Future<File?> saveVideo(File video, {String? fileName}) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final savedPath = p.join(
        dir.path,
        fileName ?? 'video_${DateTime.now().millisecondsSinceEpoch}.mp4',
      );

      return await video.copy(savedPath);
    } catch (e) {
      return null;
    }
  }

  Future<String> getSavedVideoPath(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, fileName);
  }

  Future<bool> deleteVideo(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
