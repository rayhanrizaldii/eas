import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

String decodeFileName(String encodedFileName) {
  try {
    return utf8.decode(base64.decode(encodedFileName));
  } catch (e) {
    print('Error decoding file name: $e');
    return '';
  }
}

class FetchUser {
  static const String baseUrl = 'http://192.168.18.213:8080/eas/pengguna';
  static Future<Map<dynamic, dynamic>> GetUserById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}/read_user_by_id.php?id=$id'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        if (data.containsKey('foto')) {
          data['foto'] = decodeFileName(data['foto']);
        }

        return data;
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getUser() async {
    final response = await http.get(Uri.parse('${baseUrl}/read_user.php'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData is Map && jsonData.containsKey('data')) {
        final dataList = List<Map<String, dynamic>>.from(jsonData['data']);

        // Mendekode nama file yang dienkripsi
        for (var data in dataList) {
          if (data.containsKey('foto')) {
            data['foto'] = decodeFileName(data['foto']);
          }
        }

        return dataList;
      } else {
        throw Exception('Invalid JSON format');
      }
    } else {
      throw Exception('Gagal mengambil data: ${response.statusCode}');
    }
  }

  static Future<bool> createUser(
    String id_pengguna,
    String nama,
    String alamat,
    DateTime tgl_daftar,
    String no_telpon,
    File imagePath,
  ) async {
    try {
      var url = Uri.parse('${baseUrl}/create_user.php');
      var request = http.MultipartRequest('POST', url);

      request.fields['id_pengguna'] = id_pengguna;
      request.fields['nama'] = nama;
      request.fields['alamat'] = alamat;
      request.fields['tgl_daftar'] =
          DateFormat('dd-MM-yyyy').format(tgl_daftar);
      request.fields['no_telpon'] = no_telpon;

      // ignore: unnecessary_null_comparison
      if (imagePath != null) {
        // Use fromPath instead of fromBytes
        request.files.add(await http.MultipartFile.fromPath(
          'foto',
          imagePath.path,
        ));

        var response = await request.send();
        if (response.statusCode == 200) {
          print('Data Pengguna dan gambar berhasil disimpan.');
          return true; // Indicate success
        } else {
          print(
              'Gagal menyimpan data dan gambar. Status code: ${response.statusCode}');
          return false; // Indicate failure
        }
      } else {
        print('imagePath is null. Gagal menyimpan data Pengguna dan gambar.');
        return false; // Indicate failure
      }
    } catch (e) {
      print('Terjadi kesalahan saat mengirim permintaan: $e');
      return false; // Indicate failure
    }
  }

  static Future<void> updateUser(
    int id,
    String id_pengguna,
    String nama,
    String alamat,
    DateTime tgl_daftar,
    String no_telpon,
    File imagePath,
  ) async {
    var url = Uri.parse('${baseUrl}/update_user.php');
    var request = http.MultipartRequest('POST', url);

    request.fields['id'] = id.toString();
    request.fields['id_pengguna'] = id_pengguna;
    request.fields['nama'] = nama;
    request.fields['alamat'] = alamat;
    request.fields['tgl_daftar'] = DateFormat('dd-MM-yyyy').format(tgl_daftar);
    request.fields['no_telpon'] = no_telpon;

    // ignore: unnecessary_null_comparison
    if (imagePath != null) {
      try {
        // Use fromPath instead of fromBytes
        request.files.add(await http.MultipartFile.fromPath(
          'foto',
          imagePath.path,
        ));

        var response = await request.send();

        if (response.statusCode == 200) {
          print('Data dan gambar berhasil diperbarui.');
        } else {
          print(
              'Gagal memperbarui Data Pengguna dan gambar. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Terjadi kesalahan saat mengirim permintaan: $e');
      }
    }
  }

  static Future<void> deleteUser(int id) async {
    String apiUrl = '${baseUrl}/delete_user.php?id=$id';

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Data berhasil dihapus
        print('Data Pengguna dengan ID $id berhasil dihapus.');
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

  static Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    final response =
        await http.get(Uri.parse('${baseUrl}/search_user.php?q=$query'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
