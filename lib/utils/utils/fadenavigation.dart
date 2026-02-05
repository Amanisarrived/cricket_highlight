import 'package:flutter/material.dart';

class FadePageRoute extends PageRouteBuilder {
  final Widget page;

  FadePageRoute({required this.page})
      : super(
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (
        context,
        animation,
        secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
        ) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
