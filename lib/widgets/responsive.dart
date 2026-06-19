import 'package:flutter/material.dart';

/// Tablet/desktop breakpoint. Phones are below this.
const double kWideBreakpoint = 720;

bool isWideScreen(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= kWideBreakpoint;

/// Caps content width and centres it on large screens (tablet/iPad/desktop),
/// while leaving phones completely unaffected. Wrap a screen's scrollable body.
class MaxWidth extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  const MaxWidth({super.key, required this.child, this.maxWidth = 700});

  @override
  Widget build(BuildContext context) => Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      );
}
