
import 'package:mysql_client/mysql_client.dart';

abstract class IDatabaseConnection {
  Future<MySQLConnectionPool> openConnection();
}