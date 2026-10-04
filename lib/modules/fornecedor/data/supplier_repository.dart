import 'package:injectable/injectable.dart';
import 'package:mysql_client/exception.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shelf_apis/app/database/i_database_connection.dart';
import 'package:shelf_apis/app/exceptions/database_exception.dart';
import 'package:shelf_apis/app/logs/i_logger.dart';
import 'package:shelf_apis/app/models/category.dart';
import 'package:shelf_apis/app/models/supplier_service.dart';
import 'package:shelf_apis/app/models/supplier.dart';
import 'package:shelf_apis/dtos/supplier_nearby_dto.dart';
import 'package:shelf_apis/modules/fornecedor/data/i_supplier_repository.dart';
import 'package:shelf_apis/modules/user/view_model/update_supplier_input_model.dart';

@LazySingleton(as: ISupplierRepository)
class SupplierRepository implements ISupplierRepository {
  final IDatabaseConnection connection;
  final ILogger log;
  MySQLConnectionPool? conn;

  SupplierRepository({required this.connection, required this.log});

  @override
  Future<List<SupplierNearbyDto>> findSupplierNearBy(
      double lat, double lng, double distance) async {
    try {
      conn = await connection.openConnection();
      log.info('Connection opened successfully');

      final query = '''
          SELECT f.id, f.nome, f.logo, f.categorias_fornecedor_id,

          (6371 * acos(
          (sin(radians($lat))*sin(radians(ST_X(f.latlng)))) + 
          (cos(radians($lat))*cos(radians(ST_X(f.latlng)))*cos(radians($lng) - radians(ST_Y(f.latlng))))
          )) AS distancia
          
           FROM fornecedor f
           HAVING distancia <= $distance
        ''';

      final res = await conn?.execute(query);

      return res?.rows.map(
            (row) {
              final supplier = row.assoc();
              return SupplierNearbyDto(
                  id: int.tryParse(supplier['id']!)!,
                  nome: supplier['nome']!,
                  logo: supplier['logo'],
                  distancia: double.tryParse(supplier['distancia']!)!,
                  categoryId:
                      int.tryParse(supplier['categorias_fornecedor_id']!)!);
            },
          ).toList() ??
          [];
    } catch (e) {
      log.error('Erro ao procurar fornecedor nas proximidades', e);
      throw DatabaseException();
    }
  }

  @override
  Future<Supplier?> findSupplierById(int supplierId) async {
    try {
      conn = await connection.openConnection();
      log.info('conexao feita com sucesso');

      final query = '''
        SELECT f.id, f.nome, f.logo, f.endereco, f.telefone, ST_X(f.latlng) as lat, ST_Y(f.latlng) as lng, f.categorias_fornecedor_id, c.nome_categoria, c.tipo_categoria
        FROM fornecedor f
        INNER JOIN categorias_fornecedor c ON (f.categorias_fornecedor_id = c.id)
        WHERE f.id = :id
    ''';

      final res = await conn?.execute(query, {"id": supplierId});

      final supplier = res?.rows.firstOrNull?.assoc();

      if (supplier == null || supplier.isEmpty) {
        throw DatabaseException(msg: 'Erro ao procurar fornecedor por ID');
      }
      
      return Supplier(
        supplierId: int.tryParse(supplier['id']!)!,
        name: supplier['nome']!,
        logo: supplier['logo']!,
        address: supplier['endereco']!,
        cell: supplier['telefone']!,
        lat: double.tryParse(supplier['lat']!)!,
        lng: double.tryParse(supplier['lng']!)!,
        category: Category(
          id: int.tryParse(supplier['categorias_fornecedor_id']!)!,
          nomeCategoria: supplier['nome_categoria']!,
          tipoCategoria: supplier['tipo_categoria']!,
        ),
      );
    } on DatabaseException catch (e) {
      log.error('Erro ao procurar fornecedor por ID', e);
      rethrow;
    }
  }

  @override
  Future<List<SupplierServices>?> findSupplierServices(int supplierId) async {
    try {
      conn = await connection.openConnection();
      log.info('Conexao com benco de dados aberta com sucesso');

      final res = await conn?.execute(
          'SELECT * FROM fornecedor_servicos WHERE fornecedor_id = :id',
          {"id": supplierId});

      return res?.rows.map(
        (rows) {
          final service = rows.assoc();
         return SupplierServices(
            id: int.parse(service['id']!),
            supplierId: int.parse(service['fornecedor_id']!),
            name: service['nome_servico'],
            price: double.parse(service['valor_servico']!),
          );
        },
      ).toList();
    } on MySQLServerException catch (e) {
      log.error('Erro ao recuperar servicos do fornecedor $supplierId', e);
      throw DatabaseException(
          msg: 'Erro ao recuperar servicos do fornecedor $supplierId');
    }
  }
  
  @override
  Future<bool> checkUserExists(String email) async{
    try {
      conn = await connection.openConnection();
      log.info('Conexao aberta com sucesso!');

      final res = await  conn?.execute('SELECT * FROM usuario WHERE email = :email',{"email":email});

      final userData = res?.rows.firstOrNull;

      if(userData == null){
        return false;
      }
      return true;

    } on MySQLServerException catch (e) {
      log.error('Erro ao verificar se o email existe na base de dados',e);
      throw DatabaseException();
    }
  }
  
  @override
  Future<int> createSupplier(Supplier supplier) async{
    try {
      conn = await connection.openConnection();
      log.info('Database connection opened successfully!');

      final res = await conn?.execute('INSERT INTO fornecedor (nome,categorias_fornecedor_id) values(:nome,:categoriaID)',
      {
      "nome":supplier.name,
      "categoriaID":supplier.category?.id
      });

      final userId = res?.firstOrNull?.lastInsertID.toInt();

      if(userId == null){
        log.error('Ocorreu um erro com o connector mysql');
        throw DatabaseException();
      }

      return userId;
      
    }on MySQLServerException catch (e) {
      log.error('Erro ao salvar novo fornecedor',e);
      throw DatabaseException();
    }
  }

  @override
  Future<Supplier?> updateSupplier(UpdateSupplierInputModel model) async{
    try {
      conn = await connection.openConnection();
      log.info('Database connection opened successfully');

      final res = await conn?.execute('''
        update fornecedor set nome = :nome, logo = :logo, endereco = :endereco, 
        telefone = :telefone, latlng = ST_GeomFromText(:point), categorias_fornecedor_id = :categoriaId

        WHERE id = :supplierID
''',{
  "nome":model.name,
  "logo":model.logo,
  "endereco": model.address,
  "telefone":model.cell,
  "point": "POINT(${model.lng} ${model.lat})",
  "categoriaId":model.categoryID,
  "supplierID":model.supplierID
});

    if(res?.affectedRows.toInt() == 0){
      log.error('Erro ao efetuar atualizacao do supplier');
      throw DatabaseException();
    }

    return await findSupplierById(model.supplierID);
      
    } on Exception catch (e) {
      log.error('Erro ao efetuar atualizacao do supplier',e);
      throw DatabaseException(msg: 'Erro ao efetuar atualizacao do supplier', exception: e);
    }
  }
}
