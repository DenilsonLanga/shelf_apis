// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_controller.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$ScheduleControllerRouter(ScheduleController service) {
  final router = Router();
  router.add(
    'POST',
    r'/',
    service.saveSchedule,
  );
  router.add(
    'PUT',
    r'/<scheduleID|[0-9]+>/status/<status>',
    service.changeScheduleStatus,
  );
  router.add(
    'GET',
    r'/',
    service.getAllUserSchedullings,
  );
  router.add(
    'GET',
    r'/supplier',
    service.getAllSupplierSchedullings,
  );
  return router;
}
