import 'package:flutter/material.dart';
import 'package:pl2_kasir/pengaturan_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? _userName;
  String? _role; // Menambahkan role
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Memanggil method untuk memuat username dan role
  }

 Future<void> _loadUserData() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    _userName = prefs.getString('userName') ?? 'User'; // Menampilkan username yang sesuai dengan yang login
    _role = prefs.getString('role') ?? 'user'; // Default ke 'user' jika role tidak ada
  });
}



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: _selectedIndex == 0
          ? Text(
              'Hello, $_userName', // Menampilkan username hanya di Dashboard
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
              ),
            )
          : null, // Tidak menampilkan title di halaman selain Dashboard
      centerTitle: true,
      backgroundColor: const Color.fromARGB(255, 255, 132, 169),
      actions: [
        if (_selectedIndex == 0) // Menambahkan logout hanya pada halaman Dashboard
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
      ],
    ),
    body: _getBody(), // Mengganti dengan logika pengaturan body
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Colors.orange[900],
      unselectedItemColor: Colors.black,
      backgroundColor: Colors.white,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: _buildNavigationItems(), // Memanggil fungsi untuk menentukan item bottom nav
    ),
  );
}


  // Fungsi untuk menentukan item bottom navigation bar berdasarkan role
  List<BottomNavigationBarItem> _buildNavigationItems() {
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Dashboard',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Pengaturan',
      ),
    ];
  }

  // Fungsi untuk menentukan body yang sesuai dengan indeks
  Widget _getBody() {
    if (_role == 'admin') {
      switch (_selectedIndex) {
        case 0:
          return _buildDashboardBody(); // Isi halaman dashboard untuk admin
        case 1:
          return PengaturanPage(); // Halaman Pengaturan
        default:
          return _buildDashboardBody(); // Default ke Dashboard
      }
    } else {
      switch (_selectedIndex) {
        case 0:
          return _buildDashboardBody(); // Isi halaman dashboard untuk petugas
        case 1:
          return PengaturanPage(); // Halaman Pengaturan
        default:
          return _buildDashboardBody(); // Default ke Dashboard
      }
    }
  }

  // Body untuk dashboard
  Widget _buildDashboardBody() {
    // Daftar menu yang berbeda berdasarkan role
    final List<Map<String, dynamic>> menuItems = _role == 'admin'
        ? [
            {
              'icon': Icons.shopping_bag,
              'title': 'Kelola Produk',
              'route': '/kelola-produk',  // Navigasi ke halaman Produk
              'color': Color.fromARGB(255, 0, 143, 76),
            },
            {
              'icon': Icons.people,
              'title': 'Pelanggan',
              'route': '/pelanggan',  // Navigasi ke halaman Pelanggan
              'color': Color.fromARGB(255, 241, 19, 86),
            },
            {
              'icon': Icons.add_box,
              'title': 'Registrasi',
              'route': '/registrasi',  // Navigasi ke halaman Registrasi
              'color': Color.fromARGB(255, 255, 165, 0),
            },
          ]
        : [
            {
              'icon': Icons.storefront,
              'title': 'Penjualan',
              'route': '/penjualan',  // Navigasi ke halaman Penjualan
              'color': Color.fromARGB(255, 0, 128, 255),
            },
            {
              'icon': Icons.history,
              'title': 'Detail Penjualan',
              'route': '/riwayat-penjualan',  // Navigasi ke halaman Detil Penjualan
              'color': Color.fromARGB(255, 0, 255, 0),
            },
          ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final menu = menuItems[index];
          return _buildMenuCard(
            context,
            menu['icon'],
            menu['title'],
            menu['route'],
            menu['color'],
          );
        },
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
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
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
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
