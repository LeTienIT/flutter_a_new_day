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

class EditHabitScreen extends ConsumerStatefulWidget{
  final HabitModel h;
  const EditHabitScreen({super.key, required this.h});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _EditHabitScreen();
  }
}

class _EditHabitScreen extends ConsumerState<EditHabitScreen>{
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  List<int> _repeatDays = [];
  String? iconPath = '';

  @override
  void initState() {
    // print("habit edit: ${widget.h.toString()}");
    _name = TextEditingController(text: widget.h.name);
    iconPath = widget.h.icon ?? '';
    _repeatDays = widget.h.repeatDays;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thêm thói quen'),),
      drawer: Drawer(child: Menu(),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SessionTitle(title: 'Tên thói quen',subtitle: 'không được trùng',required: true,),
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
                initialIconPath: iconPath,
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
                      if(_name.text.trim().toLowerCase() != widget.h.name.trim().toLowerCase())
                      {
                          final isDuplicate = ref.read(habitListProvider.notifier).checkName(_name.text);
                          if (isDuplicate) {
                            await CustomDialog.showMessageDialog(
                                context: context,
                                title: 'Lỗi!',
                                message: 'Tên thói quen đã tồn tại. Hãy nhập thói quen khác'
                            );
                            return;
                          }
                      }
                      if(_repeatDays.isEmpty){
                        await CustomDialog.showMessageDialog(
                            context: context,
                            title: 'Lỗi!',
                            message: 'Chọn ít nhất 1 ngày thực hiện thói quen'
                        );
                        return;
                      }
                      HabitModel newH = HabitModel(
                          id: widget.h.id,
                          name: _name.text,
                          repeatDays: _repeatDays,
                          icon: iconPath,
                          createdAt: widget.h.createdAt
                      );
                      // print("habit: ${newH.toString()}");
                      await ref.read(habitListProvider.notifier).updateHabit(widget.h, newH);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã cập nhật')));
                    }
                  },
                  child: Text('Lưu thói quen')
              )
            ],
          ),
        ),
      ),
    );
  }

}