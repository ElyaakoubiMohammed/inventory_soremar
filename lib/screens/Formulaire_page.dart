import 'package:flutter/material.dart';
//import 'package:soremar_inventory/screens/details.dart';
//import 'package:soremar_inventory/services/nfc_service.dart';
import 'package:soremar_inventory/Widgets/my_text_field.dart';

class FormulairePage extends StatefulWidget {
  static const String path = '/formulaire';

  const FormulairePage({super.key});

  @override
  State<FormulairePage> createState() => _FormulairePageState();
}

class _FormulairePageState extends State<FormulairePage> {
  final _productController = TextEditingController();
  final _productDesController = TextEditingController();
  //final NfcService _nfcService = NfcService();

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
        _showConfirmationDialog(context);
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

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to submit the form?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Remove or comment out the following line to prevent form submission
                // _submitForm(context);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  // Remove or comment out this method if no actions should be taken
  // void _submitForm(BuildContext context) async {
  //   try {
  //     await _nfcService.writeNfcTag(
  //       'Product Name: ${_productController.text}\n'
  //       'Product Description: ${_productDesController.text}',
  //     );
  //     _navigateToDetails(context);
  //   } catch (e) {
  //     print('Failed to write NFC tag: $e');
  //   }
  // }
/*
  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Details(
            productName: _productController.text,
            productDescription: _productDesController.text,
          );
        },
      ),
    );
  }
  */
}
