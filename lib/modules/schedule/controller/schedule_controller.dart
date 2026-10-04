
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_apis/app/logs/i_logger.dart';
import 'package:shelf_apis/modules/schedule/service/i_schedule_service.dart';
import 'package:shelf_apis/modules/schedule/view_models/save_schedule_view_model.dart';
import 'package:shelf_router/shelf_router.dart';

part 'schedule_controller.g.dart';

@injectable
class ScheduleController {
  final IScheduleService scheduleService;
  final ILogger log;

  ScheduleController({required this.scheduleService, required this.log});

  @Route.post('/')
  Future<Response> saveSchedule(Request request) async{
    try {
  final userId = int.tryParse(request.headers['user']??'');
  if(userId==null){
    return Response.badRequest(body: 'Para efeturar a operacao desejada e necessario fornecer o Id do utilizador!');
  }
  
  final model = SaveScheduleViewModel(await request.readAsString(), userId: userId);
  await scheduleService.saveSchedule(model);
  return Response.ok('');

} on Exception catch (e) {
  log.error('Erro na controller ao tentar salvar agendamento',e);
  return Response.internalServerError();
}

  }

  @Route.put('/<scheduleID|[0-9]+>/status/<status>')
  Future<Response> changeScheduleStatus(Request request, String scheduleID, String status) async{
    try {
      final id = int.tryParse(scheduleID);
      if(id == null){
        return Response.badRequest(body: 'O id do agendamento nao pode ser nulo');
      }
      await scheduleService.changeScheduleStatus(id, status);
      return Response.ok('Estado do agendamento alterdo para $status');

    } catch (e) {
      log.error('Erro na controller ao tentar atualizar o status do agendamento',e);
      return Response.internalServerError();
    }
  }

  @Route.get('/')
  Future<Response> getAllUserSchedullings(Request request) async{
    try {
      final userId = int.tryParse(request.headers['user']!);
      if(userId == null){
        return Response.badRequest(body: 'Id do utilizador nao pode ser nulo!');
      }

      final scheduleData = await scheduleService.getAllUserSchedullings(userId);

      return Response.ok(
        jsonEncode(
          scheduleData.map((s) => 
          {
            "id": s.id,
            "schedule_date": s.scheduleDate.toString(),
            "name": s.userName,
            "pet_name": s.petName,
            "status": s.status,
            "supplier": {
              "id": s.supplier.supplierId,
              "supplier_name": s.supplier.name,
              "logo":s.supplier.logo
            },
            "services": s.services.map((s) => {
              "id": s.id,
              "supplier_id": s.supplierId,
              "name":s.name,
              "price": s.price
            },).toList()
          }
          ,).toList()

        )
      );
      
    } on Exception catch (e) {
      log.error('Erro na controller ao tentar recuperar agendamentos',e);
      return Response.internalServerError();
    }
  }
  @Route.get('/supplier')
  Future<Response> getAllSupplierSchedullings(Request request) async{
    try {
      final supplierId = int.tryParse(request.headers['user']!);
      if(supplierId == null){
        return Response.badRequest(body: 'Id do fornecedor não pode ser nulo!');
      }

      final scheduleData = await scheduleService.getAllSupplierSchedullings(supplierId);

      return Response.ok(
        jsonEncode(
          scheduleData.map((s) => 
          {
            "id": s.id,
            "schedule_date": s.scheduleDate.toString(),
            "name": s.userName,
            "pet_name": s.petName,
            "status": s.status,
            "supplier": {
              "id": s.supplier.supplierId,
              "supplier_name": s.supplier.name,
              "logo":s.supplier.logo
            },
            "services": s.services.map((s) => {
              "id": s.id,
              "name":s.name,
              "price": s.price
            },).toList()
          }
          ,).toList()

        )
      );
      
    } on Exception catch (e) {
      log.error('Erro na controller ao tentar recuperar agendamentos',e);
      return Response.internalServerError();
    }
  }

  Router get router => _$ScheduleControllerRouter(this);

}