
import 'package:injectable/injectable.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shelf_apis/app/database/i_database_connection.dart';
import 'package:shelf_apis/app/exceptions/database_exception.dart';
import 'package:shelf_apis/app/logs/i_logger.dart';
import 'package:shelf_apis/app/models/category.dart';
import 'package:shelf_apis/modules/category/data/i_category_repository.dart';

@LazySingleton(as: ICategoryRepository)
class CategoryRepository implements ICategoryRepository{

    final ILogger log;
    final IDatabaseConnection connection;
    MySQLConnectionPool? conn;
     List<Category> categorias = [];

  CategoryRepository({required this.log, required this.connection});

  @override
  Future<List<Category>> getCategories() async {
    try {
        conn = await connection.openConnection();
        log.info('Conexao aberta com sucesso');

        final res = await conn?.execute('SELECT * FROM categorias_fornecedor');

       return res?.rows.map((setCategoria){
          final categoria = setCategoria.assoc();
          return Category(id: int.tryParse(categoria['id']!)!, nomeCategoria: categoria['nome_categoria']!, tipoCategoria: categoria['tipo_categoria']!);
        }).toList() ?? [];

        //return categorias;
    } catch (e) {
      log.error('Erro ao recuperar categorias na base de dados',e);
      throw DatabaseException(msg: 'Erro ao recuperar categorias na base de dados');
    }
  }
  
}