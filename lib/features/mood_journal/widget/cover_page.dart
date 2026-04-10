import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../setting/icon_edit/file_icon_controller.dart';
import '../../setting/setting_controller.dart';

class CoverPageView extends ConsumerWidget {
  const CoverPageView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fileIconProvider);
    final titleAsync = ref.watch(coverTitleProvider);
    final subAsync = ref.watch(coverSubtitleProvider);

    final gradientAsync = ref.watch(coverGradientProvider);
    final gradient = gradientAsync.value ?? const LinearGradient(colors: [Color(0xFFd7ccc8), Color(0xFFa1887f)],);

    final textColorAsync = ref.watch(coverTextColorProvider);
    final textColor = textColorAsync.value ?? Colors.black;

    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;
          return Stack(
            children: [
              for (final icon in state.icons.where((e) => e.page == 2))
                Positioned(
                  left: icon.posX * screenWidth,
                  top: icon.posY * screenHeight,
                  child: Transform.rotate(
                    angle: icon.rotation,
                    child: SizedBox(
                      width: icon.width * screenWidth,
                      height: icon.height * screenHeight,
                      child: Image.file(File(icon.path), fit: BoxFit.contain),
                    ),
                  ),
                ),
              Center(
                child: titleAsync.when(
                  data: (title) => Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 3,
                          color: Colors.black26,
                        )
                      ],
                    ),
                  ),
                  loading: () => const SizedBox(),
                  error: (_, __) => const SizedBox(),
                ),
              ),
              Positioned(
                bottom: 60,
                left: 16,
                right: 16,
                child: subAsync.when(
                  data: (text) => Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: textColor,
                    ),
                  ),
                  loading: () => const SizedBox(),
                  error: (_, __) => const SizedBox(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}