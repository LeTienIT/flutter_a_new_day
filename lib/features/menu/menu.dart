import 'package:a_new_day/core/utils/app_security_storage.dart';
import 'package:flutter/material.dart';
import '../../core/utils/tool.dart';
import '../security/authen_screen.dart';

class Menu extends StatefulWidget{
  const Menu({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Menu();
  }
}

class _Menu extends State<Menu>{
  String cache = '...';
  @override
  void initState() {
    super.initState();
    loadSizeCache();

  }
  void loadSizeCache() async{
    final sizeBytes = await getCacheSizeInBytes();
    final sizeReadable = formatBytes(sizeBytes);
    setState(() {
      cache = sizeReadable;
    });
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Tổng quát'),
          onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/dashboard-screen', (route) => false),
        ),
        ListTile(
            leading: Icon(Icons.today),
            title: const Text('Nhật ký hôm nay'),
            onTap: () async {
              final lockMood = await AppSecurityStorage.isMoodLockEnabled();
              if(lockMood && !AppSecurityStorage.hasUnlockedMoodOnce)
              {
                final unLocked = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(builder: (_) => PinAuthScreen(type: AuthType.mood)),
                );
                if(unLocked == true){
                  Navigator.pushNamedAndRemoveUntil(context, '/mood-home', (router) => false);
                }
              }
              else{
                Navigator.pushNamedAndRemoveUntil(context, '/mood-home', (router) => false);
              }
            }
        ),
        ListTile(
          leading: const Icon(Icons.task_rounded),
          title: const Text('Nhiệm vụ hôm nay'),
          onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/habit-home', (route) => false),
        ),
        Divider(height: 2,),
        ExpansionTile(
          leading: Icon(Icons.menu_book_outlined),
          title: const Text('Nhật ký'),
          childrenPadding: EdgeInsets.only(left: 16),
          initiallyExpanded: true,
          children: [
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Danh sách nhật ký'),
              onTap: () async{
                final lockMood = await AppSecurityStorage.isMoodLockEnabled();
                if(lockMood && !AppSecurityStorage.hasUnlockedMoodOnce)
                {
                  final unLocked = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(builder: (_) => PinAuthScreen(type: AuthType.mood)),
                  );
                  if(unLocked == true){
                    Navigator.pushNamedAndRemoveUntil(context, '/mood-list', (router) => false);
                  }
                }
                else{
                  Navigator.pushNamedAndRemoveUntil(context, '/mood-list', (router) => false);
                }
              },
            ),
          ],
        ),
        ExpansionTile(
          leading: Icon(Icons.sunny),
          title: const Text('Năng lượng mỗi ngày'),
          childrenPadding: EdgeInsets.only(left: 16),
          initiallyExpanded: true,
          children: [
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Danh sách nhiệm vụ'),
              onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/habit-list', (route) => false),
            ),
            ListTile(
              leading: Icon(Icons.list_alt_rounded),
              title: const Text('Danh sách ngày'),
              onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/habit-status-list', (router) => false),
            ),
          ],
        ),
        Divider(height: 2,),
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text('Cài đặt'),
          onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/setting', (route) => false),
        ),
        ListTile(
          leading: const Icon(Icons.backup_rounded),
          title: const Text('Sao chép - khôi phục dữ liệu'),
          onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/backup', (router)=>false),
        ),
        ListTile(
          leading: const Icon(Icons.cleaning_services_sharp),
          title: Text('Dọn dẹp bộ nhớ: $cache'),
          onTap: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Xác nhận'),
                content: const Text(
                  'Xác nhận dọn dẹp bộ nhớ tạm thời của ứng dụng.\n'
                      'Việc này không ảnh hưởng đến ứng dụng hiện tại\n'
                      'và các ứng dụng khác.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Hủy'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Xóa'),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              await cleanOnlyCache();
              loadSizeCache();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dọn dẹp thành công!')),
              );
            }
          },
        ),
      ],
    );
  }

}