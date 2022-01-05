import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData.light().copyWith(
        iconTheme: IconThemeData(color: Color(0xff7540ee)),
        colorScheme: ColorScheme.light().copyWith(primary: Color(0xff7540ee)));
  }
}
