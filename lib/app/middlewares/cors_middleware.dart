
import 'package:shelf/shelf.dart';
import 'package:shelf_apis/app/middlewares/middleware.dart';

class CorsMiddleware extends Middlewares{
  @override
  Future<Response> executer(Request request) async{
    Map<String,String> headers = {
    'Access-Control-Allow-Origin': '*', // Permite qualquer site (o asterisco é "todos")
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS', // Métodos permitidos
    'Access-Control-Allow-Headers': 'Origin, Content-Type, Authorization', // Cabeçalhos aceitos
  };

  if(request.method == 'OPTIONS'){
   return Response.ok('', headers: headers);
  }

  final resp = await innerHandler(request);
  return resp.change(headers: headers);
    }
  }
  
