
import 'package:shelf_apis/app/config/service_locator.dart';
import 'package:shelf_apis/modules/category/controller/category_controller.dart';
import 'package:shelf_apis/modules/i_router.dart';
import 'package:shelf_router/shelf_router.dart';

class CategoryRouter implements IRouter{
  @override
  void routerMounter(Router router) {
    router.mount('/category/', getIt.get<CategoryController>().router.call);
  }
  
}