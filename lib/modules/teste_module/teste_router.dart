
import 'package:shelf_apis/app/config/service_locator.dart';
import 'package:shelf_apis/modules/i_router.dart';
import 'package:shelf_apis/modules/teste_module/teste_controller.dart';
import 'package:shelf_router/shelf_router.dart';

class TesteRouter implements IRouter {
  //final getIt = GetIt.instance;
  @override
  void routerMounter(Router router) {
    router.mount('/teste/', getIt<TesteController>().router.call);
  }
  
}