
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_apis/app/logs/i_logger.dart';
import 'package:shelf_apis/app/models/chat.dart';
import 'package:shelf_apis/modules/chat/service/i_chat_service.dart';
import 'package:shelf_apis/modules/chat/view_models/chat_model.dart';
import 'package:shelf_router/shelf_router.dart';

part 'chat_controller.g.dart';

@injectable
class ChatController {
  final IChatService chatService;
  final ILogger logger;

  ChatController({required this.chatService, required this.logger});

  @Route.post('/<schedule|[0-9]+>')
  Future<Response> startChat(Request req, String schedule) async{

    final scheduleId = int.parse(schedule);
    try {
      final response = await chatService.startNewChat(scheduleId);
      return Response.ok('Chat com id $response iniciado.');
    } catch (e) {
      return Response.internalServerError(body: 'Erro ao iniciar chat');
    }
  }


  @Route.post('/notify')
  Future<Response> notifyChat(Request req) async{
    try {
      final model = ChatModel(await req.readAsString());
      final isSupplier = req.headers['supplier'] != null;
      
      model.senderType = isSupplier ? 's' : 'u';
 
      await chatService.notifyChat(model);
      return Response.ok(jsonEncode({'message':'Notificacao enviada com sucesso!'})); 
    } catch (e) {
     return Response.internalServerError(body: 'Erro de servidor ao enviar notificacao');
    }
  }
   @Route.get('/user')
   Future<Response> getChats(Request req) async{
    final List<Chat> chats;

    try {
      final userId = int.tryParse(req.headers['user']!)!;
      final supplierID = int.tryParse(req.headers['supplier'] ?? '');

      if(supplierID != null){
         chats = await chatService.getChatsBySupplier(supplierID);
      } else{
         chats = await chatService.getChatsByUser(userId);

      }
      
      return Response.ok(
        jsonEncode(
          chats.map(
            (c) => {
              "id": c.id,
              "user_id": c.userId,
              "name": c.ownerName,
              "pet_name": c.petName,
              "supplier": {
                "id": c.supplier.supplierId,
                "supplier_name": c.supplier.name,
                "logo": c.supplier.logo
              },
            },
          ).toList()
        )
      );
    } catch (e) {
      logger.error('Erro ao recuperar chats do utilizador.');
      return Response.internalServerError();
    }

   }


@Route.get('/supplier')
   Future<Response> getChatsSupplier(Request req) async{

    try {
      final supplierID = int.tryParse(req.headers['supplier']!);

      if(supplierID == null ){
        return Response.badRequest(body: jsonEncode({"Message": "O usuario nao e um fornecedor"}));
      }
      
      final chats = await chatService.getChatsByUser(supplierID);

      return Response.ok(
        jsonEncode(
          chats.map(
            (c) => {
              "id": c.id,
              "user_id": c.userId,
              "name": c.ownerName,
              "pet_name": c.petName,
              "supplier": {
                "id": c.supplier.supplierId,
                "supplier_name": c.supplier.name,
                "logo": c.supplier.logo
              },
            },
          ).toList()
        )
      );
    } catch (e) {
      logger.error('Erro ao recuperar chats do utilizador.');
      return Response.internalServerError();
    }

   }

 Router get router => _$ChatControllerRouter(this); 

 
}