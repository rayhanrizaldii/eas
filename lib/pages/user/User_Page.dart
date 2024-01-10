import 'package:eas/pages/user/Edit_User.dart';
import 'package:eas/services/user/fetchUser.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        height: 600,
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card buildListItem(Map<String, dynamic> item) {
    int itemId = int.parse(item['id']);

    return Card(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      clipBehavior: Clip.hardEdge,
      child: Dismissible(
        key: Key(itemId.toString()),
        background: Container(
          color: Color(0xfff001B79),
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                      'http://192.168.110.215:8080/eas/pengguna/images/' +
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
