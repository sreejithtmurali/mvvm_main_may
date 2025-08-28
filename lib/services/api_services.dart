// api_services.dart - Updated with connectivity check
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mvvm_main_may/models/User.dart';
import 'connectivity_service.dart'; // Import the connectivity service

class ApiException implements Exception {
  final String errorMsg;
  final int? statusCode;

  ApiException(this.errorMsg, {this.statusCode});

  @override
  String toString() {
    return "ApiException::$errorMsg -- statuscode: $statusCode";
  }
}

class ApiService {
  final String baseUrl = "https://freeapi.luminartechnohub.com";
  final Duration timeout = const Duration(seconds: 10);
  final ConnectivityService _connectivityService = ConnectivityService();

  /// Check connectivity before making API calls
  Future<void> _checkConnectivity() async {
    final isConnected = await _connectivityService.checkConnectivity();
    if (!isConnected) {
      throw ApiException("No Internet Connection");
    }
  }

  /// ---------- Common Methods ----------
  Future<dynamic> get(String endpoint,
      {Map<String, String>? headers, Map<String, dynamic>? queryParams}) async {
    await _checkConnectivity(); // Check connectivity first

    try {
      Uri url =
      Uri.parse(baseUrl + endpoint).replace(queryParameters: queryParams);
      log("REQUEST => GET $url, headers: $headers");

      final response = await http.get(url, headers: headers).timeout(timeout);
      return _processResponse(response);
    } on SocketException {
      throw ApiException("No Internet Connection");
    } on HttpException {
      throw ApiException("Couldn't find the resource");
    } on FormatException {
      throw ApiException("Bad response format");
    } catch (e) {
      // If it's already an ApiException, re-throw it
      if (e is ApiException) rethrow;
      throw ApiException("Unexpected error: $e");
    }
  }

  Future<dynamic> post(String endpoint,
      {Map<String, String>? headers, dynamic data}) async {
    await _checkConnectivity(); // Check connectivity first

    try {
      Uri url = Uri.parse(baseUrl + endpoint);
      log("REQUEST => POST $url, headers: $headers, body: $data");

      final response = await http
          .post(url,
          headers: headers ?? {"Content-Type": "application/json"},
          body: jsonEncode(data))
          .timeout(timeout);
      return _processResponse(response);
    } on SocketException {
      throw ApiException("No Internet Connection");
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException("Unexpected error: $e");
    }
  }

  Future<dynamic> put(String endpoint,
      {Map<String, String>? headers, dynamic data}) async {
    await _checkConnectivity(); // Check connectivity first

    try {
      Uri url = Uri.parse(baseUrl + endpoint);
      log("REQUEST => PUT $url, headers: $headers, body: $data");

      final response = await http
          .put(url,
          headers: headers ?? {"Content-Type": "application/json"},
          body: jsonEncode(data))
          .timeout(timeout);
      return _processResponse(response);
    } on SocketException {
      throw ApiException("No Internet Connection");
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException("Unexpected error: $e");
    }
  }

  Future<dynamic> delete(String endpoint,
      {Map<String, String>? headers, dynamic data}) async {
    await _checkConnectivity(); // Check connectivity first

    try {
      Uri url = Uri.parse(baseUrl + endpoint);
      log("REQUEST => DELETE $url, headers: $headers, body: $data");

      final response = await http
          .delete(url,
          headers: headers ?? {"Content-Type": "application/json"},
          body: jsonEncode(data))
          .timeout(timeout);
      return _processResponse(response);
    } on SocketException {
      throw ApiException("No Internet Connection");
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException("Unexpected error: $e");
    }
  }

  Future<dynamic> multipartPost(
      String endpoint, {
        Map<String, String>? headers,
        Map<String, String>? fields,
        Map<String, File>? files,
      }) async {
    await _checkConnectivity(); // Check connectivity first

    try {
      Uri url = Uri.parse(baseUrl + endpoint);
      log("REQUEST => MULTIPART POST $url, fields: $fields, files: $files");

      var request = http.MultipartRequest('POST', url);

      if (headers != null) request.headers.addAll(headers);

      if (fields != null) {
        request.fields.addAll(fields);
      }

      if (files != null) {
        for (var entry in files.entries) {
          request.files.add(
            await http.MultipartFile.fromPath(
              entry.key,
              entry.value.path,
            ),
          );
        }
      }

      final streamedResponse = await request.send().timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);
      return _processResponse(response);
    } on SocketException {
      throw ApiException("No Internet Connection");
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException("Unexpected error: $e");
    }
  }

  /// ---------- Response Handler ----------
  dynamic _processResponse(http.Response response) {
    log("RESPONSE => ${response.body}, statusCode: ${response.statusCode}");

    dynamic responseBody;
    try {
      responseBody = jsonDecode(response.body);
    } catch (_) {
      responseBody = response.body; // fallback if not JSON
    }

    switch (response.statusCode) {
      case 200:return responseBody;
      case 201:
        return responseBody;
      case 400:
        throw ApiException(
          _extractErrorMessage(responseBody, "Bad Request"),
          statusCode: response.statusCode,
        );
      case 401:
        throw ApiException(
          _extractErrorMessage(responseBody, "Unauthorized"),
          statusCode: response.statusCode,
        );
      case 403:
        throw ApiException(
          _extractErrorMessage(responseBody, "Forbidden"),
          statusCode: response.statusCode,
        );
      case 404:
        throw ApiException(
          _extractErrorMessage(responseBody, "Not Found"),
          statusCode: response.statusCode,
        );
      case 500:
      default:
        throw ApiException(
          _extractErrorMessage(responseBody, "Server Error"),
          statusCode: response.statusCode,
        );
    }
  }

  /// Extracts error message from JSON if available
  String _extractErrorMessage(dynamic responseBody, String fallback) {
    if (responseBody is Map && responseBody.containsKey("message")) {
      return responseBody["message"];
    } else if (responseBody is Map && responseBody.containsKey("error")) {
      return responseBody["error"];
    } else {
      return fallback;
    }
  }

  /// ---------- Specific API Calls ----------
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json'
    };

    final response = await post(
      "/login",
      headers: headers,
      data: {"email": email, "password": password},
    );

    return User.fromJson(response);
  }
}