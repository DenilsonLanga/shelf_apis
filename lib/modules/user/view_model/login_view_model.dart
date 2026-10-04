
import 'package:shelf_apis/app/helpers/request_mapping.dart';

class LoginViewModel extends RequestMapping{
  late String? email;
  late String? password;
  late bool? isSocialLogin;
  late String? avatar;
  late String? socialType;
  late String? socialKey;
  late bool? isSupplier;

  LoginViewModel(dataRequest) :super(dataRequest);
  
  @override
  void map() {
    email = data['email'];
    password = data['password'];
    isSocialLogin = data['social_login'];
    avatar = data['avatar'];
    socialType = data['social_type'];
    socialKey = data['social_key'];
    isSupplier = data['supplier'];
  }
  
}