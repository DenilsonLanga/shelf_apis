import 'package:shelf_apis/app/models/schedule.dart';
import 'package:shelf_apis/modules/schedule/view_models/save_schedule_view_model.dart';

abstract class IScheduleService {
Future<void> saveSchedule(SaveScheduleViewModel model);
Future<void> changeScheduleStatus(int scheduleId, String status);
Future<List<Schedule>> getAllUserSchedullings(int userId);
Future<List<Schedule>> getAllSupplierSchedullings(int supplierId);
}