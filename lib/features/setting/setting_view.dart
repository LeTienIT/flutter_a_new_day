import 'package:a_new_day/features/menu/menu.dart';
import 'package:a_new_day/features/security/security_screen.dart';
import 'package:a_new_day/features/setting/icon_edit/icon_editor_page.dart';
import 'package:a_new_day/features/setting/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/const/setting_const.dart';
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initAsync = ref.watch(settingsInitProvider);
    final showCompletedAsync = ref.watch(showCompletedProvider);
    final darkModeAsync = ref.watch(darkModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      drawer: Drawer(
        child: Menu(),
      ),
      body: initAsync.isLoading ? const Center(child: CircularProgressIndicator())
          : initAsync.hasError ? Center(child: Text('Error: ${initAsync.error}'))
          : ListView(
            children: [
              darkModeAsync.when(
                loading: () => const SizedBox(),
                error: (e, _) => Text('Error: $e'),
                data: (isDark) {
                  return SwitchListTile(
                    title: const Text('Chế độ nền tối'),
                    value: isDark,
                    onChanged: (newValue) async {
                      final controller = ref.read(settingsControllerProvider);
                      await controller.setBool(
                        SettingKeys.darkMode,
                        newValue,
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 10,),
              showCompletedAsync.when(
                loading: () => const SizedBox(),
                error: (e, _) => Text('Error: $e'),
                data: (value) {
                  return SwitchListTile(
                    title: const Text('Hiển thị việc đã không còn thực hiện'),
                    subtitle: const Text("Danh sách trong trang tổng quát"),
                    value: value,
                    onChanged: (newValue) async {
                      final controller = ref.read(settingsControllerProvider);
                      await controller.setBool(
                        SettingKeys.showCompleted,
                        newValue,
                      );
                    },
                  );
                },
              ),
              const Divider(),

              ListTile(
                leading: const Icon(Icons.security),
                title: const Text('Thiết lập bảo mật'),
                subtitle: const Text("Bật/Tắt chức năng bảo mật"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SecurityScreen(),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.mood),
                title: const Text('Thiết lập nhật ký'),
                subtitle: const Text("Chỉnh sửa các sticker, trang sách"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IconEditorPage(),
                    ),
                  );
                },
              ),
            ],
          ),
    );
  }
}