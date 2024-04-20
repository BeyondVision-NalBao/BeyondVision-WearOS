import 'package:flutter/material.dart';
import 'package:watch_app/constants.dart';

class OutlineCircleButton extends StatelessWidget {
  const OutlineCircleButton({
    super.key,
    this.onTap,
    this.radius = 200.0,
    this.borderColor = Colors.black,
    this.foregroundColor = Colors.white,
    this.child,
  });

  final onTap;
  final radius;
  final borderColor;
  final foregroundColor;
  final child;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(
          color: foregroundColor,
          shape: BoxShape.circle,
        ),
        child: Material(
          color: const Color(boxColor),
          child: InkWell(
              child: child ?? const SizedBox(),
              onTap: () async {
                if (onTap != null) {
                  onTap();
                }
              }),
        ),
      ),
    );
  }
}
