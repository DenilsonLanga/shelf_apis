
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_apis/app/middlewares/middleware.dart';

class DefaultContentMiddleware extends Middlewares{
  @override
  Future<Response> executer(Request request) async {
    final resp = await innerHandler(request);
    return resp.change(headers: {HttpHeaders.contentTypeHeader: 'application/json;charset=utf-8',});
  }
}