
import 'package:shelf_apis/app/config/service_locator.dart';
import 'package:shelf_apis/modules/fornecedor/controller/supplier_controller.dart';
import 'package:shelf_apis/modules/i_router.dart';
import 'package:shelf_router/shelf_router.dart';

class SupplierRouter implements IRouter{
  @override
  void routerMounter(Router router) {
    router.mount('/supplier/', getIt.get<SupplierController>().router.call);
  }
  
}