
import 'package:shelf_apis/app/config/service_locator.dart';
import 'package:shelf_apis/modules/i_router.dart';
import 'package:shelf_apis/modules/user/controller/auth_controller.dart';
import 'package:shelf_apis/modules/user/controller/user_controller.dart';
import 'package:shelf_router/shelf_router.dart';

class UserRouter implements IRouter{
  @override
  void routerMounter(Router router) {
    router.mount('/auth/', getIt.get<AuthController>().router.call);
    router.mount('/user/', getIt.get<UserController>().router.call);
  }
  
}