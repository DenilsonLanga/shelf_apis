import 'package:dotenv/dotenv.dart';
import 'package:shelf_apis/app/logs/logger.dart';
import 'package:shelf_apis/modules/main_router.dart';
import 'package:shelf_router/shelf_router.dart';
import 'service_locator.dart';

class AppConfig {
  
  late DotEnv env;
  Future<void> loadAppConfig(Router router) async {
     //env = await _loadEnv();
     await configureDependencies();  
     env =  getIt.get<DotEnv>();
     Logger();
     MainRouter(router: router).routerConfigure();
  }

// @singleton
//   Future<DotEnv> _loadEnv() async =>
//       DotEnv(includePlatformEnvironment: false)..load();


}
