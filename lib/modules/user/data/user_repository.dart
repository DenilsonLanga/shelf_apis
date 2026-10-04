import 'package:injectable/injectable.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:mysql_client/exception.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shelf_apis/app/database/i_database_connection.dart';
import 'package:shelf_apis/app/exceptions/database_exception.dart';
import 'package:shelf_apis/app/exceptions/invalid_tokens_exception.dart';
import 'package:shelf_apis/app/exceptions/user_exists_exception.dart';
import 'package:shelf_apis/app/exceptions/user_not_found_exception.dart';
import 'package:shelf_apis/app/helpers/bcrypt_helper.dart';
import 'package:shelf_apis/app/helpers/jwt_helper.dart';
import 'package:shelf_apis/app/logs/i_logger.dart';
import 'package:shelf_apis/app/models/user.dart';
import 'package:shelf_apis/modules/user/view_model/confirm_login_view_model.dart';
import 'package:shelf_apis/modules/user/view_model/refresh_token_input.dart';
import 'package:shelf_apis/modules/user/view_model/refresh_token_view_model.dart';
import 'package:shelf_apis/modules/user/view_model/user_save_input_model.dart';

import './i_user_repository.dart';

@LazySingleton(as: IUserRepository)
class UserRepository implements IUserRepository {
  final IDatabaseConnection connection;
  final ILogger log;

  UserRepository({required this.connection, required this.log});

  MySQLConnectionPool? conn;

  @override
  Future<User> createUser(User user) async {
    //final senha = BcryptHelper.encryptPass(user.senha);
    final senhaHashed = BcryptHelper.encryptPass(user.senha!);
    print(senhaHashed.runtimeType);
    try {
      log.info('Tentando abrir conexão...');
      conn = await connection.openConnection();
      
log.info('Conexão aberta. Preparando query...');


final param = {
        "email": user.email?.toString(),
        "tipo_cadastro": user.registerType?.toString(),
        "img_avatar": user.imgAvatarUrl?.toString(),
        "senha": senhaHashed,
        "fornecedor_id": user.supplierId?.toString(),
        "social_id": user.socialId
};

log.info('Parâmetros preparados: $param');

      final result = await conn?.execute('''
            insert into usuario (email, tipo_cadastro, img_avatar, senha, fornecedor_id, social_id)
            values (:email, :tipo_cadastro, :img_avatar, :senha, :fornecedor_id, :social_id)
''', param);

      final userId =  result?.lastInsertID.toInt();
      log.info('Usuário criado com sucesso. ID: $userId');
      return user.copyWith(id: userId, senha: null);
      
    } on MySQLServerException catch (e,s){
      if(e.message.contains('usuario.email_UNIQUE')){
        log.error('Usuário já cadastrado na base de dados');
        throw UserExistsException();
      }

      log.error('Erro ao criar usuario',e ,s);
      throw DatabaseException(msg: 'Erro ao criar usuario', exception: e);
    } 
    catch (e,s) {
      log.error('Erro desconhecido no UserRepository', e, s);
      throw DatabaseException(msg: 'Erro interno no repositório');
    } 
  }

@override
  Future<User> login(String email, String password, bool isSupplier) async{

    try {
  log.info('Abrindo conexao...');
  conn = await connection.openConnection();
  log.info('Conexao aberta');
  
  final query = "select * from usuario where email = :email";
  final param = {"email": email};
  log.info('Preparando query e paramentro email: $email');
  
  final res = await conn?.execute(query,param);
  
  final userData = res?.rows.firstOrNull?.assoc();

  if(userData == null || userData.isEmpty){
    log.warning('Usuario nao encontrado');
    throw UserNotFoundException('Usuario nao existe');
  }

  final isPasswordCorrect = BcryptHelper.checkPassword(password, userData['senha']);

  if(!isPasswordCorrect){
    log.warning('Password incorrecta, tente novamente');
    throw DatabaseException(msg:'Password incorrecta, tente novamente');
  }

  return User(
    id: int.tryParse(userData['id']!),
    email: userData['email'],
    supplierId: int.tryParse(userData['fornecedor_id'] ?? '')
  );
  

} on MySQLServerException {
  log.error('Erro ao relizar login');
  throw DatabaseException(msg: 'Erro ao relizar login');

}
  }
  
  @override
  Future<User> socialLogin(String email, String socialKey, String socialType) async{
    
    try {
       conn = await connection.openConnection();
      log.info('Conexao aberta');

      final query = 'select * from usuario where email = :email';
      final param = {"email":email};

      final res = await conn?.execute(query,param);

      final userData = res?.rows.firstOrNull?.assoc();

      if(userData == null || userData.isEmpty){
        log.warning('User notfound, one will be created');
        throw UserNotFoundException('Usuário não encontrado!');
      }else{

        if(userData['social_id'] == null || userData['social_id'] != socialKey){
           await conn?.execute('update usuario set social_id = :social_id, tipo_cadastro = :tipo_cadastro where id = :id',
          {
            "id": userData['id'],
            "social_id": socialKey,
            "tipo_cadastro": socialType
          }
          );
          
        }
        return User(
            id: int.parse(userData['id']!),
            email: userData['email'],
            registerType: userData['tipo_cadastro'],
            androidToken: userData['android_token'],
            iosToken: userData['ios_token'],
            refreshToken: userData['refresh_token'],
            imgAvatarUrl: userData['img_avatar'],
            socialId: userData['social_id'],
            supplierId: int.tryParse(userData['fornecedor_id'] ?? '')
          );
      }
    } on MySQLServerException catch (e) {
      log.error('Erro no codigo SQL',e);
      throw DatabaseException();
    }
  }
  
  @override
  Future<String> updateTokens(ConfirmLoginViewModel user) async{
    try {

      final refreshToken = JwtHelper.generateRefreshToken(user.accessToken);

      log.info('Conectando...');
      conn = await connection.openConnection();
      log.info('Conectado a base de dados com sucesso');

      final mobileToken = {};
      
      if(user.androidToken != null){
        mobileToken['android_token'] = user.androidToken;
      }else{
        mobileToken['ios_token'] = user.iosToken;
      }

      final query = '''
            update usuario set ${mobileToken.keys.first} = :mobile_token,
            refresh_token = :refresh_token
            where id = :id
''';
      log.info('Preparando query');

      final params = {
        "mobile_token": mobileToken.values.first,
        "refresh_token": refreshToken,
        "id": user.id
      };
      log.info('Preparando parametros');

      await conn?.execute(query,params);
      log.info('Update feito com sucesso!');

      return refreshToken;

    } on MySQLServerException catch (e) {
      log.error('Ocorreu um erro ao efetuar atualizacao do token',e);
      throw DatabaseException();
    }
  }

  @override
  Future<RefreshTokenViewModel> refreshToken(RefreshTokenInput userTokens) async{
    _validateRefreshToken(userTokens);
    final newAccessToken = JwtHelper.generateAccessToke(userTokens.userId, userTokens.supplier);
    final newRefreshToken = JwtHelper.generateRefreshToken(newAccessToken);

    conn = await connection.openConnection();
    log.info('Conexao com base de dados aberta com sucesso!');

    await conn?.execute('update usuario set refresh_token = :refreshToken where id = :id',
    {'refreshToken':newRefreshToken, 'id':userTokens.userId}
    );

  return RefreshTokenViewModel(refreshToken: newRefreshToken, accessToken: newAccessToken);
  }

  void _validateRefreshToken(RefreshTokenInput userTokens){
    try {
  if(userTokens.refreshToken.isEmpty || !userTokens.refreshToken.contains('Bearer')){
    throw JwtException('Token invalido');
  }
  
  final refreshTokenClaims = JwtHelper().getClaims(userTokens.refreshToken.substring(7));
  refreshTokenClaims.validate(issuer: userTokens.accessToken);
//
} on Exception catch (e) {
  log.error('Token invalido', e);
  throw InvalidTokensException(message: 'O token fornecido e invalido! ');
}
  }
  
  @override
  Future<User> findUserById(int userId) async{
    try {
      conn = await connection.openConnection();
      log.info('Conexao com base de dados aberta');

      final res = await conn?.execute('SELECT * FROM usuario where id = :userId',{'userId':userId});
      final userData = res?.rows.firstOrNull?.assoc();

      if(userData == null || userData.isEmpty ){
          throw UserNotFoundException('Utilizador nao encontrado');
      }
      return User(
        email: userData['email'],
        imgAvatarUrl: userData['img_avatar'],
        registerType: userData['tipo_cadastro'],
      );
    } on MySQLServerException catch (e) {
      log.error('Erro do servido MySQL',e);
      throw DatabaseException(msg: 'Erro do servido MySQL');
    }on Exception{
      throw UserNotFoundException('Utilizador nao encontrado');
    }
  }
  
  @override
  Future<User> updateUrlAvatar(int userId, String urlAvatar) async{
    try {
      conn = await connection.openConnection();
      log.info('Conexao aberta');

      await conn?.execute('update usuario set img_avatar = :urlAvatar where id = :id',
      {"urlAvatar":urlAvatar,
       "id":userId
      });

      return findUserById(userId);
    } on Exception catch (e) {
      log.error('Erro ao atualizar a url do avatar',e);
      throw DatabaseException();
    }
  }
  
  @override
  Future<void> updateDeviceToken( userId,  iosToken,  androidToken) async{
    try {
      Map? deviceToken = {};
      conn = await connection.openConnection();
      log.info('Conexao feita com sucesso!');

      if(iosToken == null || iosToken.isEmpty){
        deviceToken = androidToken;
      }else{
        deviceToken = iosToken;
      }

      await conn?.execute('UPDATE usuario SET ${deviceToken?.keys.first} = :deviceToken WHERE id = :id',
      {"deviceToken":deviceToken?.values.first,
      "id":userId});


    } on Exception catch (e) {
      log.info('Erro ao atualizar o token do dispositivo',e);
      throw DatabaseException();
    }
  }

  @override
  Future<void> deleteIncompletedUser(UserSaveInputModel user) async{
    try {
      conn  = await connection.openConnection();
      log.info('Conexao feita com sucesso!');

      final res = await conn?.execute('delete from usuario where email = :email',{"email":user.email});
      if(res?.affectedRows.toInt() == 0){
       throw UserNotFoundException('');
      }
    } on MySQLServerException catch (e) {
      if(e.message.contains('fk')){
      log.error('Não é possivel eliminar um utilizador que já tenha agendamentos!',e);
      throw DatabaseException();
      }
      log.error('Erro de sintax MYSQL',e);
      throw DatabaseException();
    } catch (e) {
      log.error('Usuario nao encontado',e); 
      rethrow;
    }
  }
}





























































// @LazySingleton(as: IUserRepository)
// class UserRepository implements IUserRepository {
//   final IDatabaseConnection connection;
//   final ILogger log;

//   UserRepository({required this.connection, required this.log});

//   MySqlConnection? conn;

//   @override
//   Future<User> createUser(User user) async {
//     //final senha = BcryptHelper.encryptPass(user.senha);
//     final senha = CriptyHelper.hashePassword(user.senha!);
//     print(senha.runtimeType);
//     try {
//       log.info('Tentando abrir conexão...');
//       conn = await connection.openConnection();
// log.info('Conexão aberta. Preparando query...');


// final param = [
//         user.email?.toString(),
//         user.registerType?.toString(),
//         user.imgAvatarUrl?.toString(),
//         senha,
//         user.supplierId?.toString(),
//         user.socialId
//       ];

// log.info('Parâmetros preparados: $param');

//       final result = await conn?.query('''
//             insert into usuario (email, tipo_cadastro, img_avatar, senha, fornecedor_id, social_id)
//             values (?,?,?,?,?,?)
// ''', param);

// log.info('Usuário criado com sucesso. ID');
//       final userId = result?.insertId;
// log.info('Usuário criado com sucesso. ID: $userId');
//       return user.copyWith(id: userId, senha: null);
      
//     } on MySqlException catch (e,s){
//       if(e.message.contains('email_UNIQUE')){
//         log.error('Usuário já cadastrado na base de dados');
//         throw UserExistsException();
//       }

//       log.error('Erro ao criar usuario',e ,s);
//       throw DatabaseException(msg: 'Erro ao criar usuario', exception: e);
//     } 
//     catch (e,s) {
//       log.error('Erro desconhecido no UserRepository', e, s);
//       throw DatabaseException(msg: 'Erro interno no repositório');
//     } finally {
//       await conn?.close();
//     }
//   }
// }
