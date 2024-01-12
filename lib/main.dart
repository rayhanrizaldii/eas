import 'package:eas/pages/HomePage.dart';
import 'package:eas/pages/book/Add_Book.dart';
import 'package:eas/pages/book/Book_Page.dart';
import 'package:eas/pages/user/Add_User.dart';
import 'package:eas/pages/user/User_Page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: '1462100047 | EAS',
      home: MyDrawer(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    AddUser(),
    AddBook(),
    UserPage(),
    BookPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text('1462100047'),
        elevation: 0,
        backgroundColor: Color(0xff7FC7D9),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xff7FC7D9),
        ),
        child: _widgetOptions[_selectedIndex],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Admin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0xff7FC7D9),
                borderRadius: BorderRadiusDirectional.only(
                  bottomStart: Radius.circular(50),
                ),
              ),
            ),
            ListTile(
              leading: Icon(FlutterRemix.home_2_fill),
              title: const Text('Home'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(FlutterRemix.user_add_fill),
              title: const Text('Tambah Pengguna'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(FlutterRemix.contacts_book_upload_fill),
              title: const Text('Tambah Buku'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            Divider(
              color: Colors.black26,
            ),
            ListTile(
              leading: Icon(FlutterRemix.user_search_fill),
              title: const Text('Laporan Pengguna'),
              selected: _selectedIndex == 3,
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(FlutterRemix.book_read_fill),
              title: const Text('Laporan Buku'),
              selected: _selectedIndex == 4,
              onTap: () {
                _onItemTapped(4);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
