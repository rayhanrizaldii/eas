import 'package:eas/components/ConditionRadio.dart';
import 'package:eas/main.dart';
import 'package:eas/services/book/fetchBook.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditBook extends StatefulWidget {
  final int id;

  EditBook({required this.id});
  @override
  _EditBookState createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  late int id;
  final _formKey = GlobalKey<FormState>();
  int? conditionValue;
  TextEditingController _noisbnController = TextEditingController();
  TextEditingController _namaPengarangController = TextEditingController();
  TextEditingController _hargaController = TextEditingController();
  TextEditingController _hargaProduksiController = TextEditingController();

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

  List<String> selectedType = [];

  List<String> typeList = [
    'Teknik',
    'Seni',
    'Ekonomi',
    'Humaniora',
  ];

  @override
  void initState() {
    super.initState();
    _fetchBook(widget.id);
  }

  void _fetchBook(int id) async {
    try {
      final response = await FetchBook.GetBookById(id);
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

      _populateFormFields(data);
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _populateFormFields(Map<String, dynamic> data) {
    setState(() {
      _noisbnController.text = data['no_isbn'];
      _namaPengarangController.text = data['nama_pengarang'];
      selectedDate = DateTime.parse(data['tgl_cetak']);
      conditionValue = data['kondisi'];
      _hargaController.text = data['harga'].toString();
      _hargaProduksiController.text = data['harga_produksi'].toString();
      selectedType = data['jenis'].split(', ');
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
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextFieldCustom(
                            controller: _noisbnController,
                            labelText: 'Nomor ISBN',
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextFieldCustom(
                          controller: _namaPengarangController,
                          labelText: 'Nama Pengarang',
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
                                      : 'Tanggal Cetak',
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
                        child: Text('Kondisi'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: ConditionRadio(
                          groupValue: conditionValue,
                          onChanged: (int? value) {
                            setState(() {
                              conditionValue = value;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextFieldCustom(
                          controller: _hargaController,
                          labelText: 'Harga',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Jenis'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: typeList.map((String hobby) {
                            return CheckboxListTile(
                              title: Text(hobby),
                              value: selectedType.contains(hobby),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value != null && value) {
                                    selectedType.add(hobby);
                                  } else {
                                    selectedType.remove(hobby);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextFieldCustom(
                          controller: _hargaProduksiController,
                          labelText: 'Harga Produksi',
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
                                    if (selectedDate == null) {
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
                                    int id = widget.id;
                                    String no_isbn = _noisbnController.text;
                                    String nama_pengarang =
                                        _namaPengarangController.text;
                                    DateTime? tgl_cetak = selectedDate!;
                                    int kondisi = conditionValue!;
                                    int harga =
                                        int.parse(_hargaController.text);

                                    String jenis = selectedType.join(', ');
                                    int harga_produksi = int.parse(
                                        _hargaProduksiController.text);

                                    // print(id);
                                    // print(no_isbn);
                                    // print(nama_pengarang);
                                    // print(tgl_cetak);
                                    // print(kondisi);
                                    // print(harga);
                                    // print(jenis);
                                    // print(harga_produksi);

                                    // Call createData with the correct arguments
                                    await FetchBook.updateBook(
                                      id,
                                      no_isbn,
                                      nama_pengarang,
                                      tgl_cetak,
                                      kondisi,
                                      harga,
                                      jenis,
                                      harga_produksi,
                                    );

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
