// Tạo widget riêng
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/tool.dart';
import '../../../data/models/mood_model.dart';
import '../../setting/icon_edit/file_icon_controller.dart';
import '../../setting/setting_controller.dart';

class FirstPageView extends ConsumerWidget {
  final MoodModel m;
  const FirstPageView({required this.m});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fileIconProvider);

    final gradientAsync = ref.watch(coverGradientProvider);
    final gradient = gradientAsync.value ?? const LinearGradient(colors: [Color(0xFFd7ccc8), Color(0xFFa1887f)],);

    final textColorAsync = ref.watch(coverTextColorProvider);
    final textColor = textColorAsync.value ?? Colors.black;

    if (state.isLoading) return const Center(child: CircularProgressIndicator());

    final parts = m.emoji.split('|');
    final imagePath = parts.first;
    final slogan = parts.length > 1 ? parts.last : '';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: gradient,
        // border: const Border(
        //   right: BorderSide(color: Color(0xFFD6C6B5), width: 6),
        // ),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withValues(alpha: 0.15),
            offset: const Offset(2, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;
          return Stack(
            children: [
              for (final icon in state.icons.where((e) => e.page == 1))
                Positioned(
                  left: icon.posX * screenWidth,
                  top: icon.posY * screenHeight,
                  child: SizedBox(
                    width: icon.width * screenWidth,
                    height: icon.height * screenHeight,
                    child: Image.file(File(icon.path), fit: BoxFit.contain),
                  ),
                ),
              Positioned.fill(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        formatVietnameseDate(m.date),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor)),
                    const SizedBox(height: 30),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Image.asset(imagePath, width: 64, height: 64),
                        Text(
                            slogan,
                            style: TextStyle(
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                                color: textColor)),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Image.asset('assets/emoji_default/arrow.png',
                    width: 80, height: 20, fit: BoxFit.fill),
              ),
            ],
          );
        },
      ),
    );
  }
}