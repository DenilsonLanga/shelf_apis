import 'package:shelf_apis/app/models/supplier_service.dart';
import 'package:shelf_apis/app/models/supplier.dart';
import 'package:shelf_apis/dtos/supplier_nearby_dto.dart';
import 'package:shelf_apis/modules/user/view_model/update_supplier_input_model.dart';

abstract class ISupplierRepository {
Future<List<SupplierNearbyDto>> findSupplierNearBy(double lat, double lng, double distance);
Future<Supplier?> findSupplierById(int supplier);
Future<List<SupplierServices>?> findSupplierServices(int supplierId);
Future<bool> checkUserExists(String email);
Future<int> createSupplier(Supplier supplier);
Future<Supplier?> updateSupplier(UpdateSupplierInputModel model);
}