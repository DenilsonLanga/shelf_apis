// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_controller.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$SupplierControllerRouter(SupplierController service) {
  final router = Router();
  router.add(
    'GET',
    r'/',
    service.find,
  );
  router.add(
    'GET',
    r'/<id|[0-9]+>',
    service.findSupplierById,
  );
  router.add(
    'GET',
    r'/<supplierId|[0-9]+>/services/',
    service.findSupplierServices,
  );
  router.add(
    'GET',
    r'/user',
    service.checkUserExists,
  );
  router.add(
    'POST',
    r'/user',
    service.createNewSupplier,
  );
  router.add(
    'PUT',
    r'/update',
    service.updateSupplierDetails,
  );
  return router;
}
