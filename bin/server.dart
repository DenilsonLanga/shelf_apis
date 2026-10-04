import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_apis/app/config/app_config.dart';
import 'package:shelf_apis/app/middlewares/cors_middleware.dart';
import 'package:shelf_apis/app/middlewares/default_content_middleware.dart';
import 'package:shelf_apis/app/middlewares/security_middleware.dart';
import 'package:shelf_router/shelf_router.dart';

// Configure routes.
final _router = Router()
  ..get('/', _rootHandle)
  ..get('/echo/<message>', _echoHandler);

Response _rootHandle(Request req) {
  return Response.ok('Hello, World! It\'s my first back-end');
}

Response _echoHandler(Request request, String userId) {

  return Response.ok(' user: $userId');
}

void main(List<String> args) async {

  AppConfig().loadAppConfig(_router);
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;
_router.get('/login', (Request req){
  return Response.ok('Login nao protegido pelo middleware!');
});
  // Configure a pipeline that logs requests.
  final handler =
      Pipeline()
      .addMiddleware(CorsMiddleware().handler)
      .addMiddleware(DefaultContentMiddleware().handler)
      .addMiddleware(SecurityMiddleware().handler)
      .addMiddleware(logRequests()).addHandler(_router.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
