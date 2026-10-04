
import 'package:shelf_apis/app/helpers/request_mapping.dart';

class UpdateSupplierInputModel extends RequestMapping{
  late String? name;
  late String? logo;
  late String? address;
  late String? cell;
  late double? lat;
  late double? lng;
  late int? categoryID;
  int supplierID;

  UpdateSupplierInputModel(super.dataRequest,{required this.supplierID,});

  @override
  void map() {
    name = data['supplier_name'];
    logo = data['logo'];
    address = data['address'];
    cell = data['cell'];
    lat = data['lat'];
    lng = data['lng'];
    categoryID = data['category_id'];
  }
  
}