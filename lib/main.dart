import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pl2_kasir/login.dart'; 
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://cbitjegvetfjpfseqizk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNiaXRqZWd2ZXRmanBmc2VxaXprIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYxMjYzNTgsImV4cCI6MjA1MTcwMjM1OH0.DaeWEb_Cpt8qMFoys5gox8GfBN0pe7rfHJlTQ26Ij9o',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login dulu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
