import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class PenjualanPage extends StatefulWidget {
  @override
  _PenjualanPageState createState() => _PenjualanPageState();
}

class _PenjualanPageState extends State<PenjualanPage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _produkList = [];
  List<Map<String, dynamic>> _cart = [];

  @override
  void initState() {
    super.initState();
    _fetchProduk();
  }

  Future<void> _fetchProduk() async {
    try {
      final response = await _supabase.from('produk').select();
      setState(() {
        _produkList = response.map<Map<String, dynamic>>((item) {
          return {
            'id': item['id'],
            'nama': item['nama_produk'],
            'harga': item['harga'],
          };
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kesalahan saat mengambil produk: $e')),
      );
    }
  }

  void _addToCart(Map<String, dynamic> produk, int jumlah) {
    if (jumlah > 0) {
      setState(() {
        final existingItem = _cart.firstWhere(
            (item) => item['produk']['id'] == produk['id'],
            orElse: () => {});
        if (existingItem.isNotEmpty) {
          existingItem['jumlah'] += jumlah;
          existingItem['totalHarga'] = existingItem['produk']['harga'] * existingItem['jumlah'];
        } else {
          _cart.add({
            'produk': produk,
            'jumlah': jumlah,
            'totalHarga': produk['harga'] * jumlah,
          });
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Jumlah tidak valid!')),
      );
    }
  }

  void _updateCartQuantity(int index, int jumlah) {
    if (jumlah > 0) {
      setState(() {
        _cart[index]['jumlah'] = jumlah;
        _cart[index]['totalHarga'] = _cart[index]['produk']['harga'] * jumlah;
      });
    } else {
      setState(() {
        _cart.removeAt(index);
      });
    }
  }

  Future<void> _checkout() async {
    if (_cart.isNotEmpty) {
      int totalHarga = 0;
      for (var item in _cart) {
       int totalHarga = 0;
for (var item in _cart) {
  int harga = item['produk']['harga']; // Harga produk
  int jumlah = item['jumlah']; // Jumlah produk
  totalHarga += harga * jumlah; // Total harga produk
}

      }

      await _supabase.from('penjualan').insert({
        'total_penjualan': totalHarga,
        'tgl_penjualan': DateTime.now().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaksi berhasil!')),
      );

      setState(() {
        _cart.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Keranjang kosong!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Penjualan', style: GoogleFonts.lato()), // Menggunakan Google Font
        backgroundColor: const Color.fromARGB(255, 255, 132, 169),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Tombol Back Putih
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Produk List
            Expanded(
              child: ListView.builder(
                itemCount: _produkList.length,
                itemBuilder: (context, index) {
                  final produk = _produkList[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(Icons.shopping_bag, color: Colors.blueAccent),
                      title: Text(produk['nama'], style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
                      subtitle: Text('Harga: ${produk['harga']} IDR', style: GoogleFonts.lato()),
                      trailing: IconButton(
                        icon: Icon(Icons.add_shopping_cart, color: Colors.green),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              TextEditingController jumlahController = TextEditingController();
                              return AlertDialog(
                                title: Text('Masukkan Jumlah', style: GoogleFonts.lato()),
                                content: TextField(
                                  controller: jumlahController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(hintText: 'Jumlah'),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      int jumlah = int.tryParse(jumlahController.text) ?? 0;
                                      _addToCart(produk, jumlah);
                                      Navigator.pop(context);
                                    },
                                    child: Text('Tambahkan', style: GoogleFonts.lato()),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            // Keranjang Belanja
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                children: [
                  Text('Keranjang Belanja', style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold)),
                  ..._cart.asMap().entries.map((entry) {
                    int index = entry.key;
                    var item = entry.value;
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                      child: ListTile(
                        leading: Icon(Icons.shopping_bag, color: Colors.blueAccent),
                        title: Text(item['produk']['nama'], style: GoogleFonts.lato()),
                        subtitle: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove, color: Colors.red),
                              onPressed: () {
                                _updateCartQuantity(index, item['jumlah'] - 1);
                              },
                            ),
                            SizedBox(
                              width: 40,
                              child: TextField(
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                controller: TextEditingController(text: item['jumlah'].toString()),
                                onSubmitted: (value) {
                                  int newJumlah = int.tryParse(value) ?? 0;
                                  _updateCartQuantity(index, newJumlah);
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add, color: Colors.green),
                              onPressed: () {
                                _updateCartQuantity(index, item['jumlah'] + 1);
                              },
                            ),
                          ],
                        ),
                        trailing: Text('Total: ${item['totalHarga']} IDR', style: GoogleFonts.lato()),
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _checkout,
                    child: Text('Checkout', style: GoogleFonts.lato(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
