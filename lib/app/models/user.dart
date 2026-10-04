// ignore_for_file: public_member_api_docs, sort_constructors_first

class User {
  final int? id;
  final String? email;
  final String? senha;
  final String? registerType;
  final String? iosToken;
  final String? androidToken;
  final String? refreshToken;
  final String? imgAvatarUrl; 
  final String? socialId;
  final int? supplierId;

  User({ this.id,  this.email,  this.senha,  this.registerType,  this.iosToken,  this.androidToken,  this.refreshToken,  this.imgAvatarUrl,  this.socialId, this.supplierId});

  User copyWith({
    int? id,
    String? email,
    String? senha,
    String? registerType,
    String? iosToken,
    String? androidToken,
    String? refreshToken,
    String? imgAvatarUrl,
    String? socialId,
    int? supplierId,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      senha: senha ?? this.senha,
      registerType: registerType ?? this.registerType,
      iosToken: iosToken ?? this.iosToken,
      androidToken: androidToken ?? this.androidToken,
      refreshToken: refreshToken ?? this.refreshToken,
      imgAvatarUrl: imgAvatarUrl ?? this.imgAvatarUrl,
      socialId: socialId ?? this.socialId,
      supplierId: supplierId ?? this.supplierId,
    );
  }
}
