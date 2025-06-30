import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ppkd_flutter/api/endpoint.dart';
import 'package:ppkd_flutter/helper/shared_preference.dart';
import 'package:ppkd_flutter/models/reservation_model.dart';

class ReservationApi {
  static Future<List<ReservationModel>> fetchReservations() async {
    final token =
        await PreferenceHandlerPM.getToken(); // Ambil token dari SharedPreferences

    final response = await http.get(
      Uri.parse('${Endpoint.baseUrlApi}/reservations'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
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

  //Delete Reservation
  static Future<bool> deleteReservation(int id) async {
    final token = await PreferenceHandlerPM.getToken();
    final response = await http.delete(
      Uri.parse('${Endpoint.baseUrlApi}/reservations/$id'),
      headers: {'Authorization': 'Bearer $token', 'accept': 'application/json'},
    );

    return response.statusCode == 200;
  }
}
