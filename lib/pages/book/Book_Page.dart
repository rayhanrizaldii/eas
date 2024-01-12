import 'package:eas/pages/book/Chart_Book.dart';
import 'package:eas/pages/book/Edit_Book.dart';
import 'package:eas/services/book/fetchBook.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:intl/intl.dart';

class BookPage extends StatefulWidget {
  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        height: 600,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFieldCustom(
                      controller: _searchController,
                      onChanged: (query) async {
                        List<Map<String, dynamic>> results =
                            await FetchBook.searchBooks(query);
                        setState(() {
                          _searchResults = results;
                        });
                      },
                      labelText: 'Cari Buku....',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChartBook()),
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xff1d1d1d),
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(FlutterRemix.pie_chart_2_fill),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _searchResults.isNotEmpty
                  ? ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final item = _searchResults[index];
                        return buildListItem(item);
                      },
                    )
                  : (_searchController.text.isNotEmpty
                      ? Center(
                          child: Text('Tidak ada data buku yang ditemukan.'))
                      : FutureBuilder<List<Map<String, dynamic>>>(
                          future: FetchBook.getBook(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final data = snapshot.data!;
                              return ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  final item = data[index];
                                  return buildListItem(item);
                                },
                              );
                            } else if (snapshot.hasError) {
                              print('${snapshot.error}');
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        )),
            ),
          ],
        ),
      ),
    );
  }

  Card buildListItem(Map<String, dynamic> item) {
    int itemId = int.parse(item['id_buku']);

    return Card(
      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      clipBehavior: Clip.hardEdge,
      child: Dismissible(
        key: Key(itemId.toString()),
        background: Container(
          color: Colors.redAccent,
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
        confirmDismiss: (_) => showDeleteConfirmationDialog(context),
        onDismissed: (_) => deleteItem(itemId),
        child: SizedBox(
          width: double.infinity,
          height: 175,
          child: Row(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: 250,
                      height: 175,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['no_isbn'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text('Nama Pengarang : ${item['nama_pengarang']}'),
                          SizedBox(height: 5),
                          Text(
                              'Tanggal Cetak: ${_formatDate(item['tgl_cetak'])}'),
                          SizedBox(height: 5),
                          Text(
                              'Kondisi: ${item['kondisi'] == '2' ? 'Rusak' : 'Baik'}'),
                          SizedBox(height: 5),
                          Text('Harga : ${item['harga']}'),
                          SizedBox(height: 5),
                          Text('Jenis : ${item['jenis']}'),
                          SizedBox(height: 5),
                          Text('Harga Produksi : ${item['harga_produksi']}'),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => navigateToEditPage(context, itemId),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
    return formattedDate;
  }

  void navigateToEditPage(BuildContext context, int itemId) {
    print(itemId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBook(id: itemId),
      ),
    );
  }

  Future<bool?> showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Anda yakin ingin menghapus Data Buku ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  void deleteItem(int itemId) async {
    await FetchBook.deleteBook(itemId);

    setState(() {
      _searchResults
          .removeWhere((item) => int.parse(item['id_buku']) == itemId);
    });
  }
}

class TextFieldCustom extends StatelessWidget {
  const TextFieldCustom({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.onChanged,
  }) : super(key: key);

  final TextEditingController controller;
  final String labelText;
  final onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Color(0xff1d1d1d),
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(Icons.search, color: Color(0xff1d1d1d)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff1d1d1d)),
          borderRadius: BorderRadius.circular(20.0),
        ),
        labelStyle: TextStyle(
          color: Color(0xff1d1d1d),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
