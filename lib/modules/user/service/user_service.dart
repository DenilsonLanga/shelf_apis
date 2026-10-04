// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:injectable/injectable.dart';
import 'package:shelf_apis/app/exceptions/user_not_found_exception.dart';
import 'package:shelf_apis/app/logs/i_logger.dart';

import 'package:shelf_apis/app/models/user.dart';
import 'package:shelf_apis/modules/user/data/i_user_repository.dart';
import 'package:shelf_apis/modules/user/service/i_user_service.dart';
import 'package:shelf_apis/modules/user/view_model/confirm_login_view_model.dart';
import 'package:shelf_apis/modules/user/view_model/device_token_view_model.dart';
import 'package:shelf_apis/modules/user/view_model/refresh_token_input.dart';
import 'package:shelf_apis/modules/user/view_model/refresh_token_view_model.dart';
import 'package:shelf_apis/modules/user/view_model/url_avatar_view_model.dart';
import 'package:shelf_apis/modules/user/view_model/user_save_input_model.dart';

@LazySingleton(as: IUserService)
class UserService implements IUserService {
  IUserRepository userRepository;
  ILogger log; 

  UserService({
    required this.userRepository,
    required this.log
  });
  
  @override
  Future<User> createUser(UserSaveInputModel userInput) {
    final user = User(
      email: userInput.email,
      senha: userInput.password,
      registerType: 'APP',
      supplierId: userInput.supplierId
    );

    return userRepository.createUser(user);
  }


@override
Future<User> login(String email, String password, bool isSupplier){
    return userRepository.login( email, password, isSupplier);
}

  @override
  Future<User> loginWithSocial(String email, String avatar, String socialType, String socialKey) async {
    try {
  return await userRepository.socialLogin(email, socialKey, socialType);
} on UserNotFoundException catch (e) {
  log.error('Usuario nao cadastrado. Cadastrando usuario.',e);
  return await userRepository.createUser(
    User(
      email: email,
      senha: DateTime.now().toString(),
      imgAvatarUrl: avatar,
      socialId: socialKey,
      registerType: socialType,
    )
  );
  
}
  }

  @override
  Future<String> confirmLogin(ConfirmLoginViewModel confirmLoginModel) async{
    return await userRepository.updateTokens(confirmLoginModel);
  }

  @override
  Future<RefreshTokenViewModel> refreshToken(RefreshTokenInput refreshTokenInput) async{
    return await userRepository.refreshToken(refreshTokenInput);
  }
  
  @override
  Future<User> findUserById(int userId) async{
   return await userRepository.findUserById(userId);
  }

  @override
  Future<User> updateUrlAvatar(UrlAvatarViewModel avatarModel) async{
   return await userRepository.updateUrlAvatar(avatarModel.userId, avatarModel.urlAvatar);
  }

  @override
  Future<void> updateDeviceToken(DeviceTokenViewModel deviceModel) async{
    await userRepository.updateDeviceToken(deviceModel.userId, deviceModel.iosToken, deviceModel.androidToken);
  }
  
  @override
  Future<void> deleteIncompletedUser(UserSaveInputModel user) async{
    await userRepository.deleteIncompletedUser(user);
  }


}
