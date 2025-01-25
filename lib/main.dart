import 'package:flutter/material.dart';
import 'package:pl2_kasir/pelanggan.dart';
import 'package:pl2_kasir/transaction_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pl2_kasir/login.dart';
import 'package:pl2_kasir/admin_dashboard.dart'; // Import Admin Dashboard
import 'package:pl2_kasir/manage_products.dart'; // Import Manage Products
import 'package:google_fonts/google_fonts.dart';



Future<void> main() async {
  await Supabase.initialize(
    url: 'https://cbitjegvetfjpfseqizk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNiaXRqZWd2ZXRmanBmc2VxaXprIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYxMjYzNTgsImV4cCI6MjA1MTcwMjM1OH0.DaeWEb_Cpt8qMFoys5gox8GfBN0pe7rfHJlTQ26Ij9o',
  );
  runApp(MyApp());
}
        
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home: Login(),
      routes: {
        '/admin-dashboard': (context) => AdminDashboard(),
        '/kelola-produk': (context) => ManageProducts(),
        '/pelanggan' : (context) => Pelanggan(),
        '/transaksi' : (context) => TransactionPage(),
        // Tambahkan rute lainnya sesuai kebutuhan
      },
    );
  }
}
