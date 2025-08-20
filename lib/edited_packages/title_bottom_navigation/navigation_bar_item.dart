// Flutter imports:
import 'package:flutter/material.dart';

class TitledNavigationBarItem {
  final Widget title;
  final Widget icon;
  final Color backgroundColor;

  TitledNavigationBarItem({
    required this.icon,
    required this.title,
    this.backgroundColor = Colors.white,
  });
}
