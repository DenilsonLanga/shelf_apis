
import 'package:shelf_apis/app/helpers/request_mapping.dart';

class ChatModel extends RequestMapping{

  late int chatId;
  late String message;
  late String senderType;

  ChatModel(super.dataRequest);

  @override
  void map() {
   chatId = data['chat_id'];
  message = data['message'];
 // senderType = '';
  }
  
}