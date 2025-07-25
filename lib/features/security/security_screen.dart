import 'package:a_new_day/core/utils/app_security_storage.dart';
import 'package:a_new_day/core/utils/show_dialog.dart';
import 'package:a_new_day/features/menu/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/utils/tool.dart';
import 'authen_screen.dart';

class SecurityScreen extends StatefulWidget{
  const SecurityScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SecurityScreen();
  }

}

class _SecurityScreen extends State<SecurityScreen>{
  final securityApp = AppSecurityStorage.isAppLockEnabled();
  late bool _lockApp = false;
  late bool _lockMood = false;
  final _formKey = GlobalKey<FormState>();
  final _passController = TextEditingController();
  final _question1Controller = TextEditingController();
  final _answer1Controller = TextEditingController();
  final _question2Controller = TextEditingController();
  final _answer2Controller = TextEditingController();

  final _formKeyM = GlobalKey<FormState>();
  final _passControllerM = TextEditingController();
  final _question1ControllerM = TextEditingController();
  final _answer1ControllerM = TextEditingController();
  final _question2ControllerM = TextEditingController();
  final _answer2ControllerM = TextEditingController();

  final _formKeyReset = GlobalKey<FormState>();
  final _passControllerReset = TextEditingController();
  final _passControllerMoodReset = TextEditingController();

  bool _showForm = false;
  bool _showFormMood = false;
  bool _showFormReset = false;

  @override
  void initState(){
    super.initState();
    _loadLockStatus();
  }

  Future<void> _loadLockStatus() async {
    final locked = await AppSecurityStorage.isAppLockEnabled();
    final lockMood = await AppSecurityStorage.isMoodLockEnabled();
    setState(() {
      _lockApp = locked;
      _lockMood = lockMood;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thiết lập bảo mật')),
      drawer: Drawer(child: Menu(),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 28),
              child: SwitchListTile(
                  title: Text('Bảo mật ứng dụng',),
                  value: _lockApp,
                  onChanged: (bool value) async {
                    if(value){
                      setState(() {
                        _showForm = true;
                      });
                    }
                    else{
                      final unLocked = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(builder: (_) => PinAuthScreen(type: AuthType.app,go: false,)),
                      );
                      if(unLocked == true){
                        final comfirm = await CustomDialog.showConfirmDialog(
                            context: context,
                            title: 'Xác nhận',
                            message: 'Tắt bảo mật ứng dụng\n\n- Bỏ mật mã khi mở app'
                        );
                        if(comfirm){
                          AppSecurityStorage.setAppLockEnabled(false);
                          setState(() {
                            _lockApp = value;
                          });
                        }
                      }
                    }
                  },
                  activeColor: Theme.of(context).colorScheme.primary,
                  inactiveTrackColor: Theme.of(context).colorScheme.surfaceContainerHighest
              ),
            ),

            if (_showForm) Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
              child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _passController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Mã bảo mật',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value){
                          if(value?.trim().isEmpty == true){
                            return "Yêu cầu Passcode";
                          }
                          else if(value!.length < 6){
                            return "Yêu cầu tối thiểu 6 số";
                          }
                          return null;
                        },
                    ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _question1Controller,
                        decoration: InputDecoration(labelText: 'Câu hỏi bảo mật 1'),
                        validator: (value){
                          if(value?.trim().isEmpty == true){
                            return "Bắt buộc nhập";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _answer1Controller,
                        decoration: InputDecoration(labelText: 'Câu trả lời 1'),
                        validator: (value){
                          if(value?.trim().isEmpty == true){
                            return "Bắt buộc nhập";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _question2Controller,
                        decoration: InputDecoration(labelText: 'Câu hỏi bảo mật 2'),
                        validator: (value){
                          if(value?.trim().isEmpty == true){
                            return "Bắt buộc nhập";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _answer2Controller,
                        decoration: InputDecoration(labelText: 'Câu trả lời 2'),
                        validator: (value){
                          if(value?.trim().isEmpty == true){
                            return "Bắt buộc nhập";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Divider(height: 2,),
                      Wrap(
                        spacing: 10,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if(_formKey.currentState!.validate()){
                                final pass = _passController.text.trim();
                                final q1 = _question1Controller.text.trim();
                                final a1 = _answer1Controller.text.trim();
                                final q2 = _question2Controller.text.trim();
                                final a2 = _answer2Controller.text.trim();

                                await AppSecurityStorage.setAppLockEnabled(true);
                                await AppSecurityStorage.savePin(pass);
                                await AppSecurityStorage.saveSecurityQuestions(q1, a1, q2, a2);

                                setState(() {
                                  _lockApp = true;
                                  _showForm = false;
                                });
                                CustomDialog.showMessageDialog(
                                    context: context,
                                    title: 'Thành công',
                                    message: 'Bảo mật đã được bật');
                              }
                            },
                            child: Text('Xác nhận'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _lockApp = false;
                                _showForm = false;
                              });
                            },
                            child: Text('Hủy'),
                          ),
                        ],
                      )
                    ],
                  )
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 28),
              child: SwitchListTile(
                  title: Text('Bảo mật nhật ký',),
                  value: _lockMood,
                  onChanged: (bool value) async {
                    if(value){
                      setState(() {
                        _showFormMood = true;
                      });
                    }
                    else{
                      final unLocked = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(builder: (_) => PinAuthScreen(type: AuthType.mood)),
                      );
                      if(unLocked == true){
                        final comfirm = await CustomDialog.showConfirmDialog(
                            context: context,
                            title: 'Xác nhận',
                            message: 'Tắt bảo mật nhật ký\n\n- Bỏ mật mã khi truy cập nhật ký'
                        );
                        if(comfirm){
                          AppSecurityStorage.setMoodLockEnabled(false);
                          setState(() {
                            _lockMood = value;
                          });
                        }
                      }
                    }
                  },
                  activeColor: Theme.of(context).colorScheme.primary,
                  inactiveTrackColor: Theme.of(context).colorScheme.surfaceContainerHighest
              ),
            ),

            if (_showFormMood) Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                child: Form(
                    key: _formKeyM,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _passControllerM,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Mã bảo mật',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value){
                            if(value?.trim().isEmpty == true){
                              return "Yêu cầu Passcode";
                            }
                            else if(value!.length < 6){
                              return "Yêu cầu tối thiểu 6 số";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _question1ControllerM,
                          decoration: InputDecoration(labelText: 'Câu hỏi bảo mật 1'),
                          validator: (value){
                            if(value?.trim().isEmpty == true){
                              return "Bắt buộc nhập";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _answer1ControllerM,
                          decoration: InputDecoration(labelText: 'Câu trả lời 1'),
                          validator: (value){
                            if(value?.trim().isEmpty == true){
                              return "Bắt buộc nhập";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _question2ControllerM,
                          decoration: InputDecoration(labelText: 'Câu hỏi bảo mật 2'),
                          validator: (value){
                            if(value?.trim().isEmpty == true){
                              return "Bắt buộc nhập";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _answer2ControllerM,
                          decoration: InputDecoration(labelText: 'Câu trả lời 2'),
                          validator: (value){
                            if(value?.trim().isEmpty == true){
                              return "Bắt buộc nhập";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        Divider(height: 2,),
                        Wrap(
                          spacing: 10,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                if(_formKeyM.currentState!.validate()){
                                  final pass = _passControllerM.text.trim();
                                  final q1 = _question1ControllerM.text.trim();
                                  final a1 = _answer1ControllerM.text.trim();
                                  final q2 = _question2ControllerM.text.trim();
                                  final a2 = _answer2ControllerM.text.trim();

                                  await AppSecurityStorage.setMoodLockEnabled(true);
                                  await AppSecurityStorage.savePinM(pass);
                                  await AppSecurityStorage.saveSecurityQuestionsM(q1, a1, q2, a2);

                                  setState(() {
                                    _lockMood = true;
                                    _showFormMood = false;
                                  });
                                  CustomDialog.showMessageDialog(
                                      context: context,
                                      title: 'Thành công',
                                      message: 'Bảo mật đã được bật');
                                }
                              },
                              child: Text('Xác nhận'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _lockMood = false;
                                  _showFormMood = false;
                                });
                              },
                              child: Text('Hủy'),
                            ),
                          ],
                        )
                      ],
                    )
                ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 28),
              child: ElevatedButton(
                  onPressed: (_lockApp || _lockMood) ? ()async{
                    if(_lockApp || _lockMood){
                      setState(() {
                        _showFormReset = true;
                      });

                    }
                  } : null,
                  child: Text('Xóa bảo mật')
              ),
            ),

            if (_showFormReset) Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
              child: Form(
                  key: _formKeyReset,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _passControllerReset,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Mã bảo mật ỨNG DỤNG',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value){
                          if(value?.trim().isEmpty == true){
                            return "Yêu cầu mật mã";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _passControllerMoodReset,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Mã bảo mật NHẬT KÝ',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value){
                          if(value?.trim().isEmpty == true){
                            return "Yêu cầu mật mã";
                          }
                          return null;
                        },
                      ),
                      Wrap(
                        spacing: 10,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if(_formKeyReset.currentState!.validate()){
                                final passApp = _passControllerReset.text.trim();
                                final passMood = _passControllerMoodReset.text.trim();

                                final rsApp = await AppSecurityStorage.verifyPin(passApp);
                                final rsMood = await AppSecurityStorage.verifyPinM(passMood);

                                if(rsApp&&rsMood){
                                  final comfirm = await CustomDialog.showConfirmDialog(
                                      context: context,
                                      title: 'Xác nhận',
                                      message: 'Hành động sẽ loại bỏ tất cả các bảo mật hiện tại'
                                  );
                                  if(comfirm){
                                    await AppSecurityStorage.resetAll();
                                    await CustomDialog.showConfirmDialog(
                                        context: context,
                                        title: 'Thông báo',
                                        message: 'Đã hủy các bảo mật hiện tại'
                                    );
                                    setState(() {
                                      _lockApp = false;
                                      _lockMood = false;
                                      _showForm = false;
                                      _showFormMood = false;
                                      _showFormReset = false;
                                    });
                                  }
                                }
                                else{
                                  await CustomDialog.showMessageDialog(
                                      context: context,
                                      title: 'Lỗi',
                                      message: 'Xác thực không thành công'
                                  );
                                }
                              }
                            },
                            child: Text('Xác nhận'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _showFormReset = false;
                              });
                            },
                            child: Text('Hủy'),
                          ),
                        ],
                      )
                    ],
                  )
              ),
            ),
            Divider(height: 5,),
            _buildAbout(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAbout(BuildContext context){
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Center(
            child: Text('Thông tin', style: Theme.of(context).textTheme.titleMedium,),
          ),
          ExpansionTile(
            childrenPadding: EdgeInsets.all(10),
            initiallyExpanded: true,
            shape: Border(),
            title: Text('Bảo mật ứng dụng'),
            children: [
              Text(' - Khi bật, mỗi lần mở ứng dụng sẽ yêu cầu nhập mật khẩu để truy cập')
            ],
          ),
          SizedBox(height: 10,),
          ExpansionTile(
            childrenPadding: EdgeInsets.all(10),
            shape: Border(),
            initiallyExpanded: true,
            title: Text('Bảo mật nhật ký'),
            children: [
              Text(' - Khi bật, lần đầu tiên truy cập nhật ký sẽ cần mật khẩu')
            ],
          ),
          SizedBox(height: 10,),
          ExpansionTile(
            childrenPadding: EdgeInsets.all(10),
            shape: Border(),
            initiallyExpanded: true,
            title: Text('Xóa bảo mật'),
            children: [
              Text(' - Hủy tất cả các bảo mật đang được bật')
            ],
          )
        ],
      ),
    );
  }

}