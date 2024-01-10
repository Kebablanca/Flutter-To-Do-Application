
import 'package:flutter/material.dart';

class BottomBackgroundImage extends StatelessWidget {
  final Widget child;
  const BottomBackgroundImage({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        const Align(
            alignment: Alignment.bottomCenter,
            child: Image(image: AssetImage("lib/assets/images/bottombg.png")))
      ],
    );
  }
}
