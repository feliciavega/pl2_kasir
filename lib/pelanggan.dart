import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Pelanggan extends StatefulWidget {
  @override
  _PelangganState createState() => _PelangganState();
}

class _PelangganState extends State<Pelanggan> {
  List<Map<String, dynamic>> pelangganList = [];

  @override
  void initState() {
    super.initState();
    _fetchPelanggan();
  }

  // Mengambil daftar pelanggan dari database
  Future<void> _fetchPelanggan() async {
    try {
      final response =
          await Supabase.instance.client.from('pelanggan').select();
      setState(() {
        pelangganList = response.map<Map<String, dynamic>>((item) {
          return {
            'id_pelanggan': item['id_pelanggan'],
            'name': item['nama_pelanggan'],
            'alamat': item['alamat'],
            'no_telp': item['no_telp'],
          };
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kesalahan saat mengambil pelanggan: $e')),
      );
    }
  }

  // Fungsi untuk menambah pelanggan
  Future<void> _tambahPelanggan(BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController();
    TextEditingController alamatController = TextEditingController();
    TextEditingController noTelpController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Tambah Pelanggan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama Pelanggan',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama pelanggan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: alamatController,
                  decoration: InputDecoration(
                    labelText: 'Alamat',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: noTelpController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'No Telp',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor telepon tidak boleh kosong';
                    } else if (!RegExp(r'^\+?[0-9]{10,12}$').hasMatch(value)) {
                      return 'Nomor telepon tidak valid';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Warna latar belakang merah untuk tombol batal
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Membuat tombol lebih bulat
                ),
              ),
              child: const Text('Batal', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final name = nameController.text.trim();
                  final alamat = alamatController.text.trim();
                  final noTelp = noTelpController.text.trim();

                  try {
                    await Supabase.instance.client.from('pelanggan').insert({
                      'nama_pelanggan': name,
                      'alamat': alamat,
                      'no_telp': noTelp,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pelanggan berhasil ditambahkan'),
                      ),
                    );
                    _fetchPelanggan();
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Kesalahan: $e')),
                    );
                  }
                }
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk mengedit pelanggan
  Future<void> _editPelanggan(BuildContext context, Map<String, dynamic> pelanggan) async {
    final _formKey = GlobalKey<FormState>();
    TextEditingController nameController =
        TextEditingController(text: pelanggan['name']);
    TextEditingController alamatController =
        TextEditingController(text: pelanggan['alamat']);
    TextEditingController noTelpController =
        TextEditingController(text: pelanggan['no_telp']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Edit Pelanggan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama Pelanggan',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama pelanggan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: alamatController,
                  decoration: InputDecoration(
                    labelText: 'Alamat',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: noTelpController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'No Telp',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor telepon tidak boleh kosong';
                    } else if (!RegExp(r'^\+?[0-9]{10,12}$').hasMatch(value)) {
                      return 'Nomor telepon tidak valid';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Warna latar belakang merah untuk tombol batal
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Membuat tombol lebih bulat
                ),
              ),
              child: const Text('Batal', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final name = nameController.text.trim();
                  final alamat = alamatController.text.trim();
                  final noTelp = noTelpController.text.trim();

                  try {
                    await Supabase.instance.client
                        .from('pelanggan')
                        .update({
                      'nama_pelanggan': name,
                      'alamat': alamat,
                      'no_telp': noTelp,
                    }).match({'id_pelanggan': pelanggan['id_pelanggan']});

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pelanggan berhasil diperbarui'),
                      ),
                    );
                    _fetchPelanggan();
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Kesalahan: $e')),
                    );
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menghapus pelanggan
  Future<void> _hapusPelanggan(int idPelanggan) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Konfirmasi Hapus',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('Apakah Anda yakin ingin menghapus pelanggan ini?'),
           actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Warna latar belakang merah untuk tombol batal
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Membuat tombol lebih bulat
                ),
              ),
              child: const Text('Batal', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await Supabase.instance.client
                      .from('pelanggan')
                      .delete()
                      .match({'id_pelanggan': idPelanggan});

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pelanggan berhasil dihapus')),
                  );
                  _fetchPelanggan();
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Kesalahan: $e')),
                  );
                }
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pelanggan'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              _tambahPelanggan(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          color: Colors.white, // Ubah warna back button menjadi putih
        ),
      ),
      body: pelangganList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: pelangganList.length,
              itemBuilder: (context, index) {
                final pelanggan = pelangganList[index];
                return ListTile(
                  title: Text(pelanggan['name'],
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  subtitle: Text('Alamat: ${pelanggan['alamat']}\nNo Telp: ${pelanggan['no_telp']}'),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _editPelanggan(context, pelanggan);
                      } else if (value == 'delete') {
                        _hapusPelanggan(pelanggan['id_pelanggan']);
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ];
                    },
                  ),
                );
              },
            ),
    );
  }
}
