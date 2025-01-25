import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Pelanggan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: alamatController,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: noTelpController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'No Telp',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () async {
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Pelanggan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: alamatController,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: noTelpController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'No Telp',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () async {
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
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.red)),
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
        title: const Text('Manajemen Pelanggan'),
        backgroundColor: const Color.fromARGB(255, 214, 57, 91),
      ),
      body: pelangganList.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada pelanggan',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: pelangganList.length,
              itemBuilder: (context, index) {
                final pelanggan = pelangganList[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    title: Text(
                      pelanggan['name'],
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${pelanggan['alamat']}\n${pelanggan['no_telp']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () =>
                              _editPelanggan(context, pelanggan),
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _hapusPelanggan(pelanggan['id_pelanggan']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF10034),
        onPressed: () => _tambahPelanggan(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
