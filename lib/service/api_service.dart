import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://172.16.106.48/frozen_food";

  static Future<List> getProduk() async {
    try {
      final response =
          await http.get(Uri.parse("$baseUrl/get_produk.php"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          return data;
        } else {
          throw Exception("Format data bukan List");
        }
      } else {
        throw Exception("Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Gagal koneksi: $e");
    }
  }
}