import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RawMagnifier2 extends StatefulWidget {
  final Widget child;
  final double magnification;
  final double radius;

  const RawMagnifier2({
    Key? key,
    required this.child,
    this.magnification = 1.5,
    this.radius = 60,
  }) : super(key: key);

  @override
  _RawMagnifierState createState() => _RawMagnifierState();
}

class _RawMagnifierState extends State<RawMagnifier2> {
  Offset _position = Offset.zero;
  bool _magnifierVisible = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_magnifierVisible)
          Positioned(
            left: _position.dx - widget.radius,
            top: _position.dy - widget.radius,
            child: Container(
              width: widget.radius * 2,
              height: widget.radius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.matrix((Matrix4.identity()
                    ..scale(widget.magnification, widget.magnification)) as Float64List),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.1),
                      BlendMode.srcATop,
                    ),
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: _MagnifierPainter(
                          sourceContext: context,
                          sourceRect: Rect.fromCenter(
                            center: _position,
                            width: widget.radius * 2 / widget.magnification,
                            height: widget.radius * 2 / widget.magnification,
                          ),
                          targetRect: Rect.fromLTWH(0, 0, widget.radius * 2, widget.radius * 2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanStart: (details) {
              setState(() {
                _magnifierVisible = true;
                _position = details.localPosition;
              });
            },
            onPanUpdate: (details) {
              setState(() {
                _position = details.localPosition;
              });
            },
            onPanEnd: (_) {
              setState(() {
                _magnifierVisible = false;
              });
            },
          ),
        ),
      ],
    );
  }
}

class _MagnifierPainter extends CustomPainter {
  final BuildContext sourceContext;
  final Rect sourceRect;
  final Rect targetRect;

  _MagnifierPainter({
    required this.sourceContext,
    required this.sourceRect,
    required this.targetRect,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final RenderObject? renderObject = sourceContext.findRenderObject();
    if (renderObject is! RenderBox) return;

    final transform = renderObject.getTransformTo(null);
    final paint = Paint()..filterQuality = FilterQuality.high;

    canvas.save();
    canvas.clipRect(targetRect);
    canvas.transform(transform.storage);
    canvas.drawRect(sourceRect, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_MagnifierPainter oldDelegate) =>
      sourceRect != oldDelegate.sourceRect ||
      targetRect != oldDelegate.targetRect;
}