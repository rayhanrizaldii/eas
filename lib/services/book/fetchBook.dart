import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class FetchBook {
  static const String baseUrl = 'http://192.168.18.213:8080/eas/buku';
  static Future<Map<dynamic, dynamic>> GetBookById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}/read_book_by_id.php?id=$id'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        return data;
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getBook() async {
    final response = await http.get(Uri.parse('${baseUrl}/read_book.php'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData is Map && jsonData.containsKey('data')) {
        final dataList = List<Map<String, dynamic>>.from(jsonData['data']);

        return dataList;
      } else {
        throw Exception('Invalid JSON format');
      }
    } else {
      throw Exception('Gagal mengambil data: ${response.statusCode}');
    }
  }

  static Future<bool> createBook(
    String no_isbn,
    String nama_pengarang,
    DateTime tgl_cetak,
    int kondisi,
    int harga,
    String jenis,
    int harga_produksi,
  ) async {
    try {
      var url = Uri.parse('${baseUrl}/create_book.php');
      var request = http.MultipartRequest('POST', url);

      request.fields['no_isbn'] = no_isbn;
      request.fields['nama_pengarang'] = nama_pengarang;
      request.fields['tgl_cetak'] = DateFormat('dd-MM-yyyy').format(tgl_cetak);
      request.fields['kondisi'] = kondisi.toString();
      request.fields['harga'] = harga.toString();
      request.fields['jenis'] = jenis;
      request.fields['harga_produksi'] = harga_produksi.toString();

      var response = await request.send();
      if (response.statusCode == 200) {
        print('Data Buku berhasil disimpan.');
        return true; // Indicate success
      } else {
        print('Gagal menyimpan Data Buku. Status code: ${response.statusCode}');
        return false; // Indicate failure
      }
    } catch (e) {
      print('Terjadi kesalahan saat mengirim permintaan: $e');
      return false; // Indicate failure
    }
  }

  static Future<void> updateBook(
    int id_buku,
    String no_isbn,
    String nama_pengarang,
    DateTime tgl_cetak,
    int kondisi,
    int harga,
    String jenis,
    int harga_produksi,
  ) async {
    var url = Uri.parse('${baseUrl}/update_book.php');
    var request = http.MultipartRequest('POST', url);

    request.fields['id_buku'] = id_buku.toString();
    request.fields['no_isbn'] = no_isbn;
    request.fields['nama_pengarang'] = nama_pengarang;
    request.fields['tgl_cetak'] = DateFormat('dd-MM-yyyy').format(tgl_cetak);
    request.fields['kondisi'] = kondisi.toString();
    request.fields['harga'] = harga.toString();
    request.fields['jenis'] = jenis;
    request.fields['harga_produksi'] = harga_produksi.toString();

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Data Buku berhasil diperbarui.');
    } else {
      print('Gagal memperbarui Data Buku. Status code: ${response.statusCode}');
    }
  }

  static Future<void> deleteBook(int id_buku) async {
    String apiUrl = '${baseUrl}/delete_book.php?id=$id_buku';

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Data berhasil dihapus
        print('Data Buku dengan ID $id_buku berhasil dihapus.');
      } else {
        // Gagal menghapus data, tampilkan pesan kesalahan
        print('Gagal menghapus Data Pengguna. Status: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      // Tangani kesalahan jika ada
      print('Error: $error');
    }
  }

  static Future<List<Map<String, dynamic>>> searchBooks(String query) async {
    final response =
        await http.get(Uri.parse('${baseUrl}/search_book.php?q=$query'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
