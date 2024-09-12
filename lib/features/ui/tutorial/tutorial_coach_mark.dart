import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'coach_mark_des.dart'; // Import the custom description widget

class TutorialHelper {
  /// Function to display the tutorial
  static void showTutorial({
    required BuildContext context,
    required List<TargetFocus> targets,
    Color colorShadow = Colors.black,
    // String skipText = "SKIP",
    double paddingFocus = 10.0,
    double opacityShadow = 0.8,
  }) {
    TutorialCoachMark tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      // textSkip: skipText,
      paddingFocus: paddingFocus,
      opacityShadow: opacityShadow,
      colorShadow: colorShadow,
    )..show(context: context);
  }

  /// Helper function to create `TargetFocus` with custom description widget
  static TargetFocus createCustomTarget({
    required String identify,
    required GlobalKey keyTarget,
    required String text, // Pass custom text for the custom widget
    ContentAlign align = ContentAlign.bottom,
    ShapeLightFocus? shape, // Allow custom shapes for the focus area
  }) {
    return TargetFocus(
      identify: identify,
      keyTarget: keyTarget,
      shape: shape ?? ShapeLightFocus.Circle, // Default to circle if no shape is provided
      contents: [
        TargetContent(
          align: align,
          builder: (context, controller) {
            return CoachMarkDes(
              text: text,
              onSkip: () {
                controller.skip();
              },
              onNext: () {
                controller.next();
              },
            );
          },
        ),
      ],
    );
  }

  /// Helper function to create a rectangular focus with rounded corners (RRect)
  static TargetFocus createRectangularTarget({
    required String identify,
    required GlobalKey keyTarget,
    required String text, // Pass custom text for the custom widget
    ContentAlign align = ContentAlign.bottom,
    double borderRadius = 10.0, // Rounded corners for RRect
  }) {
    return TargetFocus(
      identify: identify,
      keyTarget: keyTarget,
      shape: ShapeLightFocus.RRect, // Use a rounded rectangle focus
      radius: borderRadius, // Define the corner radius as a double
      contents: [
        TargetContent(
          align: align,
          builder: (context, controller) {
            return CoachMarkDes(
              text: text,
              onSkip: () {
                controller.skip();
              },
              onNext: () {
                controller.next();
              },
            );
          },
        ),
      ],
    );
  }
}
