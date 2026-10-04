
import 'package:shelf_apis/app/config/service_locator.dart';
import 'package:shelf_apis/modules/i_router.dart';
import 'package:shelf_apis/modules/schedule/controller/schedule_controller.dart';
import 'package:shelf_router/shelf_router.dart';

class ScheduleRouter extends IRouter {
  @override
  void routerMounter(Router router) {
      router.mount('/schedule/', getIt.get<ScheduleController>().router.call,);
  }
  
}