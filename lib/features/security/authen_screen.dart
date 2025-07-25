import 'package:flutter/material.dart';

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

    } else {
      setState(() => _error = true);
      _shakeController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nhập mã bảo mật')),
      body: Center(
        child: AnimatedBuilder(
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
