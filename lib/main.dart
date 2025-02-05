import 'package:flutter/material.dart';
import 'package:pl2_kasir/pelanggan.dart';
import 'package:pl2_kasir/pengaturan_page.dart';
import 'package:pl2_kasir/penjualan_page.dart';
import 'package:pl2_kasir/registrasi_page.dart';
import 'package:pl2_kasir/riwayat_penjualan_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pl2_kasir/login.dart';
import 'package:pl2_kasir/dashboard.dart'; 
import 'package:pl2_kasir/manage_products.dart'; 
import 'package:google_fonts/google_fonts.dart';

// Fungsi utama aplikasi, menjalankan inisialisasi Supabase lalu menjalankan aplikasi Flutter
Future<void> main() async {
  // Inisialisasi Supabase dengan URL dan kunci anon
  await Supabase.initialize(
    url: 'https://cbitjegvetfjpfseqizk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNiaXRqZWd2ZXRmanBmc2VxaXprIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYxMjYzNTgsImV4cCI6MjA1MTcwMjM1OH0.DaeWEb_Cpt8qMFoys5gox8GfBN0pe7rfHJlTQ26Ij9o',
  );
  runApp(MyApp()); // Menjalankan aplikasi utama
}

// Kelas utama aplikasi yang merupakan StatelessWidget
class MyApp extends StatelessWidget { 
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(), // Menggunakan font Poppins
      ),
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      home: Login(), // Halaman pertama yang akan ditampilkan saat aplikasi dibuka
      routes: {
        '/admin-dashboard': (context) => Dashboard(), // Rute untuk halaman dashboard admin
        '/kelola-produk': (context) => ManageProducts(), // Rute untuk halaman kelola produk
        '/pelanggan' : (context) => Pelanggan(), // Rute untuk halaman pelanggan
        '/penjualan' : (context) => PenjualanPage(), // Rute untuk halaman penjualan
        '/riwayat-penjualan' : (context) => RiwayatPenjualanPage(), // Rute untuk halaman riwayat penjualan
        '/pengaturan' : (context) => PengaturanPage(), // Rute untuk halaman pengaturan
        '/registrasi' : (context) => RegistrasiPage(), // Rute untuk halaman registrasi
        'login' : (context) => Login(), // Rute untuk halaman login
      },
    );
  }
}
