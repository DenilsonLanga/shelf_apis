// ignore_for_file: public_member_api_docs, sort_constructors_first

class DatabaseException implements Exception {
  String? msg;
  Exception? exception;
  
  DatabaseException({
    this.msg,
    this.exception,
  });



  @override
  String toString() => 'DatabaseException(msg: $msg, exception: $exception)';
}
