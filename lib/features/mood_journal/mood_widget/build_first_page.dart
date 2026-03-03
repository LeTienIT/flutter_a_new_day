import 'package:a_new_day/data/models/mood_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/tool.dart';

class buildFirstPage extends StatelessWidget{
  final MoodModel m;

  const buildFirstPage({super.key, required this.m});

  @override
  Widget build(BuildContext context) {
    final parts = m.emoji.split('|');
    final imagePath = parts.first;
    final slogan = parts.length > 1 ? parts.last : '';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFd7ccc8), Color(0xFFa1887f)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: const Border(
          right: BorderSide(color: Color(0xFFD6C6B5), width: 6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withValues(alpha: 0.15),
            offset: const Offset(2, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 30,
            child: Image.asset(
              'assets/sticker/hoa_sen.png',
              width: 80,
              height: 80,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/sticker/tra_sua.png',
              width: 80,
              height: 80,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 80,
            child: Image.asset(
              'assets/sticker/hoa_hong.png',
              width: 80,
              height: 80,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'NHẬT KÝ',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                formatVietnameseDate(m.date),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Image.asset(
                    imagePath,
                    width: 64,
                    height: 64,
                  ),
                  Text(
                    slogan,
                    style: const TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/emoji_default/arrow.png',
              width: 80,
              height: 20,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }

}