import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ppkd_flutter/models/reservation_model.dart';
import 'package:ppkd_flutter/api/endpoint.dart';

class ReservationApi {
  static Future<List<ReservationModel>> fetchReservations() async {
    final response = await http.get(
      Uri.parse('${Endpoint.baseUrlApi}/reservations'),
    );

    print("Status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => ReservationModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat reservasi');
    }
  }
}
