import 'package:flutter/material.dart';

class PAppBarTransparency extends StatelessWidget {
  final Widget child;

  const PAppBarTransparency({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: child,
    );
  }
}
