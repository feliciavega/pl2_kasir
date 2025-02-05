import 'package:flutter/material.dart'; 
import 'package:supabase_flutter/supabase_flutter.dart'; 
import 'package:pl2_kasir/dashboard.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:google_fonts/google_fonts.dart'; 

// Kelas Login yang merupakan StatefulWidget
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

// State dari kelas Login
class _LoginState extends State<Login> {
  // Controller untuk input username dan password
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Fungsi untuk melakukan proses login
  Future<void> login(BuildContext context) async {
    final String username = usernameController.text.trim(); // Ambil teks dari input username
    final String password = passwordController.text.trim(); // Ambil teks dari input password

    // Validasi jika username atau password kosong
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username dan password tidak boleh kosong')),
      );
      return;
    }

    try {
      // Query ke Supabase untuk mencari user dengan username dan password yang sesuai
      final response = await Supabase.instance.client
          .from('user')
          .select()
          .eq('username', username)
          .eq('password', password)
          .single();

      // Jika tidak ada data yang cocok, login gagal
      if (response == null || response.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Username atau password salah')),
        );
      } else {
        // Ambil role dari response
        String role = response['role'];

        // Simpan username dan role ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userName', username);
        await prefs.setString('role', role);

        // Login berhasil, navigasikan ke Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      }
    } catch (error) {
      // Tangani error jika terjadi kesalahan saat login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff), // Warna latar belakang putih
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 50, 16, 16), // Padding di sekitar halaman
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Column(
                    children: [
                      // Ikon user
                      Icon(
                        Icons.account_circle,
                        size: 90,
                        color: Color.fromARGB(255, 212, 126, 166),
                      ),
                      // Teks "Login dulu"
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 0, 30),
                        child: Text(
                          "Login dulu",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Color.fromARGB(255, 233, 92, 127),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Input Username
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 16),
                  child: TextField(
                    controller: usernameController,
                    obscureText: false,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xff000000),
                    ),
                    decoration: InputDecoration(
                      hintText: "Username",
                      filled: true,
                      fillColor: Color(0xfff2f2f3),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Color.fromARGB(255, 233, 92, 127),
                      ),
                    ),
                  ),
                ),
                // Input Password
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xff000000),
                    ),
                    decoration: InputDecoration(
                      hintText: "Password",
                      filled: true,
                      fillColor: Color(0xfff2f2f3),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Color.fromARGB(255, 233, 92, 127),
                      ),
                    ),
                  ),
                ),
                // Tombol Login
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 16),
                  child: MaterialButton(
                    onPressed: () => login(context), // Panggil fungsi login saat ditekan
                    color: Color.fromARGB(255, 255, 91, 145),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Login",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    textColor: Color(0xffffffff),
                    height: 40,
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
