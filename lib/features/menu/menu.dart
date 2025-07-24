import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              ExpansionTile(
                leading: Icon(Icons.checklist_rtl_outlined),
                title: const Text('Thói quen mỗi ngày'),
                childrenPadding: EdgeInsets.only(left: 16),
                initiallyExpanded: true,
                children: [
                  ListTile(
                    leading: const Icon(Icons.today),
                    title: const Text('Hôm nay'),
                    onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/habit-home', (route) => false),
                  ),
                  ListTile(
                    leading: const Icon(Icons.list),
                    title: const Text('Danh sách thói quen'),
                    onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/habit-list', (route) => false),
                  ),
                  ListTile(
                    leading: Icon(Icons.list_alt_rounded),
                    title: const Text('Danh sách các ngày'),
                    onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/habit-status-list', (router) => false),
                  ),
                ],
              ),
              ExpansionTile(
                leading: Icon(Icons.menu_book_outlined),
                title: const Text('Nhật ký'),
                childrenPadding: EdgeInsets.only(left: 16),
                initiallyExpanded: true,
                children: [
                  ListTile(
                    leading: Icon(Icons.menu_book_rounded),
                    title: const Text('Nhật ký hôm nay'),
                    onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/mood-home', (router) => false),
                  ),
                  ListTile(
                    leading: const Icon(Icons.list),
                    title: const Text('Danh sách nhật ký'),
                    onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/mood-list', (route) => false),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

}