// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dotenv/dotenv.dart' as _i320;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../modules/category/controller/category_controller.dart' as _i679;
import '../../modules/category/data/category_repository.dart' as _i614;
import '../../modules/category/data/i_category_repository.dart' as _i354;
import '../../modules/category/service/category_service.dart' as _i597;
import '../../modules/category/service/i_category_service.dart' as _i300;
import '../../modules/chat/controller/chat_controller.dart' as _i194;
import '../../modules/chat/data/chat_repository.dart' as _i199;
import '../../modules/chat/data/i_chat_repository.dart' as _i216;
import '../../modules/chat/service/chat_service.dart' as _i51;
import '../../modules/chat/service/i_chat_service.dart' as _i189;
import '../../modules/fornecedor/controller/supplier_controller.dart' as _i695;
import '../../modules/fornecedor/data/i_supplier_repository.dart' as _i356;
import '../../modules/fornecedor/data/supplier_repository.dart' as _i373;
import '../../modules/fornecedor/service/i_supplier_service.dart' as _i1071;
import '../../modules/fornecedor/service/supplier_service.dart' as _i1010;
import '../../modules/schedule/controller/schedule_controller.dart' as _i1044;
import '../../modules/schedule/data/i_schedule_repository.dart' as _i154;
import '../../modules/schedule/data/schedule_repository.dart' as _i214;
import '../../modules/schedule/service/i_schedule_service.dart' as _i513;
import '../../modules/schedule/service/schedule_service.dart' as _i512;
import '../../modules/teste_module/teste_controller.dart' as _i98;
import '../../modules/user/controller/auth_controller.dart' as _i477;
import '../../modules/user/controller/user_controller.dart' as _i983;
import '../../modules/user/data/i_user_repository.dart' as _i872;
import '../../modules/user/data/user_repository.dart' as _i755;
import '../../modules/user/service/i_user_service.dart' as _i610;
import '../../modules/user/service/user_service.dart' as _i457;
import '../database/database_connection.dart' as _i396;
import '../database/i_database_connection.dart' as _i77;
import '../logs/i_logger.dart' as _i356;
import '../logs/logger.dart' as _i861;
import 'database_connection_configuration.dart' as _i32;
import 'register_env.dart' as _i165;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerEnv = _$RegisterEnv();
    await gh.factoryAsync<_i320.DotEnv>(
      () => registerEnv.dotEnv,
      preResolve: true,
    );
    gh.factory<_i98.TesteController>(() => _i98.TesteController());
    gh.lazySingleton<_i356.ILogger>(() => _i861.Logger());
    gh.singleton<_i32.DatabaseConnectionConfiguration>(
        () => registerEnv.dbConfig(gh<_i320.DotEnv>()));
    gh.lazySingleton<_i77.IDatabaseConnection>(() => _i396.DatabaseConnection(
        dbConfig: gh<_i32.DatabaseConnectionConfiguration>()));
    gh.lazySingleton<_i356.ISupplierRepository>(() => _i373.SupplierRepository(
          connection: gh<_i77.IDatabaseConnection>(),
          log: gh<_i356.ILogger>(),
        ));
    gh.lazySingleton<_i154.IScheduleRepository>(() => _i214.ScheduleRepository(
          connection: gh<_i77.IDatabaseConnection>(),
          log: gh<_i356.ILogger>(),
        ));
    gh.lazySingleton<_i354.ICategoryRepository>(() => _i614.CategoryRepository(
          log: gh<_i356.ILogger>(),
          connection: gh<_i77.IDatabaseConnection>(),
        ));
    gh.lazySingleton<_i872.IUserRepository>(() => _i755.UserRepository(
          connection: gh<_i77.IDatabaseConnection>(),
          log: gh<_i356.ILogger>(),
        ));
    gh.factory<_i513.IScheduleService>(() => _i512.ScheduleService(
        scheduleRepository: gh<_i154.IScheduleRepository>()));
    gh.factory<_i216.IChatRepository>(() => _i199.ChatRepository(
          connection: gh<_i77.IDatabaseConnection>(),
          log: gh<_i356.ILogger>(),
        ));
    gh.factory<_i189.IChatService>(() => _i51.ChatService(
          chatRepository: gh<_i216.IChatRepository>(),
          log: gh<_i356.ILogger>(),
        ));
    gh.factory<_i194.ChatController>(() => _i194.ChatController(
          chatService: gh<_i189.IChatService>(),
          logger: gh<_i356.ILogger>(),
        ));
    gh.factory<_i1044.ScheduleController>(() => _i1044.ScheduleController(
          scheduleService: gh<_i513.IScheduleService>(),
          log: gh<_i356.ILogger>(),
        ));
    gh.lazySingleton<_i300.ICategoryService>(() => _i597.CategoryService(
        categoriasRepository: gh<_i354.ICategoryRepository>()));
    gh.lazySingleton<_i610.IUserService>(() => _i457.UserService(
          userRepository: gh<_i872.IUserRepository>(),
          log: gh<_i356.ILogger>(),
        ));
    gh.factory<_i477.AuthController>(() => _i477.AuthController(
          gh<_i356.ILogger>(),
          userService: gh<_i610.IUserService>(),
        ));
    gh.factory<_i679.CategoryController>(() => _i679.CategoryController(
          categoryService: gh<_i300.ICategoryService>(),
          log: gh<_i356.ILogger>(),
        ));
    gh.lazySingleton<_i1071.ISupplierService>(() => _i1010.SupplierService(
          userService: gh<_i610.IUserService>(),
          supplierRepository: gh<_i356.ISupplierRepository>(),
        ));
    gh.factory<_i983.UserController>(() => _i983.UserController(
          userService: gh<_i610.IUserService>(),
          log: gh<_i356.ILogger>(),
        ));
    gh.factory<_i695.SupplierController>(() => _i695.SupplierController(
          supplierService: gh<_i1071.ISupplierService>(),
          log: gh<_i356.ILogger>(),
        ));
    return this;
  }
}

class _$RegisterEnv extends _i165.RegisterEnv {}
