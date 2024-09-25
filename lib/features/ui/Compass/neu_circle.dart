import 'package:flutter/material.dart';

class NeuCircle extends StatelessWidget {
  final Widget child;
  final double size;
  final Color baseColor;

  const NeuCircle({
    Key? key,
    required this.child,
    this.size = 200,
    this.baseColor = const Color(0xFFE0E0E0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.05),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: baseColor,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            baseColor.brighten(10),
            baseColor,
            baseColor.darken(10),
            baseColor.darken(20),
          ],
          stops: [0.1, 0.3, 0.8, 1],
        ),
        boxShadow: [
          BoxShadow(
            color: baseColor.darken(20).withOpacity(0.5),
            offset: Offset(size * 0.02, size * 0.02),
            blurRadius: size * 0.05,
            spreadRadius: size * 0.005,
          ),
          BoxShadow(
            color: baseColor.brighten(20).withOpacity(0.5),
            offset: Offset(-size * 0.02, -size * 0.02),
            blurRadius: size * 0.05,
            spreadRadius: size * 0.005,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              baseColor.brighten(15),
              baseColor,
              baseColor.darken(15),
            ],
            stops: [0.2, 0.6, 1],
          ),
          boxShadow: [
            BoxShadow(
              color: baseColor.darken(10).withOpacity(0.5),
              offset: Offset(size * 0.01, size * 0.01),
              blurRadius: size * 0.02,
              spreadRadius: size * 0.005,
            ),
            BoxShadow(
              color: baseColor.brighten(10).withOpacity(0.5),
              offset: Offset(-size * 0.01, -size * 0.01),
              blurRadius: size * 0.02,
              spreadRadius: size * 0.005,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

extension ColorExtension on Color {
  Color darken([double amount = 10]) {
    assert(amount >= 0 && amount <= 100);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - (amount / 100)).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  Color brighten([double amount = 10]) {
    assert(amount >= 0 && amount <= 100);
    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness((hsl.lightness + (amount / 100)).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
}