import 'package:injectable/injectable.dart';
import 'package:shelf_apis/app/models/category.dart';
import 'package:shelf_apis/app/models/supplier_service.dart';
import 'package:shelf_apis/app/models/supplier.dart';
import 'package:shelf_apis/app/models/user.dart';
import 'package:shelf_apis/dtos/supplier_nearby_dto.dart';
import 'package:shelf_apis/modules/fornecedor/data/i_supplier_repository.dart';
import 'package:shelf_apis/modules/fornecedor/service/i_supplier_service.dart';
import 'package:shelf_apis/modules/user/service/i_user_service.dart';
import 'package:shelf_apis/modules/user/view_model/create_supplier_view_model.dart';
import 'package:shelf_apis/modules/user/view_model/update_supplier_input_model.dart';
import 'package:shelf_apis/modules/user/view_model/user_save_input_model.dart';

@LazySingleton(as: ISupplierService)
class SupplierService implements ISupplierService {
  final ISupplierRepository supplierRepository;
  final IUserService userService;
  static const distance = 5.0;

  SupplierService({required this.userService, required this.supplierRepository});

  @override
  Future<List<SupplierNearbyDto>> findSupplierNearBy(
      double lat, double lng) async {
    return await supplierRepository.findSupplierNearBy(lat, lng, distance);
  }

  @override
  Future<Supplier?> findSupplierById(int supplierId) async {
    return await supplierRepository.findSupplierById(supplierId);
  }

  @override
  Future<List<SupplierServices>?> findSupplierServices(int supplierId) =>
      supplierRepository.findSupplierServices(supplierId);

  @override
  Future<bool> checkUserExists(String email) =>
      supplierRepository.checkUserExists(email);

  @override
  Future<User> createSupplier(CreateSupplierViewModel supplierModel) async {
    final supplierId = await supplierRepository.createSupplier(Supplier(
      name: supplierModel.supplierName,
      category: Category(id: supplierModel.categoryID),
    ));

    final user = UserSaveInputModel(supplierId: supplierId, email: supplierModel.email, password: supplierModel.password);

    final userData = await userService.createUser(user);

    return userData.copyWith(senha: null);
  }

  @override
  Future<Supplier?> updateSupplier(UpdateSupplierInputModel model)async {
    return await supplierRepository.updateSupplier(model);
  }
}
