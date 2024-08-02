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
                  print('Page $page write response: ${response.toHex()}');

                  if (response.isEmpty) {
                    print('Failed to write zeros to page $page');
                  } else {
                    print('Successfully wrote zeros to page $page');
                  }
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
                const int startPage = 6;
                final int endPage = await _calculateEndPage(nfca);
                StringBuffer allData = StringBuffer();

                for (int page = startPage; page < endPage; page++) {
                  try {
                    final response = await nfca.transceive(
                      data: Uint8List.fromList([0x30, page]), // READ command
                    );

                    // Log raw bytes and data
                    print('Page $page raw bytes: ${response.toHex()}');
                    String pageData = String.fromCharCodes(response);
                    print('Page $page data: $pageData');

                    allData.write(pageData);
                  } catch (e) {
                    print('Error reading page $page: ${e.toString()}');
                  }
                }

                String collectedData = allData.toString();
                String filteredData = _removeUnwantedCharacters(collectedData);

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
                List<int> productNameBytes = utf8.encode(productName);
                List<int> productDescriptionBytes =
                    utf8.encode(productDescription);

                // Helper function to write data to a page
                Future<void> writePage(int page, List<int> dataBytes) async {
                  // Pad the data to 4 bytes if necessary
                  List<int> pageData = List<int>.filled(4, 0x00);
                  for (int i = 0; i < dataBytes.length; i++) {
                    pageData[i] = dataBytes[i];
                  }

                  final writeCommand = Uint8List.fromList([
                    0xA2, // Write command
                    page, // Page number
                    ...pageData,
                  ]);

                  final response = await nfca.transceive(data: writeCommand);
                  print('Page $page write response: ${response.toHex()}');

                  if (response.isEmpty) {
                    print('Failed to write data to page $page');
                  } else {
                    print('Successfully wrote data to page $page');
                  }
                }

                // Starting page for writing
                int startPage = 6;

                // Write productName
                for (int i = 0; i < productNameBytes.length; i += 4) {
                  int page = startPage + (i ~/ 4);
                  List<int> pageData = productNameBytes.sublist(
                    i,
                    (i + 4 > productNameBytes.length)
                        ? productNameBytes.length
                        : i + 4,
                  );
                  await writePage(page, pageData);
                }

                // Write productDescription on subsequent pages
                startPage += (productNameBytes.length / 4).ceil();
                for (int i = 0; i < productDescriptionBytes.length; i += 4) {
                  int page = startPage + (i ~/ 4);
                  List<int> pageData = productDescriptionBytes.sublist(
                    i,
                    (i + 4 > productDescriptionBytes.length)
                        ? productDescriptionBytes.length
                        : i + 4,
                  );
                  await writePage(page, pageData);
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
}

extension on Uint8List {
  String toHex() =>
      map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
}
