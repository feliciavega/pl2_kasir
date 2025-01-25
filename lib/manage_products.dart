import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageProducts extends StatefulWidget {
  @override
  _ManageProductState createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProducts> {
  List<Map<String, dynamic>> produkList = [];

  @override
  void initState() {
    super.initState();
    _fetchProduk();
  }

  // Mengambil daftar produk dari database
  Future<void> _fetchProduk() async {
    try {
      final response = await Supabase.instance.client.from('produk').select();
      setState(() {
        produkList = response.map<Map<String, dynamic>>((item) {
          return {
            'id_produk': item['id_produk'],
            'name': item['nama_produk'],
            'price': item['harga'],
            'stock': item['stok'],
          };
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kesalahan saat mengambil produk: $e')));
    }
  }

  // Fungsi untuk menambah produk
  Future<void> _tambahProduk(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController stockController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Tambah Produk', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                final name = nameController.text;
                final price = int.tryParse(priceController.text) ?? 0;
                final stock = int.tryParse(stockController.text) ?? 0;
              // tambahkan validasi kolom input tidak boleh kosong, validasi kolom input harus sesuai tipe data
                try {
                  await Supabase.instance.client.from('produk').insert({
                    'nama_produk': name,
                    'harga': price,
                    'stok': stock,
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Produk berhasil ditambahkan')));
                  _fetchProduk();
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Kesalahan: $e')));
                }
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk mengedit produk
  Future<void> _editProduk(BuildContext context, Map<String, dynamic> produk) async {
    TextEditingController nameController = TextEditingController(text: produk['name']);
    TextEditingController priceController = TextEditingController(text: produk['price'].toString());
    TextEditingController stockController = TextEditingController(text: produk['stock'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Edit Produk', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                final name = nameController.text;
                final price = int.tryParse(priceController.text) ?? 0;
                final stock = int.tryParse(stockController.text) ?? 0;

                try {
                  await Supabase.instance.client.from('produk').update({
                    'nama_produk': name,
                    'harga': price,
                    'stok': stock,
                  }).match({'id_produk': produk['id_produk']});

                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Produk berhasil diperbarui')));
                  _fetchProduk();
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Kesalahan: $e')));
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menghapus produk
  Future<void> _hapusProduk(int idProduk) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Konfirmasi Hapus', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await Supabase.instance.client.from('produk').delete().match({'id_produk': idProduk});
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Produk berhasil dihapus')));
                  _fetchProduk();
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Kesalahan: $e')));
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
        title: const Text('Manajemen Produk'),
        backgroundColor: const Color.fromARGB(255, 214, 57, 91),
      ),
      body: produkList.isEmpty
          ? const Center(child: Text('Tidak ada produk', style: TextStyle(fontSize: 18, color: Colors.grey)))
          : ListView.builder(
              itemCount: produkList.length,
              itemBuilder: (context, index) {
                final produk = produkList[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    title: Text(produk['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    subtitle: Text('Harga: Rp${produk['price']}\nStok: ${produk['stock']}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _editProduk(context, produk)),
                        IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _hapusProduk(produk['id_produk'])),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF10034),
        onPressed: () => _tambahProduk(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
