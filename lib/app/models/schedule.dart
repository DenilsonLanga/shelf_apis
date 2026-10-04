
import 'package:shelf_apis/app/models/supplier.dart';
import 'package:shelf_apis/app/models/supplier_service.dart';

class Schedule {
  final int? id;
  final DateTime scheduleDate;
  final int userId;
  final Supplier supplier;
  final String status;
  final String userName;
  final String petName;
  final List<SupplierServices> services;

  Schedule({ this.id, required this.scheduleDate, required this.userId, required this.supplier, required this.status, required this.userName, required this.petName, required this.services});
}