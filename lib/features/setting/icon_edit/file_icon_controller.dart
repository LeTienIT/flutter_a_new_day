import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../data/database/dao/file_icon_dao.dart';
import '../../../data/database/providers/database_providers.dart';
import 'icon_edit_state.dart';
import 'icon_editor_page.dart';
/// ===== CONTROLLER =====
///
final fileIconProvider = StateNotifierProvider.autoDispose<FileIconNotifier, FileIconState>((ref) {
  final dao = ref.watch(fileIconDaoProvider);
  return FileIconNotifier(dao);
});

class FileIconNotifier extends StateNotifier<FileIconState> {
  final FileIconDao dao;

  FileIconNotifier(this.dao) : super(const FileIconState());

  /// load data
  Future<void> load({bool isAll = false}) async {
    state = state.copyWith(isLoading: true);

    final dir = await getApplicationDocumentsDirectory();

    final data = isAll ? await dao.getByPage() : await dao.getByPage(state.selectedPage);

    final mapped = data.map((e) {
      return e.copyWith(
        path: "${dir.path}/${e.path}",
      );
    }).toList();

    state = state.copyWith(
      icons: mapped,
      isLoading: false,
    );
  }
  ///select page
  setPage(value) async{
    state = state.copyWith(
      selectedPage: value
    );
    await load();
  }

  /// update position (optimistic update)
  Future<void> updatePosition(int id, double x, double y) async {
    state = state.copyWith(
      icons: state.icons.map((e) {
        if (e.id == id) {
          return e.copyWith(posX: x, posY: y);
        }
        return e;
      }).toList(),
    );

    final ratioX = x / maxWidth;
    final ratioY = y / maxHeight;

    await dao.updatePosition(id, ratioX, ratioY);
  }

  /// update size
  Future<void> updateSize(int id, double w, double h) async {
    state = state.copyWith(
      icons: state.icons.map((e) {
        if (e.id == id) {
          return e.copyWith(width: w, height: h);
        }
        return e;
      }).toList(),
    );

    final ratioW = w / maxWidth;
    final ratioH = h / maxHeight;

    await dao.updateSize(id, ratioW, ratioH);
  }

  /// delete
  Future<void> delete(int id) async {
    final item = state.icons.firstWhere((e) => e.id == id);

    if (item.path.isNotEmpty) {
      final file = File(item.path);

      if (await file.exists()) {
        await file.delete();
      }
    }

    await dao.deleteById(id);

    state = state.copyWith(
      icons: state.icons.where((e) => e.id != id).toList(),
    );
    }

  ///Thêm sticker
  Future<void> pickAndInsertImages() async {
    final picker = ImagePicker();

    final List<XFile> images = await picker.pickMultiImage();

    if (images.isEmpty) return;

    final dir = await getApplicationDocumentsDirectory();

    final uuid = const Uuid();

    const defaultX = 100.0;
    const defaultY = 150.0;

    for (final image in images) {
      final ext = p.extension(image.path);
      final newName = "${uuid.v4()}$ext";
      final newPath = "${dir.path}/$newName";

      final file = File(image.path);
      await file.copy(newPath);

      await dao.insertIcon(
        path: newName,
        x: defaultX / maxWidth,
        y: defaultY / maxHeight,
        page: state.selectedPage,
      );
    }

    await load();
  }
}