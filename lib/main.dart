import 'package:flutter/material.dart';
import 'package:soremar_inventory/screens/NFCUnavailablepage.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/formulaire_page.dart';
import 'screens/profilepage.dart';
import 'package:nfc_manager/nfc_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bool nfcAvailable = await checkNfcAvailability();
  runApp(MyApp(nfcAvailable: nfcAvailable));
}

Future<bool> checkNfcAvailability() async {
  try {
    return await NfcManager.instance.isAvailable();
  } catch (e) {
    return false;
  }
}

class MyApp extends StatelessWidget {
  final bool nfcAvailable;
  const MyApp({super.key, required this.nfcAvailable});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Soremar Inventory',
      initialRoute: LoginPage.path,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      routes: {
        LoginPage.path: (context) => const LoginPage(),
        HomePage.path: (context) => const HomePage(),
        FormulairePage.path: (context) => const FormulairePage(),
        ErrorPage.path: (context) => const ErrorPage(
              errorMessage: 'NFC is not available on this device ',
            ),
        ProfilePage1.path: (context) => const ProfilePage1()
      },
    );
  }
}
