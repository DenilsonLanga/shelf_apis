
import 'dart:convert';
import 'dart:io';

import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_apis/app/helpers/jwt_helper.dart';
import 'package:shelf_apis/app/middlewares/middleware.dart';
import 'package:shelf_apis/app/middlewares/skip_urls.dart';

class SecurityMiddleware extends Middlewares {
  final skipUrls = [
   SkipUrls(url: '/supplier/user', method: 'GET'),
   SkipUrls(url: '/supplier/user', method: 'POST'),
    SkipUrls(url: '/auth/', method: 'POST'),
    SkipUrls(url: '/auth/register', method: 'POST'),
    SkipUrls(url: '/auth/delete', method: 'DELETE'),
  ];
  @override
  Future<Response> executer(Request request) async{

    if(skipUrls.contains(SkipUrls(url: '/${request.url.path}', method: request.method))){
      return innerHandler(request);
    }
//
    try {
  final authHeader = request.headers[HttpHeaders.authorizationHeader];
  
  if(authHeader == null || authHeader.isEmpty || !authHeader.contains('Bearer ')){
    throw JwtException.invalidToken;  
  }
  
  final token = authHeader.substring(7);
  final claims = JwtHelper().getClaims(token);

  if(request.url.path != 'auth/refresh'){
    claims.validate();
  } 

  final claimsMap = claims.toJson();

  final securityHeaders = {
    'user': claimsMap['pld']['sub'].toString(),
    'access_token': token,
    'supplier': claimsMap['pld']['supplier'].toString()
  };

  return await innerHandler(request.change(headers: securityHeaders));

} on JwtException {
  return Response.unauthorized(jsonEncode('Token invalido tente efetuar o login novamente'));
  //return Response.forbidden("{message: Token invalido tente efetuar o login novamente}");
} on Exception catch (e) {
  print(e);
  return Response.internalServerError();
}
    
  }
  
}