import 'package:a_new_day/core/utils/app_security_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/tool.dart';
import '../habit/screen/habit_home/habit_home_screen.dart';
import '../security/authen_screen.dart';

class Menu extends StatelessWidget{
  const Menu({super.key});
  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;

    return Column(
      children: [
        SizedBox(height: 10),
        Text(
          'Menu',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Expanded(
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.dashboard_outlined),
                title: const Text('Tổng quát'),
                onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/dashboard-screen', (route) => false),
              ),
              Divider(height: 2,),
              ExpansionTile(
                leading: Icon(Icons.menu_book_outlined),
                title: const Text('Nhật ký'),
                childrenPadding: EdgeInsets.only(left: 16),
                initiallyExpanded: true,
                children: [
                  ListTile(
                      leading: Icon(Icons.menu_book_rounded),
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
                leading: Icon(Icons.checklist_rtl_outlined),
                title: const Text('Năng lượng mỗi ngày'),
                childrenPadding: EdgeInsets.only(left: 16),
                initiallyExpanded: true,
                children: [
                  ListTile(
                    leading: const Icon(Icons.today),
                    title: const Text('Nhiệm vụ hôm nay'),
                    onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/habit-home', (route) => false),
                  ),
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
                leading: const Icon(Icons.security),
                title: const Text('Bảo mật'),
                onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/security-screen', (route) => false),
              ),
            ],
          ),
        ),
      ],
    );
  }

}