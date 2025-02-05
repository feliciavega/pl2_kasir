import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageProducts extends StatefulWidget {
  @override
  _ManageProductState createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProducts> {
  List<Map<String, dynamic>> produkList = [];
  int _selectedIndex = 0; // Menyimpan index yang dipilih

  @override
  void initState() {
    super.initState(); // Memanggil initState() dari superclass untuk memastikan inisialisasi berjalan dengan benar.
    _fetchProduk(); // Memanggil fungsi _fetchProduk() untuk mengambil data produk dari database saat widget pertama kali dibuat.
  }

  // Mengambil daftar produk dari database
 Future<void> _fetchProduk() async {
  try {
    // Mengambil data dari tabel 'produk' di Supabase
    final response = await Supabase.instance.client.from('produk').select();
    
    // Memperbarui state produkList dengan data yang diterima dari database
    setState(() {
      produkList = response.map<Map<String, dynamic>>((item) {
        return {
          'id_produk': item['id_produk'], // Menyimpan ID produk
          'name': item['nama_produk'], // Menyimpan nama produk
          'price': item['harga'], // Menyimpan harga produk
          'stock': item['stok'], // Menyimpan stok produk
        };
      }).toList(); // Mengonversi hasil query menjadi daftar (list)
    });
  } catch (e) {
    // Menampilkan pesan error jika terjadi kesalahan saat mengambil data
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kesalahan saat mengambil produk: $e')));
  }
}


  // Fungsi untuk menambah produk
  Future<void> _tambahProduk(BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController stockController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Tambah Produk', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama Produk',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Nama produk tidak boleh kosong';
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Harga',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga tidak boleh kosong';
                    }
                    final price = int.tryParse(value);
                    if (price == null || price <= 0) {
                      return 'Masukkan harga dengan benar';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Stok',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Stok tidak boleh kosong';
                    }
                    final stock = int.tryParse(value);
                    if (stock == null || stock <= 0) {
                      return 'Input yang Anda masukkan tidak valid.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text('Batal', style: GoogleFonts.poppins(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final name = nameController.text;
                  final price = int.parse(priceController.text);
                  final stock = int.parse(stockController.text);

                  try {
                    await Supabase.instance.client.from('produk').insert({
                      'nama_produk': name,
                      'harga': price,
                      'stok': stock,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Produk berhasil ditambahkan')));
                    _fetchProduk();
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Kesalahan: $e')));
                  }
                }
              },
              child: Text('Tambah', style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk mengedit produk
  Future<void> _editProduk(BuildContext context, Map<String, dynamic> produk) async {
    final _formKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController(text: produk['name']);
    TextEditingController priceController = TextEditingController(text: produk['price'].toString());
    TextEditingController stockController = TextEditingController(text: produk['stock'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Edit Produk', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama Produk',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Nama produk tidak boleh kosong';
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Harga',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga tidak boleh kosong';
                    }
                    final price = int.tryParse(value);
                    if (price == null || price <= 0) {
                      return 'Masukkan harga dengan benar';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Stok',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Stok tidak boleh kosong';
                    }
                    final stock = int.tryParse(value);
                    if (stock == null || stock <= 0) {
                      return 'Input yang Anda masukkan tidak valid.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Text('Batal', style: GoogleFonts.poppins(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
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
                        SnackBar(content: Text('Produk berhasil diperbarui')));
                    _fetchProduk();
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Kesalahan: $e')));
                  }
                }
              },
              child: Text('Simpan', style: GoogleFonts.poppins()),
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
          title: Text('Konfirmasi Hapus', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text('Batal', style: GoogleFonts.poppins(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await Supabase.instance.client.from('produk').delete().match({'id_produk': idProduk});
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Produk berhasil dihapus')));
                  _fetchProduk();
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Kesalahan: $e')));
                }
              },
              child: Text('Hapus', style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk mengubah halaman berdasarkan pilihan di BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manajemen Produk', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 255, 132, 169),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                onPressed: () {
                  Navigator.pop(context);
                },
                splashRadius: 24,
              )
            : null,
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
                    title: Text(produk['name'], style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                    subtitle: Text('Harga: Rp${produk['price']}\nStok: ${produk['stock']}', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editProduk(context, produk),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _hapusProduk(produk['id_produk']),
                        ),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}