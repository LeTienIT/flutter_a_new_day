import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePopup {
  static Future<void> showIfFirstTime(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hasShownPopup = prefs.getBool('hasShownWelcomePopup') ?? false;

    if (!hasShownPopup) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const _WelcomeDialog(),
      );
        await prefs.setBool('hasShownWelcomePopup', true);
    }
  }
}

class _WelcomeDialog extends StatelessWidget {
  const _WelcomeDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(16),
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6, // giới hạn chiều cao tối đa
          ),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animation
                Lottie.asset(
                  'assets/welcome.json',
                  width: 150,
                  height: 150,
                  repeat: true,
                ),

                const SizedBox(height: 12),

                // Cảm ơn
                Text(
                  'Cảm ơn bạn đã tải ứng dụng! CHÚC BẠN MỘT NGÀY TỐT LÀNH',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                RichText(text: TextSpan(
                    text: 'Ây này',
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                          text: '\n-  Bạn đã tứng sử dụng nhật ký này ở đâu chưa.'
                              '\n-  Nếu có bạn có thể sao lưu dữ liệu từ thiết bị cũ.'
                              '\n-  Sau đó có thể khôi phục trên thiết bị mới này.',
                          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.green, fontSize: 16)
                      ),
                      TextSpan(
                          text: '\n\n\n! Hiện tại app chưa hỗ trợ tính năng đồng bộ.'
                              '\n! Vì thế, việc khôi phục sẽ chỉ có dữ liệu cũ - không có dữ liệu hiện tại.'
                              '\n=> Nếu bạn muốn đồng bộ - hãy khôi phục lại dữ liệu trước khi sử dụng tiếp!',
                          style: TextStyle(color: Colors.redAccent,fontSize: 12, fontWeight: FontWeight.bold)
                      ),
                    ]
                )),
                const SizedBox(height: 10),
                Text(
                  'Hề hề! Một lần nữa cảm ơn bạn đã chịu đọc đến đây!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                // Hai nút
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Đóng'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context, '/backup', (route) => false);
                      },
                      child: const Text('Khôi phục'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

