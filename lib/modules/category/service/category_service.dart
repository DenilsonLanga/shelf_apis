
import 'package:injectable/injectable.dart';
import 'package:shelf_apis/app/exceptions/database_exception.dart';
import 'package:shelf_apis/app/models/category.dart';
import 'package:shelf_apis/modules/category/data/i_category_repository.dart';
import 'package:shelf_apis/modules/category/service/i_category_service.dart';

@LazySingleton(as: ICategoryService)
class CategoryService implements ICategoryService{
  final ICategoryRepository categoriasRepository;

  CategoryService({required this.categoriasRepository});
  @override
  Future<List<Category>> getCategories() async{
    try {
     return await categoriasRepository.getCategories();
    } catch (e) {
      throw DatabaseException();
    }
  }
  
}