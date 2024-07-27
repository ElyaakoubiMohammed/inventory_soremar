import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

class NfcService {
  /// Checks if NFC is available on the device
  Future<bool> isNfcAvailable() async {
    try {
      return await NfcManager.instance.isAvailable();
    } catch (e) {
      debugPrint('Error checking NFC availability: $e');
      return false;
    }
  }

  /// Starts an NFC session and listens for NFC tags
  Future<NfcTag?> startNfcSession() async {
    Completer<NfcTag?> completer = Completer();

    try {
      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          completer.complete(tag);
          NfcManager.instance.stopSession();
        },
      );
    } catch (e) {
      debugPrint('Error starting NFC session: $e');
      completer.completeError(e);
    }

    return completer.future;
  }

  /// Writes form data to an NFC tag
  Future<void> writeFormData(
    NfcTag tag, {
    required String productName,
    required String productDescription,
  }) async {
    try {
      if (tag.data.containsKey('mifareultralight')) {
        var mifareUltralight = MifareUltralight.from(tag);

        if (mifareUltralight != null) {
          // Prepare data
          String dataToWrite = '$productName\n$productDescription';
          List<int> data = dataToWrite.codeUnits; // Convert string to bytes

          // MifareUltralight write requires the page number and data to be written
          for (int i = 0; i < data.length; i += 4) {
            final pageData = Uint8List(4)
              ..setAll(0,
                  data.sublist(i, i + 4 > data.length ? data.length : i + 4));

            // Write data to page
            await mifareUltralight.transceive(
              data: Uint8List.fromList(
                  [0xA2, i ~/ 4, ...pageData]), // 0xA2 is the WRITE command
            );
          }

          debugPrint('Data written successfully');
        } else {
          debugPrint('MifareUltralight instance is null');
        }
      } else {
        debugPrint('Unsupported card type');
      }
    } catch (e, stacktrace) {
      debugPrint('Failed to write to NFC tag: $e');
      debugPrint('Stacktrace: $stacktrace');
      throw Exception('Failed to write to NFC tag: $e');
    }
  }

  /// Reads data from an NFC tag
  Future<Map<String, dynamic>> readTagData() async {
    try {
      Completer<Map<String, dynamic>> completer = Completer();
      NfcTag? tag;

      NfcManager.instance.startSession(
        onDiscovered: (NfcTag discoveredTag) async {
          tag = discoveredTag;
          NfcManager.instance.stopSession();

          try {
            final data = await _readTag(tag);
            completer.complete(data);
          } catch (e) {
            completer.completeError(e);
          }
        },
      );

      return completer.future;
    } catch (e) {
      debugPrint('Error reading NFC tag data: $e');
      return {'tagType': 'Unknown', 'data': 'Error: $e'};
    }
  }

  /// Helper method to read data from an NFC tag
  Future<Map<String, dynamic>> _readTag(NfcTag? tag) async {
    try {
      Map<String, dynamic> tagData = {};

      if (tag == null) {
        throw Exception('No tag detected');
      }

      if (tag.data.containsKey('mifareultralight')) {
        var mifareUltralight = MifareUltralight.from(tag);

        if (mifareUltralight != null) {
          // Read data from multiple pages
          List<int> allData = [];
          for (int i = 4; i < 8; i++) {
            final response = await mifareUltralight.transceive(
              data: Uint8List.fromList([0x30, i]), // 0x30 is the READ command
            );
            allData.addAll(response.sublist(0, 4)); // Each page is 4 bytes
          }

          tagData['data'] = String.fromCharCodes(allData).trim();
        } else {
          tagData['data'] = 'Unsupported tag type';
        }
      } else {
        tagData['data'] = 'Unsupported tag type';
      }

      return tagData;
    } catch (e, stacktrace) {
      debugPrint('Error reading tag data: $e');
      debugPrint('Stacktrace: $stacktrace');
      return {'data': 'Error: $e'};
    }
  }
}
