import 'dart:io';
class ToolCreateBaseNetworkClient {
  static final ToolCreateBaseNetworkClient _instance = ToolCreateBaseNetworkClient._internal();

  factory ToolCreateBaseNetworkClient() {
    return _instance;
  }

  ToolCreateBaseNetworkClient._internal();

  // Create base network client
 
  
  void createBaseNetworkClass(String domainPath) {
  final networkDir = Directory('$domainPath/lib/network');
  networkDir.createSync(recursive: true);

  final baseNetworkFile = File('$domainPath/lib/network/base_network.dart');
  baseNetworkFile.writeAsStringSync('''
import 'package:dio/dio.dart';

class BaseNetwork {
  final Dio _dio;

  BaseNetwork() : _dio = Dio() {
    _dio.options.baseUrl = 'YOUR_BASE_URL_HERE';
    _dio.options.connectTimeout = Duration(seconds: 5);
    _dio.options.receiveTimeout = Duration(seconds: 3);
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) {
    return _dio.post(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) {
    return _dio.put(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> delete(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.delete(path, queryParameters: queryParameters);
  }
}
''');
}
}