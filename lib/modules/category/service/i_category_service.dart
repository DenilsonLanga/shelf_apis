import 'package:shelf_apis/app/models/category.dart';

abstract class ICategoryService {
Future<List<Category>> getCategories();
}