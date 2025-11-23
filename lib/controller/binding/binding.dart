
import 'package:flutter/material.dart';
//i have use this for langauge translation
class LtrBinding extends WidgetsFlutterBinding {
  static WidgetsBinding ensureInitialized() {
    if (WidgetsBinding.instance == null) {
      LtrBinding();
    }
    return WidgetsBinding.instance;
  }

  @override
  TextDirection computeTextDirection(Iterable<Locale> locales) {
    return TextDirection.ltr; // force layout to LTR
  }
}
