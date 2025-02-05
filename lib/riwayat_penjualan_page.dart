import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RiwayatPenjualanPage extends StatefulWidget {
  @override
  _RiwayatPenjualanPageState createState() => _RiwayatPenjualanPageState();
}

class _RiwayatPenjualanPageState extends State<RiwayatPenjualanPage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _riwayatPenjualan = [];

  @override
  void initState() { 
    super.initState();
    _fetchRiwayatPenjualan();
  }

  Future<void> _fetchRiwayatPenjualan() async {
    try {
      final response = await _supabase.from('penjualan').select().order('tgl_penjualan', ascending: false);
      setState(() {
        _riwayatPenjualan = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil riwayat penjualan: $e')),
      );
    }
  }

  Future<void> _fetchDetailPenjualan(int idPenjualan) async {
    try {
      final response = await _supabase
          .from('detail_penjualan')
          .select('id_produk, jumlah, total_harga, produk(nama_produk)')
          .eq('id_penjualan', idPenjualan);
      
      List<Map<String, dynamic>> detail = List<Map<String, dynamic>>.from(response);
      
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Detail Penjualan #$idPenjualan'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: detail.map((item) {
                return ListTile(
                  title: Text(item['produk']['nama_produk']),
                  subtitle: Text('Jumlah: ${item['jumlah']}'),
                  trailing: Text('Rp ${item['total_harga']}'),
                );
              }).toList(),
            ),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil detail penjualan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Penjualan'),
        backgroundColor: const Color.fromARGB(255, 255, 132, 169),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _riwayatPenjualan.isEmpty
            ? Center(child: Text('Tidak ada riwayat penjualan'))
            : ListView.builder(
                itemCount: _riwayatPenjualan.length,
                itemBuilder: (context, index) {
                  final penjualan = _riwayatPenjualan[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text('Tanggal: ${penjualan['tgl_penjualan']}'),
                      subtitle: Text('Total: Rp ${penjualan['total_penjualan']}'),
                      onTap: () => _fetchDetailPenjualan(penjualan['id_penjualan']),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
