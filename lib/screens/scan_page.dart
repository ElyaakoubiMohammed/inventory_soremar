import 'package:flutter/material.dart';
import 'package:soremar_inventory/services/nfc_service.dart';
import 'package:nfc_manager/nfc_manager.dart';

class ScanTagPage extends StatefulWidget {
  const ScanTagPage({super.key});

  @override
  ScanTagPageState createState() => ScanTagPageState();
}

class ScanTagPageState extends State<ScanTagPage> {
  bool _isScanning = false;
  String _scanMessage =
      'Placez votre téléphone près de l\'étiquette NFC pour scanner.';

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
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing dialog by tapping outside
      builder: (context) {
        _startNfcScan();
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
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
                  Text(_scanMessage),
                  if (_isScanning) const CircularProgressIndicator(),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _stopNfcScan();
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _startNfcScan() async {
    setState(() {
      _isScanning = true;
      _scanMessage =
          'Placez votre téléphone près de l\'étiquette NFC pour scanner.';
    });

    try {
      final tag = await _nfcService.startNfcSession();
      if (tag != null) {
        final data = await _nfcService.readUltralightData(tag);
        setState(() {
          _scanMessage = 'Data: $data';
        });
      } else {
        setState(() {
          _scanMessage = 'No tag detected.';
        });
      }
    } catch (e) {
      setState(() {
        _scanMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isScanning = false;
      });
    }
  }

  void _stopNfcScan() {
    NfcManager.instance.stopSession();
    setState(() {
      _isScanning = false;
    });
  }

  @override
  void dispose() {
    _stopNfcScan();
    super.dispose();
  }
}
