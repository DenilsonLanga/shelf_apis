import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_apis/app/logs/i_logger.dart';
import 'package:shelf_apis/modules/user/service/i_user_service.dart';
import 'package:shelf_apis/modules/user/view_model/device_token_view_model.dart';
import 'package:shelf_apis/modules/user/view_model/url_avatar_view_model.dart';
import 'package:shelf_router/shelf_router.dart';

part 'user_controller.g.dart';

@injectable
class UserController {
  final IUserService userService;
  final ILogger log;

  UserController({required this.userService, required this.log});

   @Route.get('/')
   Future<Response> findByToken(Request request) async { 
      try {
        final userId = request.headers['user'];
        final user = await userService.findUserById(int.tryParse(userId!)!);
        return Response.ok(jsonEncode({
        "email": user.email,
        "imgAvatarUrl": user.imgAvatarUrl,
        "registerType": user.registerType,
        }));
        
      } catch (e) {
        log.error('Erro ao buscar dados do utilizador!');
        return Response.internalServerError(body: {'Erro':'Erro ao buscar dados do utilizador!'});
      }
   }

   @Route.put('/avatar')
   Future<Response> updateUrlAvatar(Request request) async{
    try {
      final userId = int.tryParse(request.headers['user']!)!;
      final avatarModel = UrlAvatarViewModel(await request.readAsString(), userId: userId);
      final user = await userService.updateUrlAvatar(avatarModel);
  return Response.ok(jsonEncode({
        "email": user.email,
        "imgAvatarUrl": user.imgAvatarUrl,
        "registerType": user.registerType,
  }));
} on Exception catch (e) {
  return Response.internalServerError(body: e);
}
   }

   @Route.put('/device')
   Future<Response> updateDeviceToken(Request request) async{
    try {
      final userId = int.tryParse(request.headers['user']!)!;
      final model = DeviceTokenViewModel(await request.readAsString(), userId: userId);

      userService.updateDeviceToken(model);

      return Response.ok(jsonEncode({"Message":"Token atualizado com sucesso!"}));
    } catch (e) {
      log.error('Erro ao atualizar token do dispositivo [Controller]');
      return Response.internalServerError();
    }
   }


   Router get router => _$UserControllerRouter(this);
}