import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(fileIconProvider.notifier).load();
    });
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
        body: SingleChildScrollView(
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
              const Text("Di chuyển, phóng to/thu nhỏ, ấn giữ để xoá",style: TextStyle(color: Colors.redAccent),),
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
                            onDelete: () async {
                              ref.read(fileIconProvider.notifier).delete(icon.id);
                            },
                          )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10,bottom: 10),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await ref.read(fileIconProvider.notifier).pickAndInsertImages();
                  },
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text("Thêm sticker"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              _buildColorSettings(context, ref, gradientAsync, textColorAsync, textColor),
              if(state.selectedPage==2)CoverTextEditor(),

            ],
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
  final VoidCallback? onDelete;

  const _DraggableItem({
    super.key,
    required this.icon,
    required this.onMove,
    required this.onResize,
    this.onDelete,
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


  @override
  void initState() {
    super.initState();
    x = widget.icon.posX * maxWidth;
    y = widget.icon.posY * maxHeight;
    w = widget.icon.width * maxWidth;
    h = widget.icon.height * maxHeight;
  }


  @override
  Widget build(BuildContext context) {

    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onScaleStart: (details) {
          baseWidth = w;
          baseHeight = h;
        },
        onLongPress: () async{
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

            x = x.clamp(0, maxWidth - w);
            y = y.clamp(0, maxHeight - h);
          });

          if (widget.icon.id > 0) {
            widget.onMove(x, y);
            widget.onResize(w, h);
          }
        },

        child: SizedBox(
          width: w,
          height: h,
          child: Image.asset(
            widget.icon.path,
            fit: BoxFit.contain,
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