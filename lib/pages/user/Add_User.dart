import 'dart:io';
import 'package:eas/main.dart';
import 'package:eas/services/user/fetchUser.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _formKey = GlobalKey<FormState>();
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
  Widget build(BuildContext context) {
    return Center(
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
                      )),
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
                                  borderSide: BorderSide(color: Colors.black)),
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
                              foregroundColor: Colors.white,
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
                                // Validasi _image dan selectedAge
                                if (_image == null || selectedDate == null) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Data Belum Lengkap'),
                                        content: Text('Silahkan Lengkapi Data'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Tutup dialog
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  return;
                                }
                                String id_pengguna = _idpenggunaController.text;
                                String nama = _namaController.text;
                                String alamat = _alamatController.text;
                                DateTime? tgl_daftar = selectedDate!;
                                String no_telpon = _notelpController.text;

                                // Call createData with the correct arguments
                                bool success = await FetchUser.createUser(
                                    id_pengguna,
                                    nama,
                                    alamat,
                                    tgl_daftar,
                                    no_telpon,
                                    _image!);

                                if (success) {
                                  // Jika berhasil, tampilkan AlertDialog

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Sukses'),
                                        content:
                                            Text('Data berhasil ditambahkan.'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyDrawer()),
                                              );
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  // Jika gagal, tampilkan AlertDialog dengan pesan error
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Gagal'),
                                        content: Text(
                                            'Terjadi kesalahan saat menambahkan data.'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              // Tutup AlertDialog
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
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
