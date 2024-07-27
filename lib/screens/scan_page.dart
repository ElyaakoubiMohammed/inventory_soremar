import 'package:flutter/material.dart';
import 'package:soremar_inventory/services/nfc_service.dart';

class ScanTagPage extends StatefulWidget {
  const ScanTagPage({super.key});

  @override
  ScanTagPageState createState() => ScanTagPageState();
}

class ScanTagPageState extends State<ScanTagPage> {
  Future<Map<String, dynamic>>? _scanResult;
  final NfcService _nfcService = NfcService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controller un produit'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 42, 48, 161),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          // Background GIF
          Positioned.fill(
            child: Image.asset(
              'assets/images/scan.gif', // Ensure the path is correct
              fit: BoxFit.cover,
            ),
          ),
          // Foreground content
          Center(
            child: ElevatedButton(
              onPressed: () => _showScanDialog(context),
              child: const Text('Cliquez ici pour scanner une tag NFC'),
            ),
          ),
        ],
      ),
    );
  }

  void _showScanDialog(BuildContext context) {
    setState(() {
      _scanResult = _startNfcScan();
    });

    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing dialog by tapping outside
      builder: (context) => AlertDialog(
        title: const Text('Scan NFC'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/scan.gif', // Ensure the path is correct
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 16),
            const Text(
                'Placez votre téléphone près de l\'étiquette NFC pour scanner.'),
            FutureBuilder<Map<String, dynamic>>(
              future: _scanResult,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final tagData = snapshot.data;
                  final data = tagData?['data'] ?? 'No data';
                  return Text('Data: $data');
                } else {
                  return const Text('No tag detected.');
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> _startNfcScan() async {
    final tag = await _nfcService.startNfcSession();
    if (tag != null) {
      return await _nfcService.readTagData();
    } else {
      return {'data': 'No tag detected.'};
    }
  }
}
