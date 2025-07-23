import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/database/dao/habit_dao.dart';
import '../../provider/habit_list_controller.dart';

class HomeHabitScreen extends ConsumerStatefulWidget{
  const HomeHabitScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomeHabitScreen();
  }
}
class _HomeHabitScreen extends ConsumerState<HomeHabitScreen>{
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(habitListProvider);
    final controller = ref.watch(habitListProvider.notifier);

    throw UnimplementedError();
  }

}