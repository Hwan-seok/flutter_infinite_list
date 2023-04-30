import 'package:flutter/material.dart';

class ScrollEndNotifier extends StatelessWidget {
  final Widget scrollable;
  final void Function() onScrollEnd;

  const ScrollEndNotifier(
      {super.key, required this.scrollable, required this.onScrollEnd});

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        if (notification.metrics.maxScrollExtent - notification.metrics.pixels <
            100) {
          onScrollEnd();
        }

        return true;
      },
      child: scrollable,
    );
  }
}
