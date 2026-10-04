
import 'package:dotenv/dotenv.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:shelf_apis/app/config/service_locator.dart';


class JwtHelper {
  static final  jwtsecret = getIt.get<DotEnv>()['jwtsecret']!;

  JwtClaim getClaims(token){
    return verifyJwtHS256Signature(token, jwtsecret);
  }

  static String generateAccessToke(int userId, int? supplierId){
    final jwtClaims = JwtClaim(
        expiry: DateTime.now().add(Duration(seconds: 1200)),
        issuer: 'Denilson',
        payload: {
          'sub': userId,
          'supplier': supplierId
        }
      );

      return issueJwtHS256(jwtClaims, jwtsecret);
  }

  static String generateRefreshToken(accessToken){
    final pureToken = accessToken.replaceAll('Bearer ', '');
    final jwtClaims = JwtClaim(
        expiry: DateTime.now().add(Duration(days: 20)),
        issuer: pureToken,
        subject: 'RefreshToken',
        notBefore: DateTime.now().add(Duration(seconds: 1)),
        issuedAt: DateTime.now()
      );

      return issueJwtHS256(jwtClaims, jwtsecret);
  }
}