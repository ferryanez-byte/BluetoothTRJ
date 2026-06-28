import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const Scaffold(
        backgroundColor: Color(0xFFF5F7FB),
        body: SafeArea(child: LoginFormUI()),
      ),
    );
  }
}

// ============================================================================
// MOCK DATA — Simulasi perangkat Bluetooth
// ============================================================================
class MockBluetoothDevice {
  final String name;
  final String address;
  final int rssi;
  MockBluetoothDevice(
      {required this.name, required this.address, required this.rssi});
}

final List<MockBluetoothDevice> _mockDevices = [
  MockBluetoothDevice(
      name: 'TRJ-Lab-01', address: 'AA:BB:CC:DD:EE:01', rssi: -55),
  MockBluetoothDevice(
      name: 'TRJ-Lab-02', address: 'AA:BB:CC:DD:EE:02', rssi: -62),
  MockBluetoothDevice(
      name: 'TRJ-Sensor-A', address: 'AA:BB:CC:DD:EE:03', rssi: -70),
  MockBluetoothDevice(
      name: 'TRJ-Router-X', address: 'AA:BB:CC:DD:EE:04', rssi: -48),
  MockBluetoothDevice(
      name: 'OTHER-Device', address: 'FF:FF:FF:FF:FF:01', rssi: -80),
  MockBluetoothDevice(
      name: 'Samsung-TV', address: 'FF:FF:FF:FF:FF:02', rssi: -75),
];

// ============================================================================
// HALAMAN 1: FORM LOGIN
// ============================================================================
class LoginFormUI extends StatefulWidget {
  const LoginFormUI({super.key});
  @override
  State<LoginFormUI> createState() => _LoginFormUIState();
}

class _LoginFormUIState extends State<LoginFormUI> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Gradien
            Container(
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00C9A7), Color(0xFF00A38D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Logo Politeknik Driyorejo (icon kampus)
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.school,
                      size: 55,
                      color: Color(0xFF007E7B),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    "Politeknik Driyorejo",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "BT-Secure Login",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // Card Form
            Card(
              elevation: 4,
              margin: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _userController,
                      decoration: const InputDecoration(
                        labelText: 'Username / NPM',
                        labelStyle: TextStyle(color: Color(0xFF007E7B)),
                        border: OutlineInputBorder(),
                        prefixIcon:
                            Icon(Icons.person, color: Color(0xFF007E7B)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password / Hex Key',
                        labelStyle: TextStyle(color: Color(0xFF007E7B)),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock, color: Color(0xFF007E7B)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        String inputNama = _userController.text;
                        String inputNpm = _passController.text;
                        if (inputNama.isNotEmpty && inputNpm.length >= 3) {
                          // --------------------------------------------------
                          // GENERATE TOKEN SESI — aturan kriptografi:
                          // 1. 3 huruf pertama Username → HURUF KAPITAL
                          // 2. 3 digit terakhir Password/NPM
                          // 3. Detik sistem saat tombol ditekan
                          // Format hasil: "FER-601-42"
                          // --------------------------------------------------
                          final String prefix = inputNama
                              .substring(0,
                                  inputNama.length >= 3 ? 3 : inputNama.length)
                              .toUpperCase();
                          final String suffix = inputNpm.length >= 3
                              ? inputNpm.substring(inputNpm.length - 3)
                              : inputNpm;
                          final int detik = DateTime.now().second;
                          final String token = '$prefix-$suffix-$detik';

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DashboardPage(
                                nama: inputNama,
                                npm: inputNpm,
                                tokenSesi: token,
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: const Color(0xFF007E7B),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'MASUK KE SISTEM',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Lab Komdat - Politeknik Driyorejo",
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// HALAMAN 2: DASHBOARD
// ============================================================================
class DashboardPage extends StatefulWidget {
  final String nama;
  final String npm;
  final String tokenSesi;

  const DashboardPage({
    super.key,
    required this.nama,
    required this.npm,
    required this.tokenSesi,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const MenuChat(),
      const MenuHistory(),
      MenuProfile(
        namaUser: widget.nama,
        npmUser: widget.npm,
        tokenSesi: widget.tokenSesi,
      ),
    ];
  }

  // Dialog konfirmasi logout
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.logout, color: Color(0xFF007E7B)),
              SizedBox(width: 8),
              Text('Konfirmasi Logout'),
            ],
          ),
          content: const Text('Apakah kamu yakin ingin keluar dari sistem?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx); // tutup dialog
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Scaffold(
                      backgroundColor: Color(0xFFF5F7FB),
                      body: SafeArea(child: LoginFormUI()),
                    ),
                  ),
                  (route) => false, // hapus semua route sebelumnya
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007E7B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Logout'),
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
        title: const Row(
          children: [
            Icon(Icons.school, color: Colors.white, size: 22),
            SizedBox(width: 8),
            Text(
              'Politeknik Driyorejo',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF007E7B),
        automaticallyImplyLeading: false,
        actions: [
          // Tombol Logout di AppBar
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF007E7B),
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}

// ============================================================================
// SUB MENU TAB PANELS
// ============================================================================
class MenuChat extends StatelessWidget {
  const MenuChat({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.chat_bubble_outline,
              size: 80, color: Color(0xFF007E7B)),
          const SizedBox(height: 16),
          const Text(
            'Ruang Obrolan BT-Secure',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const BluetoothDiscoveryPage()),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007E7B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'CARI PERANGKAT BLUETOOTH',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuHistory extends StatelessWidget {
  const MenuHistory({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Riwayat Dekripsi Obrolan Kosong',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}

class MenuProfile extends StatelessWidget {
  final String namaUser;
  final String npmUser;
  final String tokenSesi;

  const MenuProfile({
    super.key,
    required this.namaUser,
    required this.npmUser,
    required this.tokenSesi,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 45,
            backgroundColor: Color(0xFF007E7B),
            child: Icon(Icons.person, size: 45, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(namaUser,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'TOKEN REKONSILIASI: $tokenSesi',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF007E7B),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text('NPM: $npmUser',
              style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }
}

// ============================================================================
// HALAMAN 3: BLUETOOTH DISCOVERY — SIMULASI
// ============================================================================
class BluetoothDiscoveryPage extends StatefulWidget {
  const BluetoothDiscoveryPage({super.key});
  @override
  State<BluetoothDiscoveryPage> createState() => _BluetoothDiscoveryPageState();
}

class _BluetoothDiscoveryPageState extends State<BluetoothDiscoveryPage> {
  List<MockBluetoothDevice> results = [];
  bool isScanning = false;

  void _startDiscovery() async {
    setState(() {
      results.clear();
      isScanning = true;
    });

    final random = Random();

    for (final device in _mockDevices) {
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;

      // ✅ Tantangan 1: Filter hanya nama berawalan 'TRJ'
      if (!device.name.startsWith('TRJ')) continue;

      setState(() {
        final int rssiVariasi = device.rssi + random.nextInt(6) - 3;
        final existing = results.indexWhere((e) => e.address == device.address);
        final updated = MockBluetoothDevice(
          name: device.name,
          address: device.address,
          rssi: rssiVariasi,
        );
        if (existing >= 0) {
          results[existing] = updated;
        } else {
          results.add(updated);
        }
      });
    }

    if (mounted) setState(() => isScanning = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scan Perangkat Lab',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF007E7B),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          isScanning
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: _startDiscovery,
                ),
        ],
      ),
      body: Column(
        children: [
          // ✅ Banner counter
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.teal[50],
            child: Row(
              children: [
                const Icon(Icons.bluetooth_searching, color: Color(0xFF007E7B)),
                const SizedBox(width: 10),
                Text(
                  'Ditemukan: ${results.length} Perangkat',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF007E7B),
                  ),
                ),
              ],
            ),
          ),

          // Daftar Perangkat
          Expanded(
            child: results.isEmpty && !isScanning
                ? const Center(
                    child: Text(
                      'Tekan ikon refresh di atas untuk memindai',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final device = results[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: const Icon(Icons.bluetooth,
                              color: Color(0xFF007E7B)),
                          title: Text(device.name),
                          // ✅ Tantangan 2: MAC + RSSI
                          subtitle: Text(
                              'MAC: ${device.address}  |  RSSI: ${device.rssi} dBm'),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00C9A7),
                            ),
                            onPressed: () {
                              debugPrint('Pairing target: ${device.address}');
                            },
                            child: const Text('Pair',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // ✅ Tantangan 3: Watermark
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: const Color(0xFF007E7B),
            child: const Column(
              children: [
                Text(
                  'Ferryan Narding',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  'NPM: 2425260601',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
