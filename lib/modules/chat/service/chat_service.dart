
import 'dart:convert';
import 'dart:io';

import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:shelf_apis/app/logs/i_logger.dart';
import 'package:shelf_apis/app/models/chat.dart';
import 'package:shelf_apis/app/models/device_token.dart';
import 'package:shelf_apis/modules/chat/data/i_chat_repository.dart';
import 'package:shelf_apis/modules/chat/service/i_chat_service.dart';
import 'package:shelf_apis/modules/chat/view_models/chat_model.dart';

@Injectable(as: IChatService)
class ChatService implements IChatService{

final IChatRepository chatRepository;
final ILogger log;

  ChatService({required this.chatRepository, required this.log});

  @override
  Future<int?> startNewChat(int scheduleId) async => await chatRepository.startNewChat(scheduleId);

  @override
  Future<void> notifyChat(ChatModel model) async {
    final chat = await chatRepository.getChatById(model);

    if(model.senderType.toLowerCase() == 'u'){
      _notifyUser(chat.supplierDeviceToken?.tokens ?? [], model.message, chat);
    }else{
      _notifyUser(chat.userDeviceToken?.tokens ?? [], model.message, chat);
    }
  }

  Future<void> _notifyUser(List<String?> tokens, String message, Chat chat ) async{


    final url = Uri.parse('https://fcm.googleapis.com/v1/projects/cuidapet-a8310/messages:send');
    final accessToken = await getAccessToken();

    final Map<String,dynamic> payLoad = {
        'type': 'chat_message',
        'chat': {
          'id': chat.id,
          'nome': chat.ownerName,
          'fornecedor':{
            'nome': chat.supplier.name,
            'logo': chat.supplier.logo
          }
        }
    };

  final payLoadJson = jsonEncode(payLoad);

    for (var token in tokens){
      if(token != null){

        final request = {
          "message":{
            "token": token,
            "notification":{
              "title": "Nova Messagem",
              "body": message
            },
            "android": {
              "priority": "HIGH",
              "notification": {
                "channel_id": "high_importance_channel",
                "sound": "default"
              }
            },
            "data": {
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "id": "1",
              "status": "p",
              "payload": payLoadJson
            },
          }
      };

       final response =  await http.post(
          url,
          body: jsonEncode(request),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          }
        );


      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        if(responseData.containsKey('error')){
          log.error('Ocorreu um erro ao tentar enviar a mensagem para o usuario: $token, erro ${responseData['error']}');
        }else{
          log.info('Mensagem enviada com sucesso para $token');
        }
      }
    }
  }
  

  Future<String> getAccessToken() async{
    final serviceAccountFile = File('service-account.json');
    final serviceAccount = jsonDecode(await serviceAccountFile.readAsString());

    //PERMISSAO PARA FCM
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    final credentials = ServiceAccountCredentials.fromJson(serviceAccount);
    final clientAuthenticated = await clientViaServiceAccount(credentials, scopes);

    final accessToken =  clientAuthenticated.credentials.accessToken.data;

    clientAuthenticated.close();

    return accessToken;
  }

  @override
  Future<List<Chat>> getChatsByUser(int userID) async => await chatRepository.getChatsByUser(userID);

  @override
  Future<List<Chat>> getChatsBySupplier(int supplierID) async => await chatRepository.getChatsBySupplier(supplierID);
}