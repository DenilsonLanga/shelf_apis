
import 'package:injectable/injectable.dart';
import 'package:shelf_apis/app/models/schedule.dart';
import 'package:shelf_apis/app/models/supplier.dart';
import 'package:shelf_apis/app/models/supplier_service.dart';
import 'package:shelf_apis/modules/schedule/data/i_schedule_repository.dart';
import 'package:shelf_apis/modules/schedule/service/i_schedule_service.dart';
import 'package:shelf_apis/modules/schedule/view_models/save_schedule_view_model.dart';

@Injectable(as: IScheduleService)
class ScheduleService implements IScheduleService{
  final IScheduleRepository scheduleRepository;

  ScheduleService({required this.scheduleRepository});

  @override
  Future<void> saveSchedule(SaveScheduleViewModel model) async{
    final schedule = Schedule(scheduleDate: model.scheduleDate, userId: model.userId, supplier: Supplier(supplierId: model.supplierId), status: 'P', userName: model.name, petName: model.petName, services: model.servicesID.map((id) => SupplierServices(id: id,),).toList());

    await scheduleRepository.saveSchedule(schedule);
  }

  @override
  Future<void> changeScheduleStatus(int scheduleId, String status)async{
    await scheduleRepository.changeScheduleStatus(scheduleId, status);
  }
  
  @override
  Future<List<Schedule>> getAllUserSchedullings(int userId) async {
    return await scheduleRepository.getAllUserSchedullings(userId);
  }
  
  @override
  Future<List<Schedule>> getAllSupplierSchedullings(int supplierId) async {
    return await scheduleRepository.getAllSupplierSchedullings(supplierId);
  }
}