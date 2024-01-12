import 'dart:convert';
import 'dart:io';
import 'package:eas/main.dart';
import 'package:eas/services/user/fetchUser.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class EditUser extends StatefulWidget {
  final int id;

  EditUser({required this.id});

  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final _formKey = GlobalKey<FormState>();
  late int id;

  TextEditingController _idpenggunaController = TextEditingController();
  TextEditingController _namaController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _notelpController = TextEditingController();
  File? _image;

  Future<void> _pickImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  DateTime? selectedDate;
  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUser(widget.id);
  }

  void _fetchUser(int id) async {
    try {
      final response = await FetchUser.GetUserById(id);
      // ignore: unnecessary_null_comparison
      if (response == null) {
        print('Empty response from the server');
        return;
      }

      final jsonData = response as Map<String, dynamic>;
      if (!jsonData.containsKey('data')) {
        print('Invalid JSON format: $response');
        return;
      }

      final data = jsonData['data'][0] as Map<String, dynamic>;

      if (data.containsKey('foto') && data['foto'] is String) {
        String encodedFoto = data['foto'];
        List<int> decodedBytes = base64.decode(encodedFoto);
        String decodedString = utf8.decode(decodedBytes);

        data['foto'] = decodedString;
      }

      _populateFormFields(data);
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _populateFormFields(Map<String, dynamic> data) {
    setState(() {
      _idpenggunaController.text = data['id_pengguna'];
      _namaController.text = data['nama'];
      selectedDate = DateTime.parse(data['tgl_daftar']);
      _alamatController.text = data['alamat'];
      _notelpController.text = data['no_telpon'];

      if (data['foto'] is String) {
        _image = ('http://192.168.110.215:8080/eas/pengguna/images/' +
            data['foto']) as File?;
        ;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        child: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Form(
              key: _formKey,
              child: Stack(
                children: [
                  ListView(
                    children: [
                      Container(
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: _image != null
                                      ? Image.file(
                                          _image!,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit
                                              .cover, // Sesuaikan dengan kebutuhan Anda
                                        )
                                      : Container(),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _pickImageFromGallery();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[900],
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Pilih Gambar'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextFieldCustom(
                          controller: _idpenggunaController,
                          labelText: 'Id Pengguna',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextFieldCustom(
                          controller: _namaController,
                          labelText: 'Nama',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextFieldCustom(
                          controller: _alamatController,
                          labelText: 'Alamat',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  labelText: selectedDate != null
                                      ? DateFormat('dd-MM-yyyy')
                                          .format(selectedDate!)
                                      : 'Tanggal Daftar',
                                ),
                                enabled: false,
                              ),
                            ),
                            TextButton(
                              onPressed: () => _selectDate(context),
                              child: Text(
                                'Pilih Tanggal',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextFieldCustom(
                          controller: _notelpController,
                          labelText: 'Nomor Telepon',
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          margin: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Kembali'),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[900],
                                  foregroundColor: Colors.white,
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (_image == null ||
                                        selectedDate == null) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Data Belum Lengkap'),
                                            content:
                                                Text('Silahkan Lengkapi Data'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      return;
                                    }
                                    int id = widget.id;
                                    String id_pengguna =
                                        _idpenggunaController.text;
                                    String nama = _namaController.text;
                                    String alamat = _alamatController.text;
                                    DateTime? tgl_daftar = selectedDate!;
                                    String no_telpon = _notelpController.text;

                                    // Call createData with the correct arguments
                                    await FetchUser.updateUser(
                                        id,
                                        id_pengguna,
                                        nama,
                                        alamat,
                                        tgl_daftar,
                                        no_telpon,
                                        _image!);

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyDrawer()),
                                    );
                                  }
                                },
                                child: Text('Simpan'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextFieldCustom extends StatelessWidget {
  const TextFieldCustom({
    Key? key,
    required this.controller,
    required this.labelText,
  }) : super(key: key);

  final TextEditingController controller;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.black,
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Silahkan Isi Bagian Yang Kosong';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        labelStyle: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
