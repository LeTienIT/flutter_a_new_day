import 'dart:io';

import 'package:a_new_day/features/menu/menu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import '../../data/database/providers/database_providers.dart';
import 'backup_controller.dart';

class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() {
    return _BackupScreenState();
  }

}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  String selectedTab = 'backup'; // backup | restore
  bool isProcessing = false;
  String? fileBackup;
  File? selectedFile;

  void _onBackupPressed() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận sao lưu dữ liệu'),
        content: const Text(
          'Vui lòng không thoát hay tắt ứng dụng trong quá trình sao lưu.\n\n'
              '-  Khi file nặng > 1GB, quá trình lưu file có thể bị giật, lang, ...\n'
              '-  Trong quá trình đó, không được thoát hay tắt app. Sau khi lưu thành công, app sẽ trở về giao diện\n\n'
              'Bạn nên sử dụng tính năng dọn dẹp bộ nhớ sau khi tạo file backup.',
          style: TextStyle(
            color: Colors.red,
            fontStyle: FontStyle.italic,
            fontSize: 16
          ),

        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => isProcessing = true);

    try {
      final db = ref.read(appDatabaseProvider);
      await db.close();
      File zipFile = await createFullBackup(); // <- function bạn đã có
      await saveLargeBackup(zipFile);
      setState(() {
        fileBackup = 'Đã tạo file sao lưu';
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sao lưu thành công! ')),
      );
    } on PlatformException catch (e) {
      setState(() {
        fileBackup = '${e.message}';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi flatform: ${e.message}')),
      );
    } catch (e) {
      setState(() {
        fileBackup = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi sao lưu: $e')),
      );

    } finally {
      if (mounted) setState(() => isProcessing = false);
    }
  }

  Widget _buildBackupContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Tính năng sao lưu sẽ sao chép toàn bộ dữ liệu hiện tại của ứng dụng và lưu trữ.\n'
              'Bạn có thể sử dụng dữ liệu lưu trữ đó để khôi phục lại dữ liệu này trên một thiết bị khác '
              '(Khi bạn đổi máy mới).',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10,),
        RichText(
          text: TextSpan(
              text: 'Mô tả',style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text: '\n - Sao lưu: Sẽ sao chép toàn bộ dữ liệu thành file.zip => dùng cho khôi phục',
                    style: TextStyle(color: Colors.orange, fontStyle: FontStyle.italic, fontSize: 16)
                ),
                TextSpan(
                    text: '\n - Sao lưu đồng bộ: ....',
                    style: TextStyle(color: Colors.green, fontStyle: FontStyle.italic, fontSize: 16)
                ),
              ]
          ),
        ),
        const SizedBox(height: 10),
        Text(
            '(Chi tiết đọc bên mục khôi phục)',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic, fontSize: 12)
        ),
        const SizedBox(height: 20),
        Wrap(
          alignment: WrapAlignment.spaceAround,
          spacing: 10,
          children: [
            ElevatedButton.icon(
              onPressed: isProcessing ? null : _onBackupPressed,
              icon: const Icon(Icons.backup),
              label: isProcessing
                  ? const Text('Đang sao lưu...')
                  : const Text('sao lưu'),
            ),
            ElevatedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.lock),
              label: RichText(text: TextSpan(
                text: 'Đồng bộ',
                children: [
                  TextSpan(
                    text: '\n   (khóa)',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.red,

                    ),
                  )
                ]
              )),
            ),
          ],
        ),
        const SizedBox(height: 10,),
        if (fileBackup != null) ...[
          Text(
            fileBackup!,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ]

      ],
    );
  }

  Widget buildRestoreUI() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              text: 'Lưu ý',style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: '\n - Dữ liệu được khôi phục sẽ ghi đè lên dữ liệu hiện tại. '
                      '\n - Tức là các dữ liệu hiện tại của ứng dụng sẽ bị xóa bỏ và thay thế bằng dữ liệu được khôi phục',
                  style: TextStyle(color: Colors.redAccent, fontStyle: FontStyle.italic, fontSize: 16)
                ),
              ]
            ),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
                  text: 'Kiến nghị',style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: '\n - Sử dụng tính năng đồng bộ'
                          '\n - Đồng bộ là thêm toàn bộ các dữ liệu cũ và không xóa dữ liệu hiện tại',
                      style: TextStyle(color: Colors.green, fontStyle: FontStyle.italic, fontSize: 16)
                  ),
                  TextSpan(
                      text: '\n <=> Với các dữ liệu bị xung đột, bạn sẽ lựa chọn 2 cách giải quyết'
                          '\n - 1: Ghi đè lên dữ liệu hiện tại'
                          '\n - 2: Bỏ qua dữ liệu khôi phục và sử dụng dữ liệu hiện tại',
                      style: TextStyle(color: Colors.orangeAccent, fontStyle: FontStyle.italic, fontSize: 16)
                  ),
                ]
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.folder_open),
            label: const Text('Chọn file backup (.zip)'),
            onPressed: ()async{
              final result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['zip'],
              );
              if (result != null && result.files.single.path != null) {
                setState(() {
                  selectedFile = File(result.files.single.path!);
                });
              }
            },
          ),
          const SizedBox(height: 16),
          if (selectedFile != null)
            Text(
              'Đã chọn: ${p.basename(selectedFile!.path)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          else
            const Text('Chưa chọn file nào'),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.restore),
                label: const Text('Khôi phục'),
                onPressed: selectedFile == null ? null : () async{
                  if (selectedFile == null) return;

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(child: CircularProgressIndicator()),
                  );

                  final success = await restoreBackup(selectedFile!);

                  Navigator.pop(context); // tắt loading

                  if (success) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => AlertDialog(
                        title: const Text('Khôi phục thành công'),
                        content: const Text('App sẽ khởi động lại để áp dụng dữ liệu mới.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              if (Platform.isAndroid) {
                                SystemNavigator.pop();
                              } else if (Platform.isIOS) {
                                exit(0);
                              }
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('❌ Khôi phục thất bại')),
                    );
                  }
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.lock),
                label: RichText(text: TextSpan(
                    text: 'Đồng bộ',
                    children: [
                      TextSpan(
                        text: '\n   (khóa)',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.red,

                        ),
                      )
                    ]
                )),
                onPressed: null,
              ),
            ],
          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sao lưu & khôi phục')),
      drawer: const Drawer(child: Menu()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  avatar: Icon(Icons.restore_outlined),
                  label: const Text('Sao lưu'),
                  selected: selectedTab == 'backup',
                  onSelected: (_) => setState(() => selectedTab = 'backup'),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  avatar: Icon(Icons.cloud_sync_sharp),
                  label: const Text('Khôi phục'),
                  selected: selectedTab == 'restore',
                  onSelected: (_) => setState(() => selectedTab = 'restore'),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Nội dung
            if (selectedTab == 'backup')
              _buildBackupContent()
            else
              buildRestoreUI(),
          ],
        ),
      ),
    );
  }
}
