import 'package:logger/logger.dart';

final Logger logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

void logInfo(String msg) => logger.i(msg);
void logWarn(String msg) => logger.w(msg);
void logError(String msg, [Object? err, StackTrace? st]) => logger.e(msg, error: err, stackTrace: st);
