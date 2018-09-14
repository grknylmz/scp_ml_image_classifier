class Resource {
  final int id;
  final String url;
  final String apiKey;

  Resource({this.id, this.url, this.apiKey});

  /* factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
        url: json['url'] as String, apiKey: json['apiKey'] as String);
  } */

  factory Resource.fromJson(json) {
    return Resource(
        id: json['id'] as int,
        url: json['scpUrl'] as String,
        apiKey: json['apiKey'] as String);
  }
}
