import 'package:flutter/material.dart';

class FullScreenDrawerPageRoute extends PageRouteBuilder {
  final Widget page;

  FullScreenDrawerPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0); // Start position of the drawer (off-screen)
            const end = Offset.zero; // End position (on-screen)
            const curve = Curves.easeInOut; // Animation curve

            var tween = Tween(begin: begin, end: end);
            var offsetAnimation = animation.drive(tween.chain(CurveTween(curve: curve)));

            return SlideTransition(position: offsetAnimation, child: child);
          },
          opaque: false,
          barrierDismissible: true,
        );
}
