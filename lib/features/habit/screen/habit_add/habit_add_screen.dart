import 'package:a_new_day/core/utils/show_dialog.dart';
import 'package:a_new_day/data/models/habit_model.dart';
import 'package:a_new_day/features/habit/widget/repeat_day_input.dart';
import 'package:a_new_day/features/menu/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/habit_list_controller.dart';
import '../../widget/icon_input.dart';
import '../../widget/sessionTitle.dart';
import '../../widget/textForm.dart';

class AddHabitScreen extends ConsumerStatefulWidget{
  const AddHabitScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AddHabitScreen();
  }
}

class _AddHabitScreen extends ConsumerState<AddHabitScreen>{
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  List<int> _repeatDays = [];
  String? iconPath = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thêm nhiệm vụ'),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SessionTitle(title: 'Tên nhiệm vụ',subtitle: 'không được trùng',required: true,),
                TextForm(category: _name, title: 'Tên', hint: 'VD: Thể dục'),
                
                SessionTitle(title: 'Các ngày cần thực hiện'),
                RepeatDaysSelector(
                  initialDays: _repeatDays,
                  onChanged: (newDays) {
                    setState(() {
                      _repeatDays = newDays;
                    });
                  },
                ),
                SessionTitle(title: 'Biểu tượng tùy chỉnh'),
                IconInput(
                  initialIconPath: '',
                  onIconPicked: (path) {
                    if(path!=null){
                      iconPath = path;
                    }
                  },
                ),

                Divider(thickness: 1,),
                FilledButton(
                    onPressed: () async {
                      if(_formKey.currentState!.validate()){
                        final isDuplicate = ref.read(habitListProvider.notifier).checkName(_name.text);
                        if (isDuplicate) {
                          await CustomDialog.showMessageDialog(
                              context: context,
                              title: 'Lỗi!',
                              message: 'Tên nhiệm vụ đã tồn tại. Hãy nhập tên khác'
                          );
                          return;
                        }
                        if(_repeatDays.isEmpty){
                          await CustomDialog.showMessageDialog(
                              context: context,
                              title: 'Lỗi!',
                              message: 'Chọn ít nhất 1 ngày thực hiện'
                          );
                          return;
                        }
                        HabitModel h = HabitModel(
                            name: _name.text,
                            repeatDays: _repeatDays,
                            icon: iconPath,
                            createdAt: DateTime.now()
                        );
                        await ref.read(habitListProvider.notifier).insertHabit(h);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã thêm')));
                      }
                    },
                    child: Text('Thêm')
                )
              ],
            ),
        ),
      ),
    );
  }

}