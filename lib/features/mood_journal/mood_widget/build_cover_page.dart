import 'package:flutter/material.dart';

class buildCoverPage extends StatelessWidget{
  const buildCoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFd7ccc8), Color(0xFFa1887f)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: Image.asset(
              'assets/sticker/trai_tim.png',
              width: 60,
              height: 80,
            ),
          ),
          Positioned(
            top: 60,
            right: 20,
            child: Image.asset(
              'assets/sticker/buc_tranh.png',
              width: 100,
              height: 100,
            ),
          ),
          Positioned(
            bottom: 60,
            right: 20,
            child: Image.asset(
              'assets/sticker/hoa.png',
              width: 100,
              height: 100,
            ),
          ),
          Positioned(
            bottom: 60,
            left: 20,
            child: Image.asset(
              'assets/sticker/co_4_la.png',
              width: 100,
              height: 100,
            ),
          ),
          Center(
            child: Text(
              '<3 NHẬT KÝ CỦA TRÁI TIM S2',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: Colors.brown,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 3,
                    color: Colors.black26,
                  )
                ],
              ),
            ),
          ),
          const Positioned(
            bottom: 60,
            left: 16,
            right: 16,
            child: Text(
              '"Cảm xúc hôm nay là món quà của ngày mai"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}