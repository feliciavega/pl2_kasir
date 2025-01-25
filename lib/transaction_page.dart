import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<Map<String, dynamic>> transactionList = [];

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    try {
      final response = await Supabase.instance.client.from('transaksi').select();
      setState(() { 
        transactionList = response.map<Map<String, dynamic>>((item) {
          return {
            'id_transaksi': item['id_transaksi'],
            'id_pelanggan': item['id_pelanggan'],
            'tanggal': item['tanggal'],
            'total_harga': item['total_harga'],
          };
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kesalahan saat mengambil transaksi: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Transaksi'),
        backgroundColor: const Color(0xFFF10034),
      ),
      body: transactionList.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada transaksi',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: transactionList.length,
              itemBuilder: (context, index) {
                final transaction = transactionList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      'Pelanggan ID: ${transaction['id_pelanggan']}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Total: Rp${transaction['total_harga']}\nTanggal: ${transaction['tanggal']}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
