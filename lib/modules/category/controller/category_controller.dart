import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_apis/app/logs/i_logger.dart';
import 'package:shelf_apis/modules/category/service/i_category_service.dart';
import 'package:shelf_router/shelf_router.dart';

part 'category_controller.g.dart';

@Injectable()
class CategoryController {
    final ICategoryService categoryService;
    final ILogger log;

  
  CategoryController({required this.categoryService, required this.log});

  @Route.get('/')
  Future<Response> findCategory(Request request) async{
    try {
      final categories = await categoryService.getCategories();

      return Response.ok(jsonEncode(
        categories.map((category)=> 
        {"id":category.id,
          "nome_categoria" :category.nomeCategoria,
          "tipo_categoria" :category.tipoCategoria}
        ).toList()
      ),
  );
    } catch (e) {
      log.error('Error no contoller', e);
      return Response.internalServerError();
    }
  }

  Router get router => _$CategoryControllerRouter(this);
}