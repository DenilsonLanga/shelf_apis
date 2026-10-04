import 'package:shelf_apis/app/models/category.dart';

abstract class ICategoryRepository {
Future<List<Category>> getCategories();
}