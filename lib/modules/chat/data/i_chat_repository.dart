import 'package:shelf_apis/app/models/chat.dart';
import 'package:shelf_apis/modules/chat/view_models/chat_model.dart';

abstract class IChatRepository {
Future<int?> startNewChat(int scheduleId);
Future<Chat> getChatById(ChatModel chat);
Future<List<Chat>> getChatsByUser(int userID);
Future<List<Chat>> getChatsBySupplier(int supplierID);
}