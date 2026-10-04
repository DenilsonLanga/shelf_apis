
import 'package:bcrypt/bcrypt.dart';
class BcryptHelper {

  static String encryptPass(password){
    final senhahashed = BCrypt.hashpw(password, BCrypt.gensalt());
    return senhahashed;
  }

  static bool checkPassword(loginPassword, savedPassword){
  
  final isTrue = BCrypt.checkpw(loginPassword, savedPassword);
 return isTrue;
  }
}