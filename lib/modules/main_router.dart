

import 'package:shelf_apis/modules/category/category_router.dart';
import 'package:shelf_apis/modules/chat/chat_router.dart';
import 'package:shelf_apis/modules/fornecedor/supplier_router.dart';
import 'package:shelf_apis/modules/i_router.dart';
import 'package:shelf_apis/modules/schedule/schedule_router.dart';
import 'package:shelf_apis/modules/teste_module/teste_router.dart';
import 'package:shelf_apis/modules/user/user_router.dart';
import 'package:shelf_router/shelf_router.dart';

class MainRouter {
  final Router router;
  final List<IRouter> routers = [
  UserRouter(),
  TesteRouter(),
  CategoryRouter(),
  SupplierRouter(),
  ScheduleRouter(),
  ChatRouter()
  ];

  MainRouter({required this.router});

  void routerConfigure() =>
    routers.forEach((r) => r.routerMounter(router),);
}