
import 'package:shelf_apis/app/models/category.dart';

class Supplier {
  final int? supplierId;
  final String? name;
  final String? logo;
  final String? address;
  final String? cell;
  final double? lat;
  final double? lng;
  final Category? category;

  Supplier({ this.supplierId,  this.name,  this.logo,  this.address,  this.cell,  this.lat,  this.lng,  this.category});
}