
import 'package:shelf_apis/app/models/device_token.dart';
import 'package:shelf_apis/app/models/supplier.dart';

class Chat {
  final int id;
  final int userId;
  final Supplier supplier;
  final String ownerName;
  final String petName;
  final String status;
  final DeviceToken? userDeviceToken;
  final DeviceToken? supplierDeviceToken;

  Chat({required this.id, required this.userId, required this.supplier, required this.ownerName, required this.petName, required this.status,  this.userDeviceToken,  this.supplierDeviceToken});
}