import 'package:shelf_apis/app/models/supplier_service.dart';
import 'package:shelf_apis/app/models/supplier.dart';
import 'package:shelf_apis/app/models/user.dart';
import 'package:shelf_apis/dtos/supplier_nearby_dto.dart';
import 'package:shelf_apis/modules/user/view_model/create_supplier_view_model.dart';
import 'package:shelf_apis/modules/user/view_model/update_supplier_input_model.dart';

abstract class ISupplierService {
Future<List<SupplierNearbyDto>> findSupplierNearBy(double lat, double lng);
Future<Supplier?> findSupplierById(int supplierId);
Future<List<SupplierServices>?> findSupplierServices(int supplierId);
Future<bool> checkUserExists(String email);
Future<User> createSupplier(CreateSupplierViewModel supplierModel);
Future<Supplier?> updateSupplier(UpdateSupplierInputModel model);
}