import 'dart:typed_data';
import 'dart:async';
import 'package:nfc_manager/nfc_manager.dart';

class NfcService {
  Future<NfcTag?> startNfcSession() async {
    NfcTag? discoveredTag;
    await NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      discoveredTag = tag;
      await NfcManager.instance.stopSession();
    });
    return discoveredTag;
  }

  Future<String> readTagData(NfcTag tag) async {
    if (tag.data.containsKey('mifareUltralight')) {
      return await readUltralightData(tag);
    } else {
      return 'Unsupported NFC tag type';
    }
  }

  Future<String> readUltralightData(NfcTag tag) async {
    var nfcA = tag.data['nfcA'];
    final result =
        await nfcA.transceive(Uint8List.fromList([0x30, 0x00])); // Read command
    return String.fromCharCodes(result);
  }
/*
  Future<String> readMifareClassicData(NfcTag tag) async {
    try {
      var mifareClassic = tag.data['mifareClassic'];
      final nfcA = mifareClassic['nfcA'];

      // Authenticate with Key A (0x60) or Key B (0x61)
      // Example authentication command, you should replace with actual key
      final authCommand = Uint8List.fromList(
          [0x60, 0x00, 0x00, 0x00, 0x00, 0x00]); // Placeholder
      final authResult = await nfcA.transceive(authCommand);

      if (authResult[0] == 0x90) {
        // Authentication success
        // Read a specific sector (e.g., Sector 0)
        final readCommand = Uint8List.fromList([0x30, 0x00]); // Read command
        final readResult = await nfcA.transceive(readCommand);
        return String.fromCharCodes(readResult);
      } else {
        return 'Authentication failed';
      }
    } catch (e) {
      return 'Error reading MIFARE Classic data: $e';
    }
  }

  Future<String> readNtagData(NfcTag tag) async {
    try {
      var ntag = tag.data['ntag'];
      final nfcA = ntag['nfcA'];
      
      // Read a specific page (e.g., Page 0)
      final readCommand = Uint8List.fromList([0x30, 0x00]); // Read command
      final readResult = await nfcA.transceive(readCommand);
      return String.fromCharCodes(readResult);
    } catch (e) {
      return 'Error reading NTAG data: $e';
    }
  }
  */
}
