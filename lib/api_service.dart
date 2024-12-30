import 'dart:convert';
import 'package:http/http.dart' as http;
import 'kontak.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  // Mendapatkan semua kontak
  Future<List<Kontak>> fetchKontaks() async {
    final response = await http.get(Uri.parse('$baseUrl/kontaks'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Kontak(nama: item['nama'], nomor: item['nomor'])).toList();
    } else {
      throw Exception('Gagal memuat kontak');
    }
  }

  // Menambahkan kontak baru
  Future<void> addKontak(Kontak kontak) async {
    final response = await http.post(
      Uri.parse('$baseUrl/kontaks'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'nama': kontak.nama,
        'nomor': kontak.nomor,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Gagal menambahkan kontak');
    }
  }

  // Memperbarui kontak
  Future<void> updateKontak(int id, Kontak kontak) async {
    final response = await http.put(
      Uri.parse('$baseUrl/kontaks/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'nama': kontak.nama,
        'nomor': kontak.nomor,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal memperbarui kontak');
    }
  }
}
