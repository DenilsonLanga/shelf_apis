
import 'package:dotenv/dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf_apis/app/config/database_connection_configuration.dart';
import 'package:shelf_apis/app/config/service_locator.dart';

@module
abstract class RegisterEnv {
  @preResolve
  Future<DotEnv> get dotEnv async => DotEnv(includePlatformEnvironment: false)..load(['.env']);

  @singleton
  DatabaseConnectionConfiguration  dbConfig (DotEnv env) {
    //final env =  getIt.get<DotEnv>();
    return DatabaseConnectionConfiguration(
      host: env['databaseHost']!,
      user: env['databaseUser']!,
      password: env['databasePassword']!,
      port: int.tryParse(env['databasePort']!)!,
      dbName: env['databaseName']!,
    );
  }
    
  }

