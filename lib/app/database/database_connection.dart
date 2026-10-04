
import 'package:injectable/injectable.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shelf_apis/app/config/database_connection_configuration.dart';
import 'package:shelf_apis/app/database/i_database_connection.dart';



@LazySingleton(as: IDatabaseConnection)
class DatabaseConnection extends IDatabaseConnection {

  final DatabaseConnectionConfiguration dbConfig;

  DatabaseConnection({required this.dbConfig});

  @override
  Future<MySQLConnectionPool> openConnection() async{
   var pool =  MySQLConnectionPool(
  host: dbConfig.host, 
  port: dbConfig.port,
  userName: dbConfig.user,
  password: dbConfig.password,
  databaseName: dbConfig.dbName,
  maxConnections: 10
);

return pool;
  //var conn = await MySqlConnection.connect(settings);
  //return conn;
  }
  
}




// @LazySingleton(as: IDatabaseConnection)
// class DatabaseConnection extends IDatabaseConnection {

//   final DatabaseConnectionConfiguration dbConfig;

//   DatabaseConnection({required this.dbConfig});

//   @override
//   Future<MySqlConnection> openConnection() async{
//    var settings =  ConnectionSettings(
//   host: dbConfig.host, 
//   port: dbConfig.port,
//   user: dbConfig.user,
//   password: dbConfig.password,
//   db: dbConfig.dbName
// );
//   var conn = await MySqlConnection.connect(settings);
//   return conn;
//   }
  
// }