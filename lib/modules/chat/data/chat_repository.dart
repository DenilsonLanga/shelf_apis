import 'package:injectable/injectable.dart';
import 'package:mysql_client/exception.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shelf_apis/app/database/i_database_connection.dart';
import 'package:shelf_apis/app/exceptions/database_exception.dart';
import 'package:shelf_apis/app/logs/i_logger.dart';
import 'package:shelf_apis/app/models/chat.dart';
import 'package:shelf_apis/app/models/device_token.dart';
import 'package:shelf_apis/app/models/supplier.dart';
import 'package:shelf_apis/modules/chat/data/i_chat_repository.dart';
import 'package:shelf_apis/modules/chat/view_models/chat_model.dart';

@Injectable(as: IChatRepository)
class ChatRepository implements IChatRepository {
  final IDatabaseConnection connection;
  late MySQLConnectionPool? conn;
  final ILogger log;

  ChatRepository({required this.connection, required this.log});

  @override
  Future<int?> startNewChat(int scheduleId) async {
    conn = await connection.openConnection();
    log.info('Conectado a base de dados com sucesso!');

    try {
      final res = await conn?.execute(
          'insert into chats (agendamento_id, status, data_criacao) values (:agendamento,:status,:data)',
          {
            "agendamento": scheduleId,
            "status": 'A',
            "data": DateTime.now().toIso8601String()
          });

      return res?.lastInsertID.toInt();
    } on MySQLServerException catch (e) {
      log.error('Erro ao salvar um agendamento na base de dados', e);
      throw DatabaseException();
    }
  }

  @override
  Future<Chat> getChatById(ChatModel chat) async {
    conn = await connection.openConnection();
    log.info('Conectado a base de dados com sucesso!');

    try {
      final query = """
          select 
              c.id, c.data_criacao, c.status,

              a.usuario_id, a.fornecedor_id, a.nome, a.nome_pet,

              f.nome as fornec_name, f.logo,

              u.ios_token as ios_user_token,
              u.android_token as android_user_token,
              uf.ios_token as  ios_supplier_token,
              uf.android_token as android_supplier_token

          from chats as c
          inner join agendamento a on c.agendamento_id = a.id
          inner join fornecedor f on a.fornecedor_id = f.id
          inner join usuario u on u.id = a.usuario_id
          inner join usuario uf on uf.fornecedor_id = f.id

          where c.id = :id
        """;

      final res = await conn?.execute(query, {"id": chat.chatId});

      final chatData = res?.rows.first.assoc();

      if (chatData == null || chatData.isEmpty) {
        throw DatabaseException(msg: 'Erro ao procurar chat');
      }

      return Chat(
        id: int.parse(chatData['id']!),
        userId: int.parse(chatData['usuario_id']!),
        supplier: Supplier(supplierId: int.parse(chatData['fornecedor_id']!), logo: chatData['logo'], name: chatData['fornec_name']!),
        ownerName: chatData['nome']!,
        petName: chatData['nome_pet']!,
        status: chatData['status']!,
        userDeviceToken: DeviceToken(iosToken: chatData['ios_user_token'], androidToken: chatData['android_user_token']),
        supplierDeviceToken: DeviceToken(iosToken: chatData['ios_supplier_token'], androidToken: chatData['android_supplier_token']),
      );
    } on MySQLServerException catch (e) {
      log.error('Erro ao salvar um agendamento na base de dados', e);
      throw DatabaseException();
    }
  }

  @override
  Future<List<Chat>> getChatsByUser(int userID) async{

    conn = await connection.openConnection();
    log.info('Conectado a base de dados com sucesso!');

    final query = """
          select 
              c.id, c.data_criacao, c.status,

              a.usuario_id, a.fornecedor_id, a.nome, a.nome_pet,

              f.nome as fornec_name, f.logo

          from chats as c
          inner join agendamento a on c.agendamento_id = a.id
          inner join fornecedor f on a.fornecedor_id = f.id

          where a.usuario_id = :id

          order by c.data_criacao
        """;

    try {
      final res = await conn?.execute(query, {"id": userID});

      return res?.rows.map(
        (row) {
          final chatData = row.assoc();
          return Chat(
            id: int.parse(chatData['id']!),
            userId: int.parse(chatData['usuario_id']!),
            supplier: Supplier(supplierId: int.parse(chatData['fornecedor_id']!), logo: chatData['logo'], name: chatData['fornec_name']!),
            ownerName: chatData['nome']!,
            petName: chatData['nome_pet']!,
            status: chatData['status']!,
          );
        },
      ).toList() ?? [];
    } catch (e) {
      throw DatabaseException();
    }
  }

 @override
  Future<List<Chat>> getChatsBySupplier(int supplierID) async{

    conn = await connection.openConnection();
    log.info('Conectado a base de dados com sucesso!');

    final query = """
          select 
              c.id, c.data_criacao, c.status,

              a.usuario_id, a.fornecedor_id, a.nome, a.nome_pet,

              f.nome as fornec_name, f.logo

          from chats as c
          inner join agendamento a on c.agendamento_id = a.id
          inner join fornecedor f on a.fornecedor_id = f.id

          where a.fornecedor_id = :id

          order by c.data_criacao
        """;

    try {
      final res = await conn?.execute(query, {"id": supplierID});

      return res?.rows.map(
        (row) {
          final chatData = row.assoc();
          return Chat(
            id: int.parse(chatData['id']!),
            userId: int.parse(chatData['usuario_id']!),
            supplier: Supplier(supplierId: int.parse(chatData['fornecedor_id']!), logo: chatData['logo'], name: chatData['fornec_name']!),
            ownerName: chatData['nome']!,
            petName: chatData['nome_pet']!,
            status: chatData['status']!,
          );
        },
      ).toList() ?? [];
    } catch (e) {
      throw DatabaseException();
    }
  }

}
