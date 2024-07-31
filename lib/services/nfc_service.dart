import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'dart:typed_data';

class NfcService {
  final NfcManager _nfcManager = NfcManager.instance;
  bool _isScanning = false;

  Future<void> eraseTag() async {
    if (_isScanning) return;

    _isScanning = true;

    try {
      await _nfcManager.startSession(
        onDiscovered: (NfcTag tag) async {
          try {
            final nfca = NfcA.from(tag);
            if (nfca != null) {
              try {
                // Erase all pages (typically up to 48)
                for (int page = 0; page < 48; page++) {
                  final writeCommand = Uint8List.fromList([
                    0xA2, // Write command
                    page, // Page number
                    0x00, 0x00, 0x00, 0x00 // Data (zeros)
                  ]);

                  final response = await nfca.transceive(data: writeCommand);

                  if (response.isEmpty) {
                    print('Failed to write zeros to page $page');
                  } else {
                    print('Successfully wrote zeros to page $page');
                  }

                  // Debug: Print the response from the tag
                  String hexResponse = response
                      .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
                      .join(' ');
                  print('Page $page response (hex): $hexResponse');
                }
              } catch (e) {
                print('Error erasing tag: ${e.toString()}');
              }
            } else {
              print('NFC A tag not found.');
            }
          } catch (e) {
            print('Error accessing NFC tag: ${e.toString()}');
          } finally {
            _isScanning = false;
          }
        },
      );
    } catch (e) {
      print('Error starting NFC session: ${e.toString()}');
      _isScanning = false;
    }
  }

  Future<void> startScanning(
    Function(String) onDataRead,
    Function(String) onError,
  ) async {
    if (_isScanning) return;

    _isScanning = true;

    try {
      await _nfcManager.startSession(
        onDiscovered: (NfcTag tag) async {
          try {
            final nfca = NfcA.from(tag);
            if (nfca != null) {
              try {
                const int startPage = 6;
                const int endPage = 7;
                StringBuffer allData = StringBuffer();

                for (int page = startPage; page < endPage; page++) {
                  try {
                    final response = await nfca.transceive(
                      data: Uint8List.fromList([0x30, page]), // READ command
                    );

                    // Log raw data in hexadecimal format
                    String hexData = response
                        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
                        .join(' ');
                    print('Page $page raw data (hex): $hexData');

                    // Convert response bytes to a string
                    String pageData = String.fromCharCodes(response);

                    // Append the page data to the buffer
                    allData.write(pageData);
                  } catch (e) {
                    print('Error reading page $page: ${e.toString()}');
                  }
                }

                // Convert collected data to text and filter out unwanted characters
                String collectedData = allData.toString();
                String filteredData = _removeUnwantedCharacters(collectedData);

                // Pass the filtered data to onDataRead
                onDataRead(filteredData);
              } catch (e) {
                onError('Error in transceive operation: ${e.toString()}');
              }
            } else {
              onError('NFC A tag not found.');
            }
          } catch (e) {
            onError('Error reading NFC tag: ${e.toString()}');
          }
        },
      );
    } catch (e) {
      onError('Error starting NFC session: ${e.toString()}');
    } finally {
      _isScanning = false;
    }
  }

  String _removeUnwantedCharacters(String data) {
    // Define the unwanted prefix or character
    String unwantedPrefix = 'n'; // The character you want to remove

    // Remove the unwanted character if it appears at the beginning
    if (data.startsWith(unwantedPrefix)) {
      return data.substring(unwantedPrefix.length);
    }
    return data;
  }

  void stopScanning() {
    if (_isScanning) {
      _nfcManager.stopSession();
      _isScanning = false;
    }
  }
}
