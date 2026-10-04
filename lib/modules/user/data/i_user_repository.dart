import 'package:shelf_apis/app/models/user.dart';
import 'package:shelf_apis/modules/user/view_model/confirm_login_view_model.dart';
import 'package:shelf_apis/modules/user/view_model/refresh_token_input.dart';
import 'package:shelf_apis/modules/user/view_model/refresh_token_view_model.dart';
import 'package:shelf_apis/modules/user/view_model/user_save_input_model.dart';

abstract class IUserRepository {
  Future<User> createUser(User user);
  Future<User> login(String email, String password, bool isSupplier);
  Future<User> socialLogin(String email, String socialKey, String socialType);
  Future<String> updateTokens(ConfirmLoginViewModel user);
  Future<RefreshTokenViewModel> refreshToken(RefreshTokenInput refreshTokenInput);
  Future<User> findUserById(int userId);
  Future<User> updateUrlAvatar(int userId, String urlAvatar);
  Future<void> updateDeviceToken(int userId, Map? iosToken, Map? androidToken);
  Future<void> deleteIncompletedUser(UserSaveInputModel user);
}