import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class PengaturanPage extends StatefulWidget {
  @override
  _PengaturanPageState createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  String? _userName;
  String? _role;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Memuat data user saat halaman pertama kali dimuat
  }

  // Fungsi untuk memuat data user dari SharedPreferences
  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'User'; // Mengambil username atau default 'User'
      _role = prefs.getString('role') ?? 'user'; // Mengambil role atau default 'user'
    });
  }

  // Konfirmasi Logout
  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Logout'),
        content: Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: _logout,
            child: Text('Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Fungsi Logout
  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Menghapus semua data user
    Navigator.pushReplacementNamed(context, '/login'); // Kembali ke halaman login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( 
          'Pengaturan',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 132, 169),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context); // Kembali ke halaman sebelumnya jika bisa
            } else {
              Navigator.pushReplacementNamed(context, '/admin-dashboard'); // Jika tidak bisa kembali, arahkan ke home
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _confirmLogout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan nama pengguna dan role
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.pinkAccent,
                  child: Icon(Icons.account_circle, size: 50, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ', $_userName!',
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Role: $_role',
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            Divider(thickness: 2),
            const SizedBox(height: 16),

            // Menu khusus Admin
            if (_role == 'admin') ...[
              ListTile(
                leading: Icon(Icons.security, color: Colors.blue),
                title: Text('Kelola Pengguna', style: GoogleFonts.poppins()),
                onTap: () => Navigator.pushNamed(context, '/kelola-pengguna'),
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.orange),
                title: Text('Pengaturan Aplikasi', style: GoogleFonts.poppins()),
                onTap: () => Navigator.pushNamed(context, '/pengaturan-aplikasi'),
              ),
              ListTile(
                leading: Icon(Icons.add, color: Colors.green),
                title: Text('Tambah Produk', style: GoogleFonts.poppins()),
                onTap: () => Navigator.pushNamed(context, '/tambah-produk'),
              ),
            ],
            const SizedBox(height: 16),

            // Menu Registrasi
            ListTile(
              leading: Icon(Icons.app_registration, color: Colors.teal),
              title: Text('Registrasi Pengguna', style: GoogleFonts.poppins()),
              onTap: () => Navigator.pushNamed(context, '/registrasi'),
            ),
            const SizedBox(height: 30),

            // Tombol Logout
            Center(
              child: ElevatedButton(
                onPressed: _confirmLogout,
                child: Text('Logout', style: GoogleFonts.poppins()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
