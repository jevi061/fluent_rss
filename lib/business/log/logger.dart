import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._privateConstructor();

  static final AppLogger _instance = AppLogger._privateConstructor();

  factory AppLogger() {
    return _instance;
  }
}
