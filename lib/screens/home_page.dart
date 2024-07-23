import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
//import '../services/nfc_service.dart';
import 'Formulaire_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const path = "/home";

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  //final NfcService _nfcService = NfcService();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward(); // Start the animation when the widget is built
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

/*
  void _onReadNFC(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scan NFC'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/scan.gif',
              height: 100,
              width: 100,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                List<String> data = await _nfcService.readNfcTag(context);
                if (data.isNotEmpty) {
                  print("NFC Data: $data");
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('NFC Data'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: data.map((payload) => Text(payload)).toList(),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  print("No data found on NFC tag.");
                }
              } catch (e) {
                print("Error reading NFC: $e");
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Error'),
                    content: Text('Error reading NFC: $e'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: const Text('Scan'),
          ),
        ],
      ),
    );
  }

  void _onWriteNFC(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Write NFC'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/scan.gif',
              height: 100,
              width: 100,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _nfcService.writeNfcTag('product');
                print("Data written to NFC tag.");
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data written to NFC tag.')),
                );
              } catch (e) {
                print("Error writing NFC: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error writing to NFC tag: $e')),
                );
              }
            },
            child: const Text('Write'),
          ),
        ],
      ),
    );
  }
  */
  void _navigateToFormulairePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormulairePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/backgroundimage.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Container(
              margin: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/soremarlogo.png',
                        height: 50,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Center(),
                  const SizedBox(height: 48),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: OpenContainer(
                            closedBuilder: (context, openContainer) =>
                                GestureDetector(
                              onTap: openContainer,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                padding: const EdgeInsets.all(35),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255)
                                          .withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Image.asset('assets/images/loupe.gif',
                                        height: 80),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Controlle des produits',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            openBuilder: (context, closeContainer) =>
                                const Center(
                                    child: Text('Veuillez scannez la tag...')),
                          ),
                        ),
                        const SizedBox(height: 150), // Increased space
                        Center(
                          child: GestureDetector(
                            onTap: () => _navigateToFormulairePage(context),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              padding: const EdgeInsets.all(35),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Image.asset('assets/images/editing.gif',
                                      height: 80),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Enregistrer un produit',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
