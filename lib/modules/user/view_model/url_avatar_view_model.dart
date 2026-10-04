
import 'package:shelf_apis/app/helpers/request_mapping.dart';

class UrlAvatarViewModel extends RequestMapping{
  late String urlAvatar;
  final int userId;
  UrlAvatarViewModel(super.dataRequest, {required this.userId});

  @override
  void map() {
    urlAvatar = data['url_avatar'];
  }
  
}