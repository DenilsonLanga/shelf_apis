
import 'package:shelf_apis/app/helpers/request_mapping.dart';

class ConfirmLoginViewModel extends RequestMapping{
  final int id;
  final String accessToken;
  late String? iosToken;
  late String?  androidToken;

  ConfirmLoginViewModel(super.dataRequest, this.id, this.accessToken);

  @override
  void map() {
    iosToken = data['ios_token'];
    androidToken =  data['android_token'];
  }
  
}