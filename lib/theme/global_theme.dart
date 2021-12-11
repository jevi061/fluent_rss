import 'package:flutter/material.dart';

class GlobalTheme {
  static ThemeData get light {
    return ThemeData.light()
        .copyWith(iconTheme: IconThemeData(color: Colors.blueAccent));
  }
}
