

import 'package:flutter/foundation.dart';
import '../step_items/step_items.dart';


class DuaModel {
  final String title;
  final String imagePath;
  final String? intro;          // short intro / paragraph
  final List<StepItem> steps;   // step-by-step items
  final VoidCallback? onPressed;

  DuaModel({
    required this.title,
    required this.imagePath,
    this.intro,
    this.steps = const [],
    this.onPressed,
  });
}

