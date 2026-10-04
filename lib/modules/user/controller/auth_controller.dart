
import 'dart:convert';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_apis/app/exceptions/database_exception.dart';
import 'package:shelf_apis/app/exceptions/user_exists_exception.dart';
import 'package:shelf_apis/app/exceptions/user_not_found_exception.dart';
import 'package:shelf_apis/app/helpers/jwt_helper.dart';
import 'package:shelf_apis/app/logs/i_logger.dart';
import 'package:shelf_apis/app/models/user.dart';
import 'package:shelf_apis/modules/user/service/i_user_service.dart';
import 'package:shelf_apis/modules/user/view_model/confirm_login_view_model.dart';
import 'package:shelf_apis/modules/user/view_model/login_view_model.dart';
import 'package:shelf_apis/modules/user/view_model/refresh_token_input.dart';
import 'package:shelf_apis/modules/user/view_model/user_save_input_model.dart';
import 'package:shelf_router/shelf_router.dart';
part 'auth_controller.g.dart';

@Injectable()
class AuthController {

  final IUserService userService;
  final ILogger log;
  AuthController(this.log, {required this.userService});

  @Route.post('/')
  Future<Response> login(Request request) async{
    try {
      final loginViewModel = LoginViewModel(await request.readAsString());

      User userData;
      if(!loginViewModel.isSocialLogin!){
        userData = await userService.login(loginViewModel.email!, loginViewModel.password!, loginViewModel.isSupplier!);
      } else{
        userData = await userService.loginWithSocial(loginViewModel.email!, loginViewModel.avatar!, loginViewModel.socialType!, loginViewModel.socialKey!);
      }
      
      final jwtToken = JwtHelper.generateAccessToke(userData.id!, userData.supplierId);

      return Response.ok(jsonEncode({'access_token': 'Bearer $jwtToken'}), headers: {HttpHeaders.authorizationHeader:'Bearer $jwtToken'});

} on UserNotFoundException {
  return Response.notFound(jsonEncode({'Message': 'Usuario não cadastrado, faça o seu registro primeiro.'}));
}on DatabaseException {
  return Response.badRequest(body: jsonEncode({'Message': 'Password incorrecta, tente novamente.'}));
}
 catch (e) {
  log.error('Erro interno',e);
  return Response.internalServerError(body: 'Erro interno');
}
  }

  @Route.post('/register')
  Future<Response> saveUser(Request request) async{ 
    try {
      final userInputModel = UserSaveInputModel.mapping(await request.readAsString());
      await userService.createUser(userInputModel);
      return Response.ok(jsonEncode({'Message': 'Cadastro realizado com sucesso'}));

} on UserExistsException {
  return Response.badRequest(body: jsonEncode({'message': 'Usuario já cadastrado'}));
}
 catch (e) {
  log.error('Erro ao cadastrar o usuario',e);
  return Response.internalServerError(body: 'Big error');
}
  }

@Route('PATCH', '/confirm')
Future<Response> confirmLogin(Request request) async{

  try {
    final userId = int.tryParse(request.headers['user']!)!;
    final supplierId = int.tryParse(request.headers['supplier'] ?? '');

    final newAccessToken = JwtHelper.generateAccessToke(userId, supplierId).replaceAll('Bearer ', '');
    final confirmModel = ConfirmLoginViewModel(await request.readAsString(), userId, newAccessToken);

    final refreshToken = await userService.confirmLogin(confirmModel);

  return Response.ok(jsonEncode({
    'access_token': 'Bearer $newAccessToken',
    'refresh_token': 'Bearer $refreshToken'
  }));

} on Exception  {
  return Response.internalServerError(body: 'Erro interno! Nao foi possivel confirmar o seu login, tente efetuar login novamente!');
}
}

@Route.put('/refresh')
Future<Response> refreshToken(Request request) async {
  try {
  final userId = int.tryParse(request.headers['user']!)!;
  final supplier = int.tryParse(request.headers['supplier'] ?? '');
  final accessToken = request.headers['access_token'];
  
  final refreshTokenInput = RefreshTokenInput(await request.readAsString(), userId: userId, supplier: supplier, accessToken: accessToken);
  final tokens = await userService.refreshToken(refreshTokenInput);

  return Response.ok(jsonEncode({
    'access_token': 'Bearer ${tokens.accessToken}',
    'refresh_token': 'Bearer ${tokens.refreshToken}'
  }));
} on Exception catch (e) {
  return Response.internalServerError(body: {'Erro': 'Internal server error $e'});
}
}

 @Route.delete('/delete')
 Future<Response> deleteIncompletedUser(Request request) async{
  try {
      final userInputModel = UserSaveInputModel.mapping(await request.readAsString());
      await userService.deleteIncompletedUser(userInputModel);
      return Response.ok(jsonEncode({'Message': 'Usuario Eliminado!'}));

} on DatabaseException {
  return Response.badRequest(body: jsonEncode({'message': 'Erro ao remover usuario da base de dados'}));
} on UserNotFoundException{
  return Response.badRequest(body: jsonEncode({'message': 'Usuario nao encontrado'}));
}
 catch (e) {
  log.error('Erro na base de dados ou no codigo SQL',e);
  return Response.internalServerError(body: 'Big error');
}
 }

  Router get router => _$AuthControllerRouter(this);
}