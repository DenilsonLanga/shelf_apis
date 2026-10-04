// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:shelf_apis/app/helpers/request_mapping.dart';

class UserSaveInputModel extends RequestMapping {
  late String password;
  late String email;
  int? supplierId;

  UserSaveInputModel(
    {required this.password,
    required this.email,
    this.supplierId,}
  ): super.empty();
  
  UserSaveInputModel.mapping(super.dataRequest);
  
  @override
  void map() {
    email = data['email'];
    password = data['password'];
  }
}
