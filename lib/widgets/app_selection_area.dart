import 'package:flutter/material.dart';

class AppSelectionArea extends StatelessWidget {
  final Widget child;

  const AppSelectionArea({super.key, required this.child});

  static bool get isTesting {
    return WidgetsBinding.instance.runtimeType.toString().contains('Test');
  }

  @override
  Widget build(BuildContext context) {
    if (isTesting) {
      return child;
    }
    return SelectionArea(child: child);
  }
}
