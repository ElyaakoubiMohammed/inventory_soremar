import 'package:flutter/material.dart';
import 'package:soremar_inventory/services/nfc_service.dart';
import 'package:soremar_inventory/widgets/my_text_field.dart';

class FormulairePage extends StatefulWidget {
  static const String path = '/formulaire';

  const FormulairePage({super.key});

  @override
  State<FormulairePage> createState() => _FormulairePageState();
}

class _FormulairePageState extends State<FormulairePage> {
  final _productController = TextEditingController();
  final _productDesController = TextEditingController();
  final NfcService _nfcService = NfcService();

  @override
  void dispose() {
    _productController.dispose();
    _productDesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 42, 48, 161),
        title: const Text("Form"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            MyTextField(
                myController: _productController,
                fieldName: "Product Name",
                myIcon: Icons.account_balance,
                prefixIconColor: const Color.fromARGB(255, 42, 48, 161)),
            const SizedBox(height: 10.0),
            MyTextField(
                myController: _productDesController,
                fieldName: "Product Description",
                prefixIconColor: const Color.fromARGB(255, 42, 48, 161)),
            const SizedBox(height: 20.0),
            myBtn(context),
          ],
        ),
      ),
    );
  }

  OutlinedButton myBtn(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
      onPressed: () {
        _submitForm(context);
      },
      child: Text(
        "Submit Form".toUpperCase(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 17, 17, 17),
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) async {
    final productName = _productController.text;
    final productDescription = _productDesController.text;

    try {
      await _nfcService.writeFormData(
        productName,
        productDescription,
      );
      _showSuccessDialog(context);
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Data written to NFC tag successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to write NFC tag: $error'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
