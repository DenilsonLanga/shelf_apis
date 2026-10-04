import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:mysql_client/exception.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shelf_apis/app/database/i_database_connection.dart';
import 'package:shelf_apis/app/exceptions/database_exception.dart';
import 'package:shelf_apis/app/logs/i_logger.dart';
import 'package:shelf_apis/app/models/schedule.dart';
import 'package:shelf_apis/app/models/supplier.dart';
import 'package:shelf_apis/app/models/supplier_service.dart';
import 'package:shelf_apis/modules/schedule/data/i_schedule_repository.dart';

@LazySingleton(as: IScheduleRepository)
class ScheduleRepository implements IScheduleRepository {
  final IDatabaseConnection connection;
  late MySQLConnectionPool? conn;
  final ILogger log;

  ScheduleRepository({required this.connection, required this.log});

  @override
  Future<void> saveSchedule(Schedule model) async {
    try {
      conn = await connection.openConnection();
      log.info('Conectado a base de dados com sucesso!');

      await conn?.transactional(
        (_) async {
          final res = await conn?.execute('''
            Insert into agendamento (data_agendamento,usuario_id,fornecedor_id,status,nome,nome_pet)
            values(:date,:user,:supplier,:status,:name,:pet)
    ''', {
            "date": model.scheduleDate.toIso8601String().replaceAll('T', ' ').substring(0, 23),
            "user": model.userId,
            "supplier": model.supplier.supplierId,
            "status": "P",
            "name": model.userName,
            "pet": model.petName
          });

          final scheduleId = res?.lastInsertID;

          for (var serviceID in model.services) {
            await conn?.execute(
                'insert into agendamento_servicos values(:scheduleID,:serviceID)',
                {"scheduleID": scheduleId, "serviceID": serviceID.id});
          }
        },
      );
    } on MySQLServerException catch (e) {
      log.error('Erro ao salvar um agendamento na base de dados', e);
      throw DatabaseException();
    }
  }

  @override
  Future<void> changeScheduleStatus(int scheduleId, String status) async {
    try {
      conn = await connection.openConnection();
      log.info('Base de dados conectada com sucesso');

      await conn?.execute(
          'update agendamento set status = :status where id = :schedulId',
          {"status": status, "schedulId": scheduleId});
    } on MySQLServerException catch (e) {
      log.error('Erro ao atualizar estado do agendamento!', e);
      throw DatabaseException();
    }
  }

  @override
  Future<List<Schedule>> getAllUserSchedullings(int userId) async {
    try {
      conn = await connection.openConnection();
      log.info('Conectado a base de dados!');

      final res = await conn?.execute('''
            SELECT a.*, f.id as supplier_id, f.nome as supplier_name, f.logo,
            JSON_ARRAYAGG(
              JSON_OBJECT(
                "id",fs.id,
                "service",fs.nome_servico,
                "price",fs.valor_servico
              )
            ) as services
             FROM agendamento a
            INNER JOIN fornecedor f on a.fornecedor_id = f.id
            INNER JOIN agendamento_servicos s on s.agendamento_id = a.id
            INNER JOIN fornecedor_servicos fs on fs.id = s.fornecedor_servicos_id
            Where a.usuario_id = :id
            GROUP BY a.id
    ''', {"id": userId});

      //final data = res?.rows.firstOrNull?.assoc();

      final scheduleData = res?.rows.map(
        (row) async {
          final data = row.assoc();
          final List<dynamic> services = jsonDecode(data['services']!);

          return Schedule(
              id: int.parse(data['id']!),
              scheduleDate: DateTime.parse(data['data_agendamento']!),
              userId: userId,
              status: data['status']!,
              userName: data['nome']!,
              petName: data['nome_pet']!,
              supplier: Supplier(
                supplierId: int.parse(data['supplier_id']!),
                logo: data['logo'],
                name: data['supplier_name'],
              ),
              services: services
                  .map(
                    (s) => SupplierServices(
                      id: s["id"],
                      supplierId: int.parse(data['supplier_id']!),
                      name: s["service"],
                      price: s["price"],
                    ),
                  )
                  .toList());
        },
      );

      return await Future.wait(scheduleData!);
    } on MySQLServerException catch (e) {
      log.error('Erro ao carregar agendamentos', e);
      throw DatabaseException();
    }
  }
  
  @override
  Future<List<Schedule>> getAllSupplierSchedullings(int supplierId) async{
    try {
      conn = await connection.openConnection();
      log.info('Conectado a base de dados!');

      final res = await conn?.execute('''
            SELECT a.*, f.id as supplier_id, f.nome as supplier_name, f.logo,
            JSON_ARRAYAGG(
              JSON_OBJECT(
                "id",fs.id,
                "service",fs.nome_servico,
                "price",fs.valor_servico
              )) as services
             FROM agendamento a
            INNER JOIN fornecedor f on a.fornecedor_id = f.id
            INNER JOIN agendamento_servicos s on s.agendamento_id = a.id
            INNER JOIN fornecedor_servicos fs on fs.id = s.fornecedor_servicos_id
            INNER JOIN usuario u ON u.fornecedor_id = f.id
            Where u.id = :id
            GROUP BY a.id
            
    ''', {"id": supplierId});

      //final data = res?.rows.firstOrNull?.assoc();

      final scheduleData = res?.rows.map(
        (row) async {
          final data = row.assoc();
          final List<dynamic> services = jsonDecode(data['services']!);

          return Schedule(
              id: int.parse(data['id']!),
              scheduleDate: DateTime.parse(data['data_agendamento']!),
              userId: supplierId,
              status: data['status']!,
              userName: data['nome']!,
              petName: data['nome_pet']!,
              supplier: Supplier(
                supplierId: int.parse(data['supplier_id']!),
                logo: data['logo'],
                name: data['supplier_name'],
              ),
              services: services
                  .map(
                    (s) => SupplierServices(
                      id: s["id"],
                      name: s["service"],
                      price: s["price"],
                    ),
                  )
                  .toList());
        },
      );

      return await Future.wait(scheduleData!);
    } on MySQLServerException catch (e) {
      log.error('Erro ao carregar agendamentos', e);
      throw DatabaseException();
    }
  }
}
