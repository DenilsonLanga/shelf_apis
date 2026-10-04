
import 'package:injectable/injectable.dart';
import 'package:shelf_apis/app/logs/i_logger.dart';
import 'package:logger/logger.dart' as log;

@LazySingleton(as: ILogger)
class Logger implements ILogger {
  final logger = log.Logger();

  @override
  void debug(msg, [error, StackTrace? stackTrace]) => logger.d(msg, error: error, stackTrace: stackTrace);

  @override
  void error(msg, [error, StackTrace? stackTrace]) => logger.e(msg, error: error, stackTrace: stackTrace);

  @override
  void info(msg, [error, StackTrace? stackTrace]) => logger.i(msg, error: error, stackTrace: stackTrace);

  @override
  void warning(msg, [error, StackTrace? stackTrace]) => logger.w(msg, error: error, stackTrace: stackTrace);
  
}