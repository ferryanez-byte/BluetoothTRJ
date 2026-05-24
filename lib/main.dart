import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

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

class LoginFormUI extends StatelessWidget {
  const LoginFormUI({super.key});

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
              child: const Column(
                children: [
                  Icon(Icons.security, size: 80, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "BT-Secure Login",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Username / NPM',
                        labelStyle: TextStyle(color: Color(0xFF007E7B)),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color(0xFF007E7B),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password / Hex Key',
                        labelStyle: TextStyle(color: Color(0xFF007E7B)),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock, color: Color(0xFF007E7B)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const BluetoothDiscoveryPage(),
                          ),
                        );
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
// HALAMAN BLUETOOTH DISCOVERY
// ============================================================================
class BluetoothDiscoveryPage extends StatefulWidget {
  const BluetoothDiscoveryPage({super.key});

  @override
  State<BluetoothDiscoveryPage> createState() => _BluetoothDiscoveryPageState();
}

class _BluetoothDiscoveryPageState extends State<BluetoothDiscoveryPage> {
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  List<BluetoothDiscoveryResult> results = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    _checkBluetoothStatus();
  }

  void _checkBluetoothStatus() async {
    bool? isEnabled = await _bluetooth.isEnabled;
    if (isEnabled == false) {
      await _bluetooth.requestEnable();
    }
  }

  void _startDiscovery() {
    setState(() {
      results.clear();
      isScanning = true;
    });

    _bluetooth
        .startDiscovery()
        .listen((r) {
          // ✅ Tantangan 1: Filter hanya nama berawalan 'TRJ'
          final name = r.device.name ?? '';
          if (!name.startsWith('TRJ')) return;

          setState(() {
            final existingIndex = results.indexWhere(
              (element) => element.device.address == r.device.address,
            );
            if (existingIndex >= 0) {
              results[existingIndex] = r;
            } else {
              results.add(r);
            }
          });
        })
        .onDone(() {
          setState(() {
            isScanning = false;
          });
        });
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
          // Banner Info
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
                      "Tekan ikon refresh di atas untuk memindai",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      BluetoothDiscoveryResult result = results[index];
                      final device = result.device;
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.bluetooth,
                            color: Color(0xFF007E7B),
                          ),
                          title: Text(device.name ?? 'Perangkat Tanpa Nama'),
                          // ✅ Tantangan 2: MAC Address + RSSI
                          subtitle: Text(
                            'MAC: ${device.address}  |  RSSI: ${result.rssi} dBm',
                          ),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00C9A7),
                            ),
                            onPressed: () {
                              debugPrint('Menghubungkan ke: ${device.address}');
                            },
                            child: const Text(
                              'Pair',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // ✅ Tantangan 3: Watermark Nama & NPM
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: const Color(0xFF007E7B),
            child: const Column(
              children: [
                Text(
                  'Ferryan Narding',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
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
