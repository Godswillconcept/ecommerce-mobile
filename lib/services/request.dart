// ignore_for_file: avoid_print

import 'package:dio/dio.dart';

final dio = Dio();
// String host = "http://192.168.8.104";  //AphzolVirusMesh
String host = "http://192.168.198.123"; //Godswill A04
String port = "3000";
String baseUrl = "$host:$port/";

Future<Response> get(String url, [dynamic data]) async {
  url = baseUrl + url;
  print(url);
  final Response response = await dio.get(url, queryParameters: data);
  print(response.data);
  return response;
}

Future<Response> post(String url, dynamic data) async {
  url = baseUrl + url;
  print(url);
  final Response response = await dio.post(url, data: data);
  return response;
}
