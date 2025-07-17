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
                leading: Icon(Icons.monetization_on),
                title: const Text('Nhật ký'),
                childrenPadding: EdgeInsets.only(left: 16),
                initiallyExpanded: true,
                children: [
                  ListTile(
                    leading: Icon(Icons.home),
                    title: const Text('Hôm nay'),
                    onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/mood-home', (router) => false),
                  ),
                  ListTile(
                    leading: const Icon(Icons.list),
                    title: const Text('Danh sách'),
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