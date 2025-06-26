import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ppkd_flutter/api/endpoint.dart';
import 'package:ppkd_flutter/models/menu_model.dart';

Future<List<MenuModel>> fetchMenu() async {
  final response = await http.get(Uri.parse(Endpoint.menu));

  print("Status code: ${response.statusCode}");
  print("Response body: ${response.body}");

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final List<dynamic> data = jsonData['data'];
    return data.map((item) => MenuModel.fromJson(item)).toList();
  } else {
    throw Exception('Gagal memuat menu: ${response.statusCode}');
  }
}
