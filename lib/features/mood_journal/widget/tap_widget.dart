import 'package:flutter/material.dart';

class TripleTapBackWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onHandel;

  const TripleTapBackWrapper({super.key, required this.child, required this.onHandel});

  @override
  State<TripleTapBackWrapper> createState() => _TripleTapBackWrapperState();
}
class _TripleTapBackWrapperState extends State<TripleTapBackWrapper> {
  int _tapCount = 0;
  DateTime? _lastTap;

  static const _tapThreshold = Duration(milliseconds: 400);

  void _handleTap() {
    final now = DateTime.now();

    if (_lastTap == null ||
        now.difference(_lastTap!) > _tapThreshold) {
      _tapCount = 1;
    } else {
      _tapCount++;
    }

    _lastTap = now;

    if (_tapCount == 3) {
      _tapCount = 0;
      widget.onHandel.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _handleTap(),
      child: widget.child,
    );
  }
}