import 'package:a_new_day/core/utils/app_security_storage.dart';
import 'package:a_new_day/core/utils/tool.dart';
import 'package:a_new_day/data/models/habit_model.dart';
import 'package:a_new_day/data/models/mood_model.dart';
import 'package:a_new_day/features/backup/backup_screen.dart';
import 'package:a_new_day/features/dashboard/dashboard_screen.dart';
import 'package:a_new_day/features/habit/screen/habit_add/habit_add_screen.dart';
import 'package:a_new_day/features/habit/screen/habit_detail/habit_detail_screen.dart';
import 'package:a_new_day/features/habit/screen/habit_detail/habit_status_detail_screen.dart';
import 'package:a_new_day/features/habit/screen/habit_home/habit_home_screen.dart';
import 'package:a_new_day/features/habit/screen/habit_list/habit_list_screen.dart';
import 'package:a_new_day/features/habit/screen/habit_list/habit_status_list_screen.dart';
import 'package:a_new_day/features/menu/menu.dart';
import 'package:a_new_day/features/mood_journal/mood_list/mood_list_screen.dart';
import 'package:a_new_day/features/mood_journal/mood_view/mood_view_screen.dart';
import 'package:a_new_day/features/security/authen_screen.dart';
import 'package:a_new_day/features/security/security_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';
import 'features/mood_journal/emoji_repository.dart';
import 'features/mood_journal/mood_add/mood_add_screen.dart';
import 'features/mood_journal/mood_edit/mood_edit_screen.dart';
import 'features/mood_journal/mood_home/mood_home_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      ProviderScope(
          child: const MyApp()
      )
  );
}

class MyApp extends ConsumerStatefulWidget  {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();

}
class _MyAppState extends ConsumerState<MyApp> {
  bool _lockApp = true;

  @override
  void initState() {
    super.initState();
    ref.read(emojisNotifierProvider);
    _loadApp();
  }

  void _loadApp() async {
    final lockApp = await AppSecurityStorage.isAppLockEnabled();
    setState(() {
      _lockApp = lockApp;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Một ngày mới',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/mood-home':
              return MaterialPageRoute(builder: (_) => MoodHomeScreen());
            case '/mood-add':
              return MaterialPageRoute(builder: (_) => AddMoodScreen());
            case '/mood-list':
              return MaterialPageRoute(builder: (_) => MoodListScreen());
            case '/mood-edit':
              final mood = settings.arguments as MoodModel;
              return MaterialPageRoute(
                builder: (_) => MoodEditScreen(mood: mood),
              );
            case '/mood-view':
              final mood = settings.arguments as MoodModel;
              return MaterialPageRoute(
                builder: (_) => MoodViewScreen(mood: mood),
              );
            case '/habit-home':
              return MaterialPageRoute(builder: (_) => HomeHabitScreen());
            case '/habit-list':
              return MaterialPageRoute(builder: (_) => HabitListScreen());
            case '/habit-add':
              return MaterialPageRoute(builder: (_) => AddHabitScreen());
            case '/habit-edit':
              final h = settings.arguments as HabitModel;
              return MaterialPageRoute(
                builder: (_) => EditHabitScreen(h: h),
              );
            case '/habit-status-list':
              return MaterialPageRoute(builder: (_) => HabitStatusListScreen());
            case '/habit-status-detail':
              final date = settings.arguments as DateTime;
              return MaterialPageRoute(builder: (_) => HabitStatusDetailScreen(date: date));
            case '/security-screen':
              return MaterialPageRoute(builder: (_) => SecurityScreen());
            case '/dashboard-screen':
              return MaterialPageRoute(builder: (_) => DashboardScreen());
            case '/backup':
              return MaterialPageRoute(builder: (_) => BackupScreen());
            default:
              return MaterialPageRoute(builder: (_) => Scaffold(appBar: AppBar(title: Text('Lỗi')),drawer: Drawer(child: Menu(),),body: Center(child: Text('Không tìm thấy trang! Lỗi!'),),));
          }
      },
      home: _lockApp ? PinAuthScreen(type: AuthType.app, go: true,) : DashboardScreen(),
    );
  }
}

