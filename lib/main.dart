import 'package:a_new_day/data/models/habit_model.dart';
import 'package:a_new_day/data/models/mood_model.dart';
import 'package:a_new_day/features/habit/screen/habit_add/habit_add_screen.dart';
import 'package:a_new_day/features/habit/screen/habit_detail/habit_detail_screen.dart';
import 'package:a_new_day/features/habit/screen/habit_detail/habit_status_detail_screen.dart';
import 'package:a_new_day/features/habit/screen/habit_home/habit_home_screen.dart';
import 'package:a_new_day/features/habit/screen/habit_list/habit_list_screen.dart';
import 'package:a_new_day/features/habit/screen/habit_list/habit_status_list_screen.dart';
import 'package:a_new_day/features/mood_journal/mood_list/mood_list_screen.dart';
import 'package:a_new_day/features/mood_journal/mood_view/mood_view_screen.dart';
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
  @override
  void initState() {
    super.initState();
    ref.read(emojisNotifierProvider);
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
            case 'habit-status-detail':
              final date = settings.arguments as DateTime;
              return MaterialPageRoute(builder: (_) => HabitStatusDetailScreen(date: date));
          }
      },
      home: HomeHabitScreen(),
    );
  }
}

