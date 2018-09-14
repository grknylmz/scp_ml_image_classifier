import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'resource.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class ScpConnector {
  File image;
  ScpConnector(File this.image);

  List<Resource> parseResources(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    print(parsed);
    return parsed.map<Resource>((json) => Resource.fromJson(json)).toList();
  }

  Future<List<Resource>> postRequests() async {
    final response = await rootBundle.loadString('assets/resource.json');
    return parseResources(response);
  }

  upload(File imageFile, String cloudUrl, String apiKey) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    http.MultipartRequest request =
        new http.MultipartRequest('POST', Uri.parse(cloudUrl));
    request.headers['APIKey'] = apiKey; // todo - insert real value
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));

    request.files.add(multipartFile);

    http.StreamedResponse response = await request.send();

    print(response.statusCode);

    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  postRequest() async {
    var list = await this.postRequests();
    var scpCredentials = list.first; //Get SCP Details
    if (this.image != null) {
      this.upload(this.image, scpCredentials.url, scpCredentials.apiKey);
    }
  }
}
