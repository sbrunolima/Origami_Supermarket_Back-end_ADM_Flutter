import 'package:flutter/material.dart';
import 'printable_data.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../providers/orders.dart';

class SaveBtnBuilder extends StatelessWidget {
  const SaveBtnBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.indigo,
        primary: Colors.indigo,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onPressed: () => printDoc(),
      child: const Text(
        "Save as PDF",
        style: TextStyle(color: Colors.white, fontSize: 20.00),
      ),
    );
  }

  Future<void> printDoc() async {
    final doc = pw.Document();
    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return buildPrintableData();
        }));
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }
}
