
import 'package:shelf_apis/app/config/service_locator.dart';
import 'package:shelf_apis/modules/chat/controller/chat_controller.dart';
import 'package:shelf_apis/modules/i_router.dart';
import 'package:shelf_router/src/router.dart';

class ChatRouter implements IRouter{
  @override
  void routerMounter(Router router) {
    router.mount('/chat/', getIt.get<ChatController>().router.call);
  }
  
}