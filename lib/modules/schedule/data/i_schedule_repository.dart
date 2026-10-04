import 'package:shelf_apis/app/models/schedule.dart';

abstract class IScheduleRepository {
 Future<void> saveSchedule(Schedule model);
 Future<void> changeScheduleStatus(int scheduleId, String status);
 Future<List<Schedule>> getAllUserSchedullings(int userId);
 Future<List<Schedule>> getAllSupplierSchedullings(int supplierId);
}