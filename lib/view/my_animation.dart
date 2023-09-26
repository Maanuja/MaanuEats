import 'dart:async';

import 'package:flutter/material.dart';

class MyAnimation extends StatefulWidget {
  late int duration;
  late Widget child;
  MyAnimation({required this.duration, required this.child, super.key});

  @override
  State<MyAnimation> createState() => _MyAnimationState();
}

class _MyAnimationState extends State<MyAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> animationOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration : const Duration(seconds: 2),
        vsync: this
    );
    CurvedAnimation curvedAnimation = CurvedAnimation(parent: _controller, curve: Curves.linear);
    animationOffset = Tween<Offset>(
      begin: const Offset(0, 0),
      end: Offset.zero,
    ).animate(curvedAnimation);
    Timer(Duration(seconds: widget.duration), () {
      _controller.forward();
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity: _controller,
      child: SlideTransition(
        position: animationOffset,
        child: widget.child,
      )
    );
  }
}