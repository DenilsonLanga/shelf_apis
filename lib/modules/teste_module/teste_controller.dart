
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
part 'teste_controller.g.dart';

@injectable
class TesteController {
  
  @Route.get('/')
  Future<Response> teste(Request req) async{
    return Response.ok('Teste bem sucedido!');
  }

  @Route.get('/fake')
  Future<Response> testeFake(Request req) async{
    return Response.ok('This is a fake teste returned from your request. Its just to test the second url');
  }

Router get router => _$TesteControllerRouter(this);

}