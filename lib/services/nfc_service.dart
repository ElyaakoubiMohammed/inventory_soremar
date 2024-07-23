import 'dart:async';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';

class NfcService {
  Future<List<String>> readNfcTag(BuildContext context) async {
    Completer<List<String>> completer = Completer();

    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        List<String> payloads = [];

        if (tag.data['ndef'] != null) {
          var ndef = Ndef.from(tag);
          if (ndef?.cachedMessage != null &&
              ndef!.cachedMessage!.records.isNotEmpty) {
            for (var record in ndef.cachedMessage!.records) {
              String payload = _decodePayload(record.payload);
              payloads.add(payload);
            }
            NfcManager.instance.stopSession();
            completer.complete(payloads);
          } else {
            NfcManager.instance.stopSession();
            completer.completeError('No NDEF records found on the tag');
          }
        } else if (tag.data['id'] != null) {
          payloads
              .add('Detected NFC-A or NFC-B tag with ID: ${tag.data['id']}');
          NfcManager.instance.stopSession();
          completer.complete(payloads);
        } else {
          NfcManager.instance
              .stopSession(errorMessage: "The detected tag is not supported.");
          completer.completeError('The detected tag is not supported.');
        }
      },
    );

    return completer.future;
  }

  String _decodePayload(Uint8List payload) {
    if (payload.isEmpty) {
      return "";
    }
    int languageCodeLength = payload[0]; // Language code length
    return String.fromCharCodes(payload.sublist(1 + languageCodeLength));
  }

  Future<void> writeNfcTag(String data) async {
    Completer<void> completer = Completer();

    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        var ndef = Ndef.from(tag);
        if (ndef == null) {
          NfcManager.instance.stopSession(
              errorMessage: "The detected tag is not NDEF formatted");
          completer.completeError('The detected tag is not NDEF formatted');
          return;
        }
        if (!ndef.isWritable) {
          NfcManager.instance
              .stopSession(errorMessage: "The detected tag is not writable");
          completer.completeError('The detected tag is not writable');
          return;
        }

        NdefMessage message = NdefMessage([
          NdefRecord.createText(data),
        ]);

        try {
          await ndef.write(message);
          NfcManager.instance.stopSession();
          completer.complete();
        } catch (e) {
          NfcManager.instance.stopSession(
              errorMessage: "Failed to write to NFC tag. Please try again.");
          completer
              .completeError('Failed to write to NFC tag. Please try again.');
        }
      },
    );

    return completer.future;
  }
}
