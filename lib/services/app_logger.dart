import 'package:logger/logger.dart';

class AppLogger {
  static Logger instance = Logger(printer: PrettyPrinter(methodCount: 0));
}
