import 'package:flutter/material.dart';
import 'package:soremar_inventory/services/nfc_service.dart';

class ScanTagPage extends StatefulWidget {
  const ScanTagPage({super.key});

  @override
  ScanTagPageState createState() => ScanTagPageState();
}

class ScanTagPageState extends State<ScanTagPage> {
  final NfcService _nfcService = NfcService();
  bool _isScanning = false;
  String _scanMessage =
      'Placez votre téléphone près de l\'étiquette NFC pour scanner.';

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startReadingTag,
                  child: const Text('Lire l\'étiquette NFC'),
                ),
                SizedBox(height: 16), // Add some spacing between buttons
                ElevatedButton(
                  onPressed: _eraseTag,
                  child: const Text('Effacer l\'étiquette NFC'),
                ),
                SizedBox(height: 16),

                if (_isScanning) const CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(_scanMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _startReadingTag() async {
    if (_isScanning) return; // Prevent starting multiple operations

    setState(() {
      _isScanning = true;
      _scanMessage = 'Lecture en cours...';
    });

    try {
      await _nfcService.startScanning(
        (data) {
          setState(() {
            _scanMessage = 'Hex Data: $data';
          });
          _stopScan();
        },
        (error) {
          setState(() {
            _scanMessage = 'Error: $error';
          });
          _stopScan();
        },
      );
    } catch (e) {
      setState(() {
        _scanMessage = 'Error: ${e.toString()}';
      });
    } finally {
      _stopScan(); // Ensure the session is stopped in the finally block
    }
  }

  Future<void> _eraseTag() async {
    if (_isScanning) return; // Prevent starting multiple operations

    setState(() {
      _isScanning = true;
      _scanMessage = 'Étiquette effacement en cours...';
    });

    try {
      await _nfcService.eraseTag();
      setState(() {
        _scanMessage = 'Étiquette effacée avec succès.';
      });
    } catch (e) {
      setState(() {
        _scanMessage = 'Error: ${e.toString()}';
      });
    } finally {
      _stopScan(); // Ensure the session is stopped in the finally block
    }
  }

  void _stopScan() {
    _nfcService.stopScanning();
    setState(() {
      _isScanning = false;
    });
  }
}
