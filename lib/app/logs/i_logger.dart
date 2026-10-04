
abstract class ILogger {
  
  void debug(dynamic msg, [dynamic error, StackTrace stackTrace]);
  void error(dynamic msg, [dynamic error, StackTrace stackTrace]);
  void info(dynamic msg, [dynamic error, StackTrace stackTrace]);
  void warning(dynamic msg, [dynamic error, StackTrace stackTrace]);
}