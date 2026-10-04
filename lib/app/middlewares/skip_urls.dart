// ignore_for_file: public_member_api_docs, sort_constructors_first

class SkipUrls {
  final String url;
  final String method;

  SkipUrls({required this.url, required this.method});

  @override
  bool operator ==(covariant SkipUrls other) {
    if (identical(this, other)) return true;
  
    return 
      other.url == url &&
      other.method == method;
  }

  @override
  int get hashCode => url.hashCode ^ method.hashCode;
}
