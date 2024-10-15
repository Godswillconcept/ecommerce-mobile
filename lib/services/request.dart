// ignore_for_file: avoid_print

import 'package:dio/dio.dart';

final dio = Dio();
String host = "http://192.168.8.108"; //AphzolVirusMesh
// String host = "http://192.168.43.183"; //AphzolVirusEdge
// String host = "http://192.168.100.5"; //Godswill A04
// String host = "http://192.168.159.225"; //Godswill A04
// String host = "http://192.168.0.101"; //Connected
String port = "3000";
String baseUrl = "$host:$port/";

Future<Response> get(String url, [dynamic data]) async {
  url = baseUrl + url;
  final Response response = await dio.get(url, queryParameters: data);
  print(url);
  print(response.data);
  return response;
}

Future<Response> post(String url, dynamic data) async {
  url = baseUrl + url;
  final Response response = await dio.post(url, data: data);
  print(url);
  return response;
}
