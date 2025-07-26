import 'package:a_new_day/core/utils/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/utils/BiometricAuthGate.dart';
import '../../core/utils/app_security_storage.dart';
import '../../core/utils/tool.dart'; // nếu dùng CustomDialog

class PinAuthScreen extends StatefulWidget {
  final AuthType type;
  bool go;
  PinAuthScreen({super.key, required this.type, this.go = true});

  @override
  State<PinAuthScreen> createState() => _PinAuthScreenState();
}

class _PinAuthScreenState extends State<PinAuthScreen> with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  bool _error = false;
  late AnimationController _shakeController;
  late Animation<double> _offsetAnimation;

  int countMax = 0;
  bool showRestCode = false;

  final _formKey = GlobalKey<FormState>();
  late final _question1Controller;
  final _answer1Controller = TextEditingController();
  late final _question2Controller;
  final _answer2Controller = TextEditingController();

  final _formKeyM = GlobalKey<FormState>();
  late final _question1ControllerM;
  final _answer1ControllerM = TextEditingController();
  late final _question2ControllerM;
  final _answer2ControllerM = TextEditingController();

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _offsetAnimation = Tween<double>(begin: 0, end: 16)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);
    _load();
  }

  void _load() async{
    final q1 = await AppSecurityStorage.getQuestion();
    final q2 = await AppSecurityStorage.getQuestionM();
    if (!mounted) return;
    if(q1.isNotEmpty&&q2.isNotEmpty) {
      setState(() {
        _question1Controller = TextEditingController(text: q1.first);
        _question2Controller = TextEditingController(text: q1.last);
        _question1ControllerM = TextEditingController(text: q2.first);
        _question2ControllerM = TextEditingController(text: q2.last);
      });
    }
  }
  @override
  void dispose() {
    _controller.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _validatePin() async {
    final input = _controller.text.trim();

    bool success = false;
    if (widget.type == AuthType.app) {
      final pin = await AppSecurityStorage.getPin();
      success = pin == input;
    } else {
      final pin = await AppSecurityStorage.getPinM();
      success = pin == input;
    }

    if (success) {
      if(widget.type == AuthType.app){
        if(widget.go){
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/habit-home',
                (router)=>false,
          );
          return;
        }
        else{
          Navigator.pop(context, true);
        }
      }
      if (widget.type == AuthType.mood) {
        AppSecurityStorage.setMoodUnlockedOnce(true);
        Navigator.pop(context, true);
      }

    }
    else {
      setState(() {
        _error = true;
        countMax++;
      });
      _shakeController.forward(from: 0);

      if(countMax > 5){
        final confirm = await CustomDialog.showConfirmDialog(
            context: context,
            title: 'Cảnh báo',
            message: 'Nhập sai mật mã quá nhiều lần\n\nThực hiện chức năng quên mật mã'
        );
        if(confirm){
          setState(() {
            showRestCode = true;
          });
        }
        else{
          if(widget.type == AuthType.app){
            SystemNavigator.pop();
          }
          else{
            Navigator.pop(context);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nhập mã bảo mật')),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _offsetAnimation,
              builder: (context, child) => Transform.translate(
                offset: Offset(_offsetAnimation.value, 0),
                child: child,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _controller,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Mã bảo mật',
                        errorText: _error ? 'Sai mã, vui lòng thử lại' : null,
                        border: const OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _validatePin(),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _validatePin,
                      child: const Text('Xác nhận'),
                    ),
                  ],
                ),
              ),
            ),

            // Widget hiển thị sau nhiều lần sai
            if (showRestCode)...[
              if(widget.type == AuthType.app)...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                  color: Theme.of(context).cardColor,
                  child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: _question1Controller,
                            decoration: InputDecoration(labelText: 'Câu hỏi bảo mật 1'),
                            readOnly: true,
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
                            readOnly: true,
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
                                    final a1 = _answer1Controller.text.trim();
                                    final a2 = _answer2Controller.text.trim();
                                    final rs = await AppSecurityStorage.verifyQuestion(a1, a2);
                                    if(rs){
                                      final pin = await AppSecurityStorage.getPin();
                                      await CustomDialog.showMessageDialog(
                                          context: context,
                                          title: 'MÃ PIN HIỆN TẠI',
                                          message: '$pin'
                                      );
                                      setState(() {
                                        showRestCode = false;
                                      });
                                    }
                                    else{
                                      final otherComf = await CustomDialog.showConfirmDialog(
                                          context: context,
                                          title: 'Xác thực không thành công',
                                          message: 'Câu trả lời không chính xác\n\n Xác thực bằng cách khác'
                                      );
                                      if(otherComf){
                                        final isAuthenticated = await BiometricAuthHelper.authenticate(context: context);
                                        if (isAuthenticated) {
                                          final pin = await AppSecurityStorage.getPin();
                                          await CustomDialog.showMessageDialog(
                                            context: context,
                                            title: 'MÃ PIN HIỆN TẠI',
                                            message: '$pin',
                                          );
                                          setState(() {
                                            showRestCode = false;
                                          });
                                        }
                                      }
                                    }
                                  }
                                },
                                child: Text('Xác nhận'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    showRestCode = false;
                                  });
                                  SystemNavigator.pop();
                                },
                                child: Text('Thoát'),
                              ),
                            ],
                          )
                        ],
                      )
                  ),
                ),
              ]
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                  color: Theme.of(context).cardColor,
                  child: Form(
                      key: _formKeyM,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: _question1ControllerM,
                            decoration: InputDecoration(labelText: 'Câu hỏi bảo mật 1'),
                            readOnly: true,
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
                            readOnly: true,
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
                                    final a1 = _answer1ControllerM.text.trim();
                                    final a2 = _answer2ControllerM.text.trim();

                                    final rs = await AppSecurityStorage.verifyQuestionM(a1, a2);
                                    if(rs){
                                      final pin = await AppSecurityStorage.getPinM();
                                      await CustomDialog.showMessageDialog(
                                          context: context,
                                          title: 'MÃ PIN HIỆN TẠI',
                                          message: '$pin'
                                      );
                                      setState(() {
                                        showRestCode = false;
                                      });
                                    }
                                    else{
                                      final otherConf = await CustomDialog.showConfirmDialog(
                                          context: context,
                                          title: 'Xác thực không thành công',
                                          message: 'Câu trả lời không chính xác\n\nXác thực bằng mật khẩu điện thoại'
                                      );
                                      if(otherConf){
                                        final isAuthenticated = await BiometricAuthHelper.authenticate(context: context);
                                        if (isAuthenticated) {
                                          final pin = await AppSecurityStorage.getPinM();
                                          await CustomDialog.showMessageDialog(
                                            context: context,
                                            title: 'MÃ PIN HIỆN TẠI',
                                            message: '$pin',
                                          );
                                          setState(() {
                                            showRestCode = false;
                                          });
                                        }
                                      }
                                    }
                                  }
                                },
                                child: Text('Xác nhận'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    showRestCode = false;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text('Thoát'),
                              ),
                            ],
                          )
                        ],
                      )
                  ),
                ),
            ]
          ],
        ),
      ),
    );
  }
}
