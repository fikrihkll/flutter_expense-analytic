class ServerException implements Exception{
  final String msg;
  ServerException(this.msg);

  static String noDataMessage = 'There is no data';
}
class CacheException implements Exception{
}