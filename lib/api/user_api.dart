import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ppkd_flutter/api/endpoint.dart';
import 'package:ppkd_flutter/helper/shared_preference.dart';
import 'package:ppkd_flutter/models/register_error_response.dart';
import 'package:ppkd_flutter/models/register_response.dart';
import 'package:ppkd_flutter/models/user_model.dart';

class UserServicePM {
  Future<Map<String, dynamic>> registerUser({
    required String email,
    required String name,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(Endpoint.register),
      headers: {"Accept": "application/json"},
      body: {"name": name, "email": email, "password": password},
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(registerResponseFromJson(response.body).toJson());
      return registerResponseFromJson(response.body).toJson();
    } else if (response.statusCode == 422) {
      return registerErrorResponseFromJson(response.body).toJson();
    } else {
      print("Failed to register user: ${response.statusCode}");
      throw Exception("Failed to register user: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(Endpoint.login),
      headers: {"Accept": "application/json"},
      body: {"email": email, "password": password},
    );

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final token = jsonData['data']['token'];
      await PreferenceHandlerPM.saveToken(token);
      return ModelUser.fromJson(jsonData).toJson();
    } else {
      final jsonData = json.decode(response.body);
      return {"message": jsonData["message"], "data": null};
    }
  }

  Future<ProfileResponse> getProfile(String token) async {
    final response = await http.get(
      Uri.parse(Endpoint.profile),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ProfileResponse.fromJson(data['data']);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<ProfileResponse?> updateProfile(String token, String newName) async {
    final response = await http.put(
      Uri.parse(Endpoint.profile),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', // penting!
      },
      body: jsonEncode({'name': newName}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ProfileResponse.fromJson(data['data']);
    } else {
      print("Update failed: ${response.body}");
      return null;
    }
  }
}
