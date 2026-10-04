import 'package:shelf_apis/app/models/user.dart';
import 'package:shelf_apis/modules/user/view_model/confirm_login_view_model.dart';
import 'package:shelf_apis/modules/user/view_model/device_token_view_model.dart';
import 'package:shelf_apis/modules/user/view_model/refresh_token_input.dart';
import 'package:shelf_apis/modules/user/view_model/refresh_token_view_model.dart';
import 'package:shelf_apis/modules/user/view_model/url_avatar_view_model.dart';
import 'package:shelf_apis/modules/user/view_model/user_save_input_model.dart';

abstract class IUserService {
  Future<User> createUser(UserSaveInputModel user);
  Future<User> login(String email, String password, bool isSupplier);
  Future<User> loginWithSocial(String email, String avatar, String socialType, String socialKey);
  Future<String> confirmLogin(ConfirmLoginViewModel confirmLoginModel);
  Future<RefreshTokenViewModel> refreshToken(RefreshTokenInput refreshTokenInput);
  Future<User> findUserById(int userId);
  Future<User> updateUrlAvatar(UrlAvatarViewModel avatarModel);
  Future<void> updateDeviceToken(DeviceTokenViewModel deviceModel);
  Future<void> deleteIncompletedUser(UserSaveInputModel user);
} 