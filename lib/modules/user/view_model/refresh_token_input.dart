
import 'package:shelf_apis/app/helpers/request_mapping.dart';

class RefreshTokenInput extends RequestMapping{
  final int userId;
  final int? supplier;
  String? accessToken;
  late String refreshToken;
  RefreshTokenInput(super.dataRequest, {required this.userId, required this.supplier, this.accessToken});

  @override
  void map() {
    refreshToken = data['refresh_token'];
  }
  
}