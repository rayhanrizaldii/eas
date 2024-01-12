import 'package:eas/pages/user/Edit_User.dart';
import 'package:eas/services/user/fetchUser.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
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
              child: TextFieldCustom(
                controller: _searchController,
                onChanged: (query) async {
                  List<Map<String, dynamic>> results =
                      await FetchUser.searchUsers(query);
                  setState(() {
                    _searchResults = results;
                  });
                },
                labelText: 'Cari Pengguna....',
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
                          child:
                              Text('Tidak ada data pengguna yang ditemukan.'))
                      : FutureBuilder<List<Map<String, dynamic>>>(
                          future: FetchUser.getUser(),
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
    int itemId = int.parse(item['id']);

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
          width: 320,
          height: 175,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Hero(
                  tag: 'photo_$itemId',
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(
                      'http://192.168.18.213:8080/eas/pengguna/images/' +
                          item['foto'],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 180,
                      height: 180,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['id_pengguna'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text('Nama : ${item['nama']}'),
                          SizedBox(height: 5),
                          Text('Alamat: ${item['alamat']}'),
                          SizedBox(height: 5),
                          Text(
                              'Tanggal Daftar: ${_formatDate(item['tgl_daftar'])}'),
                          SizedBox(height: 5),
                          Text('No Telpon: ${item['no_telpon']}'),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUser(id: itemId),
      ),
    );
  }

  Future<bool?> showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Anda yakin ingin menghapus Data Pengguna ini?'),
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
    await FetchUser.deleteUser(itemId);

    setState(() {});
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
