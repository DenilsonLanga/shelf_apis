
import 'package:shelf_apis/app/helpers/request_mapping.dart';

class DeviceTokenViewModel extends RequestMapping {
  final int userId;
  late Map? iosToken;
  late Map? androidToken;

  DeviceTokenViewModel(super.dataRequest, {required this.userId});
  
  @override
  void map() {
    data.forEach((key,value){
      if(key.contains("ios")){
        iosToken = {key:value};
        androidToken = null;
      }else if(key.contains('android')){
        iosToken = null;
        androidToken = {key:value};
      }
    });
  }
  
}