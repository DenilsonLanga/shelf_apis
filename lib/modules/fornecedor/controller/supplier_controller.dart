
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_apis/app/logs/i_logger.dart';
import 'package:shelf_apis/app/models/supplier.dart';
import 'package:shelf_apis/modules/fornecedor/service/i_supplier_service.dart';
import 'package:shelf_apis/modules/user/view_model/create_supplier_view_model.dart';
import 'package:shelf_apis/modules/user/view_model/update_supplier_input_model.dart';
import 'package:shelf_router/shelf_router.dart';

part 'supplier_controller.g.dart';

@injectable
class SupplierController {
  
  final ISupplierService supplierService;
  final ILogger log;

  SupplierController({required this.supplierService, required this.log});

  @Route.get('/')
  Future<Response> find(Request request) async{
    try {
      final lat = double.tryParse(request.url.queryParameters['lat']!)!;
      final lng = double.tryParse(request.url.queryParameters['lng']!)!;

      final data = await supplierService.findSupplierNearBy(lat, lng);

      return Response.ok(
        jsonEncode(
          data.map((supplier) {
          return {
        "id": supplier.id,
        "nome": supplier.nome,
        "logo": supplier.logo,
        "distancia":supplier.distancia,
        "category_id": supplier.categoryId,
      };
        },).toList()
        )
      );
    } catch (e) {
      log.error('error',e);
      return Response.internalServerError(body: e);
    }
  }

  @Route.get('/<id|[0-9]+>')
  Future<Response> findSupplierById(Request request, String id) async{
    try {

      final supplier = await supplierService.findSupplierById(int.parse(id));

      if(supplier == null){
        return Response.notFound("Fornecedor nao encontrado");
      }
      
      return Response.ok(_supplierMapper(supplier));

    } catch (e) {
      log.error('Erro no controller',e);
      return Response.internalServerError(body: 'internal server error');
    }
  }

  @Route.get('/<supplierId|[0-9]+>/services/')
  Future<Response> findSupplierServices(Request request, String supplierId) async{
    try {
      final services = await supplierService.findSupplierServices(int.parse(supplierId));

      if(services == null){
        return Response.notModified(context:{'Message': 'No Services to be displayed'});
      }

      return Response.ok(jsonEncode(
        services.map((service) =>{
          "id": service.id,
          "supplier_id": service.supplierId,
          "name": service.name,
          "price": service.price
        },).toList()
      ));
    } catch (e) {
      log.error('Erro na controller');
      return Response.internalServerError();
    }
  }

  @Route.get('/user')
  Future<Response> checkUserExists(Request request) async{
    try {
      final email = request.url.queryParameters['email'];
      if(email ==  null || email.isEmpty){
        return Response(400, body: {'Message':'Email obrigatorio'});
      }
      final userExists = await supplierService.checkUserExists(email);

      return userExists ? Response.ok(jsonEncode({'exists': true})) : Response.ok(jsonEncode({'exists': false}));

    } catch (e) {
      log.error('Erro no controller',e);
      return Response.internalServerError();
    }
  }

  @Route.post('/user')
  Future<Response> createNewSupplier(Request request) async{
    try {
      final supplierModel = CreateSupplierViewModel(await request.readAsString());
      final data = await supplierService.createSupplier(supplierModel);

      return Response.ok(jsonEncode({
        "email": data.email,
        "imgAvatarUrl": data.imgAvatarUrl,
        "registerType": data.registerType,
      }));

    } catch (e) {
      log.error('Erro na controller',e);
      return Response.internalServerError();
    }
  }
  
  @Route.put('/update')
  Future<Response> updateSupplierDetails(Request request) async{
    try {
      final supplierID = int.tryParse(request.headers['supplier']!);

      if(supplierID == null){
        return Response.badRequest(body: 'O id do usuario nao pode ser nulo');
      }

      final model = UpdateSupplierInputModel(await request.readAsString(), supplierID: supplierID);
      final supplier = await supplierService.updateSupplier(model);

      return Response.ok(_supplierMapper(supplier!));
    } catch (e) {
      log.error('Erro na controller',e);
      return Response.internalServerError();
    }
  }

  String _supplierMapper(Supplier supplier) {
    return jsonEncode({
      "supplierId": supplier.supplierId,
        "name": supplier.name,
        "logo": supplier.logo,
        "address": supplier.address,
        "cell": supplier.cell,
        "lat": supplier.lat,
        "lng": supplier.lng,
        "category":{
          "id": supplier.category?.id,
          "nome_categoria": supplier.category?.nomeCategoria,
          "tipo_categoria": supplier.category?.tipoCategoria,
        }
    });
  }

  Router get router => _$SupplierControllerRouter(this);
}

