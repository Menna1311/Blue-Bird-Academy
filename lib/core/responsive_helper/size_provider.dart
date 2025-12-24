import 'package:flutter/cupertino.dart';

class SizeProvider extends InheritedWidget {
  final Size baseSize;
  final double width;
  final double height;
  final double baseTextSize;

  const SizeProvider({
    super.key,
    required super.child,
    required this.baseSize,
    required this.width,
    required this.height,
    required this.baseTextSize,
  });

  static SizeProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SizeProvider>()!;
  }

  @override
  bool updateShouldNotify(covariant SizeProvider oldWidget) {
    return baseSize != oldWidget.baseSize ||
        width != oldWidget.width ||
        height != oldWidget.height ||
        child != oldWidget.child;
  }
}
