import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';

class ErrorPage extends StatelessWidget {
  final String errorMessage;

  const ErrorPage({super.key, required this.errorMessage});

  static const String path = '/error';

  void _launchNfcSettings(BuildContext context) {
    AppSettings.openAppSettingsPanel(AppSettingsPanelType.nfc);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (details) {
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          backgroundColor: const Color.fromARGB(255, 19, 4, 233),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/error.gif',
                  width: 500.0,
                  height: 500.0,
                ),
                const SizedBox(height: 20),
                Text(
                  errorMessage,
                  style: const TextStyle(
                    fontSize: 24.0,
                    color: Colors.redAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _launchNfcSettings(context),
                  child: const Text('Open NFC Settings'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
