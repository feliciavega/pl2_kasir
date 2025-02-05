import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegistrasiPage extends StatefulWidget {
  @override
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  String _userName = '';
  String _email = '';
  String _password = '';
  String _role = 'User'; // Default role "User"

  final SupabaseClient _supabase = SupabaseClient('your-supabase-url', 'your-anon-key'); 

  // Menyimpan data user yang dimasukkan ke Supabase
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Menambahkan data user baru ke Supabase
        final response = await _supabase
            .from('users') // Nama tabel
            .insert([
              {
                'username': _userName,
                'password': _password, // Pastikan password dienkripsi
                'role': _role,  // Menyertakan role yang dipilih
                'created_at': DateTime.now().toIso8601String(),
              }
            ]).select() // Mengambil data yang baru saja dimasukkan (optional)
            .single(); // Mendapatkan hasil satu baris data

        if (response != null) {
          // Berhasil
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registrasi Berhasil!')),
          );
          // Navigasi ke halaman lain setelah berhasil registrasi
          Navigator.pop(context);
        }
      } catch (error) {
        // Menangani kesalahan
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registrasi Gagal: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registrasi Pengguna Baru',
          style: GoogleFonts.poppins(fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 132, 169),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input untuk Nama
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _userName = value;
                    });
                  },
                ),
                // Input untuk Email
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
                // Input untuk Password
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
                // Dropdown untuk memilih Role
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Role'),
                  value: _role,
                  items: <String>['Admin', 'User']
                      .map((role) => DropdownMenuItem<String>(
                            value: role,
                            child: Text(role),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _role = value!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                // Tombol untuk Submit
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Daftar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 132, 169),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 16),
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
