
class DeviceToken {
  final String? iosToken;
  final String? androidToken;

  DeviceToken({required this.iosToken, required this.androidToken});

  List<String?> get tokens => [iosToken, androidToken];
  
}