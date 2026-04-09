import 'package:a_new_day/features/dashboard/dashboard_provider.dart';
import 'package:a_new_day/features/dashboard/widget/habit_barChart.dart';
import 'package:a_new_day/features/dashboard/widget/habit_double_barChart.dart';
import 'package:a_new_day/features/dashboard/widget/mood_lineChart.dart';
import 'package:a_new_day/features/menu/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/app_security_storage.dart';
import '../../core/utils/tool.dart';
import '../security/authen_screen.dart';
import '../welcome/WelcomPopup.dart';

class DashboardScreen extends ConsumerStatefulWidget{
  const DashboardScreen({super.key});
  @override
  ConsumerState<DashboardScreen> createState() {
    return _DashboardScreen();
  }
}

class _DashboardScreen extends ConsumerState<DashboardScreen>{
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WelcomePopup.showIfFirstTime(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardProvider);
    final stateNotifier = ref.read(dashboardProvider.notifier);
    return SafeArea(
      top: false,
      child: Scaffold(
            appBar: AppBar(title: Text('Tổng quan'),),
            drawer: Drawer(child: Menu(),),
            body: state.when(
                data: (stats) {
                  final topUsed = stats.usageStats;
                  final best = stats.completionRates;
                  final doubleBarChart = stateNotifier.mergeUsageAndCompletion(topUsed, best).take(9).toList();
                  final moodListPoint = stats.moodEnergyPoint.reversed.toList();
                  final deleted = stats.deletedHabitTitles;
                  final daily = stats.daySummaries;

                  return Column(
                    children: [
                      const Divider(color: Colors.grey,),
                      const SizedBox(height: 10,),

                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Text('Nhật ký tâm trạng', style: Theme.of(context).textTheme.titleMedium),
                              MoodLineChart(data: moodListPoint),
                              const SizedBox(height: 16),
                              Text('Năng lượng mỗi ngày', style: Theme.of(context).textTheme.titleMedium),
                              HabitWeeklyBarChart(summaries: daily),
                              Text('(7 ngày gần nhất)', style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(height: 16),
                              Text('Top công việc', style: Theme.of(context).textTheme.titleMedium),

                              if (doubleBarChart.isNotEmpty) ...[
                                HabitDoubleBarChart(data: doubleBarChart),
                                const SizedBox(height: 16),
                              ],

                              if (deleted.isNotEmpty) ...[
                                Text('Các việc đã không còn thực hiện', style: Theme.of(context).textTheme.titleMedium),

                                const SizedBox(height: 8),
                                ...deleted.map((item) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.close, color: Colors.red, size: 16),
                                      const SizedBox(width: 8),
                                      Expanded(child: Text(item)),
                                    ],
                                  ),
                                )),
                                const SizedBox(height: 18),
                              ],
                            ],
                          ),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, -4),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async{
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
                                },
                                child: const Text("Nhật ký", textAlign: TextAlign.center,),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
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
                                child: const Text("Danh sách", textAlign: TextAlign.center,),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamedAndRemoveUntil(context, '/habit-home', (route) => false);
                                },
                                child: const Text("Hằng ngày", textAlign: TextAlign.center,),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                error: (error, _) => throw Exception(error),
                loading: () => const CircularProgressIndicator()
            )
        )
    );
  }
}