import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    // Inisialisasi AnimationController dengan durasi animasi 1 detik
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    // Inisialisasi animasi dari bawah ke atas
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Memulai animasi saat halaman dimuat
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SlideTransition(
            position: _offsetAnimation,
            child: Text(
              'Selamat datang di Aplikasi Manajemen Buku!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          SlideTransition(
            position: _offsetAnimation,
            child: Text(
              'Lihat statistik jumlah buku berdasarkan jenisnya di grafik pie atau temukan informasi lebih lanjut di daftar buku. Gunakan menu di sebelah kiri untuk menavigasi ke berbagai fitur aplikasi.',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
