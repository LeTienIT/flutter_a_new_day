import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/const/setting_const.dart';
import '../../../data/database/app_database.dart';
import '../setting_controller.dart';
import 'file_icon_controller.dart';

const double maxWidth = 350;
const double maxHeight = 550;

class IconEditorPage extends ConsumerStatefulWidget {
  const IconEditorPage({super.key});

  @override
  ConsumerState<IconEditorPage> createState() => _IconEditorPageState();
}

class _IconEditorPageState extends ConsumerState<IconEditorPage> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isInteracting = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(fileIconProvider.notifier).load();
    });
  }

  @override
  void dispose(){
    super.dispose();
    _hideOverlay();
  }
  void _showOverlay(BuildContext context, WidgetRef ref) {
    final overlay = Overlay.of(context);

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    final screenHeight = MediaQuery.of(context).size.height;

    final showAbove = position.dy + size.height + 200 > screenHeight;

    final offset = showAbove
        ? const Offset(0, -120)
        : const Offset(0, 50);  // hi

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: 220,
          child: CompositedTransformFollower(
            link: _layerLink,
            offset: offset,
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.emoji_emotions),
                    title: const Text("Chọn từ hệ thống"),
                    onTap: () async {
                      _hideOverlay();
                      _showStickerPicker(context, ref);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text("Chọn từ thư viện"),
                    onTap: () async {
                      _hideOverlay();
                      await ref.read(fileIconProvider.notifier).pickAndInsertImages();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Future<List<String>> loadStickerAssets() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);

    return manifest.listAssets().where((e) => e.startsWith('assets/sticker/') &&
        (e.endsWith('.png') || e.endsWith('.jpg') || e.endsWith('.jpeg'))).toList();
  }
  void _showStickerPicker(BuildContext context, WidgetRef ref) async {
    final stickers = await loadStickerAssets();
    final selected = <String>{};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: 400,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text("Chọn sticker"),
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                      ),
                      itemCount: stickers.length,
                      itemBuilder: (_, index) {
                        final path = stickers[index];
                        final isSelected = selected.contains(path);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selected.remove(path);
                              } else {
                                selected.add(path);
                              }
                            });
                          },
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6),
                                child: Image.asset(path),
                              ),
                              if (isSelected)
                                const Positioned(
                                  right: 4,
                                  top: 4,
                                  child: Icon(Icons.check_circle,
                                      color: Colors.green),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await ref.read(fileIconProvider.notifier).insertFromAssets(selected.toList());
                    },
                    child: const Text("Xong"),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fileIconProvider);
    final notifier = ref.watch(fileIconProvider.notifier);

    final gradientAsync = ref.watch(coverGradientProvider);

    final textColorAsync = ref.watch(coverTextColorProvider);
    final textColor = textColorAsync.value ?? Colors.black;

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chỉnh sửa nhật ký'),
        ),
        body: GestureDetector(
          onTap: (){
            _hideOverlay();
          },
          child: SingleChildScrollView(
            physics: _isInteracting ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text('Trang bìa'),
                      selected: state.selectedPage == 1,
                      onSelected: (_) {
                        notifier.setPage(1);
                      },
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text('Trang cuối'),
                      selected: state.selectedPage == 2,
                      onSelected: (_) {
                        notifier.setPage(2);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 5,),
                const Text("Di chuyển, phóng to/thu nhỏ, xoay, ấn liên tiếp để xoá",style: TextStyle(color: Colors.redAccent),),
                const Text("Nên dùng các ảnh không có nền",style: TextStyle(color: Colors.green),),
                Center(
                  child: Container(
                    width: maxWidth,
                    height: maxHeight,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: state.isLoading ? const Center(child: CircularProgressIndicator()) : Stack(
                        children: [
                          state.selectedPage==1 ?_buildPreviewBackground(ref, gradientAsync, textColor) : _buildPreviewCoverPage(ref, textColor),

                          for (final icon in state.icons)
                            _DraggableItem(
                              key: ValueKey(icon.id),
                              icon: icon,
                              onMove: (x, y) async {
                                ref.read(fileIconProvider.notifier).updatePosition(icon.id, x, y);
                              },
                              onResize: (w, h) async {
                                ref.read(fileIconProvider.notifier).updateSize(icon.id, w, h);
                              },
                              onRotation: (r) async {
                                ref.read(fileIconProvider.notifier).updateRotation(icon.id, r);
                              },
                              onDelete: () async {
                                ref.read(fileIconProvider.notifier).delete(icon.id);
                              },
                              onInteractionStart: () {
                                setState(() => _isInteracting = true);
                              },
                              onInteractionEnd: () {
                                setState(() => _isInteracting = false);
                              },
                            )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: CompositedTransformTarget(
                    link: _layerLink,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_overlayEntry == null) {
                          _showOverlay(context, ref);
                        } else {
                          _hideOverlay();
                        }
                      },
                      icon: const Icon(Icons.add, size: 14),
                      label: const Text("Thêm sticker"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ),
                _buildColorSettings(context, ref, gradientAsync, textColorAsync, textColor),
                if(state.selectedPage==2)CoverTextEditor(),
                SizedBox(height: 40,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewBackground(WidgetRef ref, gradientAsync, textColor) {
    final gradient = gradientAsync.value ?? const LinearGradient(colors: [Color(0xFFd7ccc8), Color(0xFFa1887f)],);

    return Positioned.fill(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: gradient,
          border: const Border(
            right: BorderSide(color: Color(0xFFD6C6B5), width: 6),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withValues(alpha: 0.15),
              offset: const Offset(2, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Thứ năm, ngày 28 tháng 2 năm 2002",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor
                  ),
                ),

                const SizedBox(height: 30),

                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 14,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Image.asset(
                      'assets/emoji_default/happy.png',
                      width: 60,
                      height: 60,
                    ),
                    Text(
                      "Hôm nay thật vui 🌿",
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Positioned(
              right: 0,
              bottom: -10,
              child: Image.asset(
                'assets/emoji_default/arrow.png',
                width: 80,
                height: 20,
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      )
    );
  }
  Widget _buildPreviewCoverPage(WidgetRef ref, textColor) {
    final titleAsync = ref.watch(coverTitleProvider);
    final subAsync = ref.watch(coverSubtitleProvider);
    final gradientAsync = ref.watch(coverGradientProvider);

    final gradient = gradientAsync.value ?? const LinearGradient(colors: [Color(0xFFd7ccc8), Color(0xFFa1887f)],);

    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
        ),
        child: Stack(
          children: [
            Center(
              child: titleAsync.when(
                data: (title) => Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 3,
                        color: Colors.black26,
                      )
                    ],
                  ),
                ),
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 16,
              right: 16,
              child: subAsync.when(
                data: (text) => Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: textColor,
                  ),
                ),
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSettings(BuildContext context, WidgetRef ref, gradientAsync, colorAsync, current) {
    final gradient = gradientAsync.value ??
        const LinearGradient(colors: [Color(0xFFd7ccc8), Color(0xFFa1887f)]);
    final startColor = gradient.colors.first;
    final endColor = gradient.colors.last;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Box 1 — Màu chữ
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Màu chữ bìa",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey)),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    final picked = await pickColor(context, current);
                    if (picked == null) return;
                    await ref.read(settingsControllerProvider).setColor(SettingKeys.coverTextColor, picked);
                  },
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: current,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Icon(Icons.text_fields, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Box 2 — Gradient
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Dải màu nền",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final picked = await pickColor(context, startColor);
                        if (picked == null) return;
                        await ref.read(settingsControllerProvider).setGradient(picked, endColor);
                      },
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: startColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Icon(Icons.bubble_chart, size: 18),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () async {
                        final picked = await pickColor(context, endColor);
                        if (picked == null) return;
                        await ref.read(settingsControllerProvider).setGradient(startColor, picked);
                      },
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: endColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Icon(Icons.bubble_chart, size: 18),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: gradient,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Future<Color?> pickColor(BuildContext context, Color current) {
    Color temp = current;

    return showDialog<Color>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Chọn màu"),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: current,
            onColorChanged: (c) => temp = c,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Huỷ"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, temp),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
class _DraggableItem extends StatefulWidget {
  final FileIcon icon;
  final Function(double x, double y) onMove;
  final Function(double w, double h) onResize;
  final Function(double r) onRotation;
  final VoidCallback? onDelete;
  final VoidCallback? onInteractionStart;
  final VoidCallback? onInteractionEnd;

  const _DraggableItem({
    super.key,
    required this.icon,
    required this.onMove,
    required this.onResize,
    required this.onRotation,
    this.onDelete,
    this.onInteractionEnd,
    this.onInteractionStart
  });

  @override
  State<_DraggableItem> createState() => _DraggableItemState();
}
class _DraggableItemState extends State<_DraggableItem> {
  late double x;
  late double y;
  late double w;
  late double h;

  double baseWidth = 0;
  double baseHeight = 0;

  double rotation = 0;
  double baseRotation = 0;
  @override
  void initState() {
    super.initState();
    x = widget.icon.posX * maxWidth;
    y = widget.icon.posY * maxHeight;
    w = widget.icon.width * maxWidth;
    h = widget.icon.height * maxHeight;
    rotation = widget.icon.rotation;
  }


  @override
  Widget build(BuildContext context) {

    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onTapDown: (_) {
          HapticFeedback.vibrate();
        },

        onScaleStart: (details) {
          HapticFeedback.vibrate();
          baseWidth = w;
          baseHeight = h;

          baseRotation = rotation;

          widget.onInteractionStart?.call();
        },
        onScaleEnd: (details) {
          widget.onInteractionEnd?.call();
        },
        onDoubleTap: () async{
          HapticFeedback.vibrate();
          widget.onInteractionEnd?.call();
          final confirm = await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Xóa sticker'),
              content: const Text('Bạn có chắc muốn xóa không?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Huỷ'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Xóa'),
                ),
              ],
            ),
          );

          if (confirm == true) {
            widget.onDelete?.call();
          }
        },

        onScaleUpdate: (details) {
          setState(() {
            x += details.focalPointDelta.dx;
            y += details.focalPointDelta.dy;

            w = (baseWidth * details.scale).clamp(40, 200);
            h = (baseHeight * details.scale).clamp(40, 200);

            rotation = baseRotation + details.rotation;

            x = x.clamp(0, maxWidth - w);
            y = y.clamp(0, maxHeight - h);
          });

          if (widget.icon.id > 0) {
            widget.onMove(x, y);
            widget.onResize(w, h);
            widget.onRotation(rotation);
          }
        },

        onTapCancel: (){
          widget.onInteractionEnd?.call();
        },

        child: SizedBox(
          width: w,
          height: h,
          child: Transform.rotate(
            angle: rotation,
            child: SizedBox(
              width: w,
              height: h,
              child: Image.file(
                File(widget.icon.path),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CoverTextEditor extends ConsumerStatefulWidget {
  const CoverTextEditor({super.key});
  @override
  ConsumerState<CoverTextEditor> createState() => _CoverTextEditorState();
}
class _CoverTextEditorState extends ConsumerState<CoverTextEditor> {
  final titleCtrl = TextEditingController();
  final subCtrl = TextEditingController();
  bool _inited = false;
  @override
  Widget build(BuildContext context) {
    final titleAsync = ref.watch(coverTitleProvider);
    final subAsync = ref.watch(coverSubtitleProvider);
    titleAsync.whenData((value) {
      if (!_inited) titleCtrl.text = value;
    });

    subAsync.whenData((value) {
      if (!_inited) {
        subCtrl.text = value;
        _inited = true;
      }
    });

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          TextField(
            controller: titleCtrl,
            decoration: const InputDecoration(
              labelText: "Tiêu đề",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              ref.read(settingsControllerProvider).setString(SettingKeys.coverTitle, value);
            },
          ),

          const SizedBox(height: 12),

          TextField(
            controller: subCtrl,
            decoration: const InputDecoration(
              labelText: "Mô tả",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              ref.read(settingsControllerProvider).setString(SettingKeys.coverSubtitle, value);
            },
          ),
        ],
      ),
    );
  }
}