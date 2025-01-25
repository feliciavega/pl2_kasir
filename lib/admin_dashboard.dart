 import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 214, 57, 91),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 214, 57, 91),
              ),
              child: Text(
                'Admin Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text('Kelola Produk'),
              onTap: () {
                Navigator.pushNamed(context, '/kelola-produk');
              },
            ),
            ListTile(
              title: const Text('Pelanggan'),
              onTap: () {
                Navigator.pushNamed(context, '/pelanggan');
              },
            ),
            ListTile(
              title: const Text('Transaksi'),
              onTap: () {
                Navigator.pushNamed(context, '/transaksi');
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat Datang, Admin!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Statistik Ringkas
            const SizedBox(height: 32),
            // Menu Navigasi
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _menuItems.length,
                itemBuilder: (context, index) {
                  final menu = _menuItems[index];
                  return _buildMenuCard(
                    context,
                    menu['icon'],
                    menu['title'],
                    menu['route'],
                    menu['color'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, IconData icon, String title, String routeName, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> _menuItems = [
  {
    'icon': Icons.shopping_bag,
    'title': 'Kelola Produk',
    'route': '/kelola-produk',
    'color': const Color.fromARGB(255, 241, 0, 52),
  },
  {
    'icon' : Icons.people,
    'title' : 'Pelanggan',
    'route' : '/pelanggan',
    'color' : const Color.fromARGB(255, 0, 65, 187),
  },
  {
    'icon': Icons.receipt_long,
    'title': 'Transaksi',
    'route': '/transaksi',
    'color': const Color.fromARGB(255, 0, 187, 0),
  },
];
