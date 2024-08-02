import 'dart:async';
import 'dart:typed_data';
import 'dart:convert';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

class NfcService {
  final NfcManager _nfcManager = NfcManager.instance;
  bool _isScanning = false;

  Future<void> eraseTag() async {
    if (_isScanning) return;

    _isScanning = true;

    try {
      final Completer<void> completer = Completer<void>();

      await _nfcManager.startSession(
        onDiscovered: (NfcTag tag) async {
          try {
            final nfca = NfcA.from(tag);
            if (nfca != null) {
              try {
                for (int page = 4; page < 40; page++) {
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

                  String hexResponse = response
                      .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
                      .join(' ');
                  print('Page $page response (hex): $hexResponse');
                }

                completer.complete();
              } catch (e) {
                completer.completeError(e);
                print('Error erasing tag: ${e.toString()}');
              }
            } else {
              completer.completeError('NFC A tag not found.');
              print('NFC A tag not found.');
            }
          } catch (e) {
            completer.completeError(e);
            print('Error accessing NFC tag: ${e.toString()}');
          } finally {
            _isScanning = false;
          }
        },
      );

      await completer.future;
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
                const int startPage = 6; // Start reading from page 6
                final int endPage = await _calculateEndPage(
                    nfca); // Determine end page dynamically
                StringBuffer allData = StringBuffer();

                for (int page = startPage; page < endPage; page++) {
                  try {
                    final response = await nfca.transceive(
                      data: Uint8List.fromList([0x30, page]), // READ command
                    );

                    // Print raw bytes for debugging
                    print(
                        'Page $page raw bytes: ${response.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ')}');

                    String pageData = String.fromCharCodes(response);
                    print('Page $page data: $pageData');

                    allData.write(pageData);
                  } catch (e) {
                    print('Error reading page $page: ${e.toString()}');
                  }
                }

                String collectedData = allData.toString();
                String filteredData = _removeUnwantedCharacters(collectedData);

                // Log the filtered data
                print('Filtered data: $filteredData');

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

  Future<int> _calculateEndPage(NfcA nfca) async {
    // Implement this function based on your NFC tag's capacity
    // This is a placeholder for the actual logic to determine the end page
    return 40; // Default end page, adjust if necessary
  }

  void stopScanning() {
    if (_isScanning) {
      _nfcManager.stopSession();
      _isScanning = false;
    }
  }

  String _removeUnwantedCharacters(String data) {
    // Debug: Print raw data before filtering
    print('Raw data before filtering: $data');

    // Remove non-printable characters while keeping standard printable ASCII
    RegExp printableExp = RegExp(r'[ -~]'); // Printable ASCII characters range
    String cleanedData = data.splitMapJoin(printableExp,
        onMatch: (m) => m.group(0)!, onNonMatch: (n) => '');

    // Specific unwanted characters to be removed
    RegExp unwantedCharsExp = RegExp(r'[ÿ0]'); // Adjust as needed
    cleanedData = cleanedData.replaceAll(unwantedCharsExp, '');

    // Remove leading and trailing whitespace
    cleanedData = cleanedData.trim();

    // Remove additional problematic characters or patterns
    RegExp extraUnwantedExp =
        RegExp(r'[^\w\s]'); // Remove non-alphanumeric and non-space characters
    cleanedData = cleanedData.replaceAll(extraUnwantedExp, '');

    // Debug: Print cleaned data
    print('Cleaned data (after removing unwanted characters): $cleanedData');

    return cleanedData;
  }

  Future<void> writeFormData(
      String productName, String productDescription) async {
    if (_isScanning) return;

    _isScanning = true;

    try {
      final Completer<void> completer = Completer<void>();

      await _nfcManager.startSession(
        onDiscovered: (NfcTag tag) async {
          try {
            final nfca = NfcA.from(tag);
            if (nfca != null) {
              try {
                // Clear previous data by writing zeros
                await _clearTag(nfca);

                // Convert strings to byte arrays
                List<int> productNameBytes = utf8.encode(productName);
                List<int> productDescriptionBytes =
                    utf8.encode(productDescription);

                // Starting page for writing
                int startPage = 6;

                // Write productName
                for (int i = 0; i < productNameBytes.length; i += 4) {
                  int page = startPage + (i ~/ 4);
                  Uint8List writeCommand = Uint8List.fromList([
                    0xA2, // Write command
                    page, // Page number
                    ...productNameBytes.sublist(
                        i,
                        i + 4 > productNameBytes.length
                            ? productNameBytes.length
                            : i + 4),
                  ]);

                  final response = await nfca.transceive(data: writeCommand);

                  if (response.isEmpty) {
                    print('Failed to write product name to page $page');
                  } else {
                    print('Successfully wrote product name to page $page');
                  }
                }

                // Continue writing productDescription on subsequent pages
                startPage += (productNameBytes.length / 4)
                    .ceil(); // Update startPage to be after the productName pages
                for (int i = 0; i < productDescriptionBytes.length; i += 4) {
                  int page = startPage + (i ~/ 4);
                  Uint8List writeCommand = Uint8List.fromList([
                    0xA2, // Write command
                    page, // Page number
                    ...productDescriptionBytes.sublist(
                        i,
                        i + 4 > productDescriptionBytes.length
                            ? productDescriptionBytes.length
                            : i + 4),
                  ]);

                  final response = await nfca.transceive(data: writeCommand);

                  if (response.isEmpty) {
                    print('Failed to write product description to page $page');
                  } else {
                    print(
                        'Successfully wrote product description to page $page');
                  }
                }

                completer.complete();
              } catch (e) {
                completer.completeError(e);
                print('Error writing data to tag: ${e.toString()}');
              }
            } else {
              completer.completeError('NFC A tag not found.');
              print('NFC A tag not found.');
            }
          } catch (e) {
            completer.completeError(e);
            print('Error accessing NFC tag: ${e.toString()}');
          } finally {
            _isScanning = false;
          }
        },
      );

      await completer.future;
    } catch (e) {
      print('Error starting NFC session: ${e.toString()}');
      _isScanning = false;
    }
  }

  Future<void> _clearTag(NfcA nfca) async {
    try {
      for (int page = 4; page < 40; page++) {
        final writeCommand = Uint8List.fromList([
          0xA2, // Write command
          page, // Page number
          0x00, 0x00, 0x00, 0x00 // Data (zeros)
        ]);

        final response = await nfca.transceive(data: writeCommand);

        if (response.isEmpty) {
          print('Failed to clear page $page');
        } else {
          print('Successfully cleared page $page');
        }
      }
    } catch (e) {
      print('Error clearing tag: ${e.toString()}');
    }
  }
}
