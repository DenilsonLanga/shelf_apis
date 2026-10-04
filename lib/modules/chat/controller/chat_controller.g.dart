// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_controller.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$ChatControllerRouter(ChatController service) {
  final router = Router();
  router.add(
    'POST',
    r'/<schedule|[0-9]+>',
    service.startChat,
  );
  router.add(
    'POST',
    r'/notify',
    service.notifyChat,
  );
  router.add(
    'GET',
    r'/user',
    service.getChats,
  );
  router.add(
    'GET',
    r'/supplier',
    service.getChatsSupplier,
  );
  return router;
}
