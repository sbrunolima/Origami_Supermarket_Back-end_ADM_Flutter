import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'printable_data.dart';
import 'package:printing/printing.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../providers/orders.dart';

class InvoiceBuilder extends StatefulWidget {
  final OrderItem order;
  final int index;

  InvoiceBuilder(this.order, this.index);

  @override
  State<InvoiceBuilder> createState() => _InvoiceBuilderState();
}

class _InvoiceBuilderState extends State<InvoiceBuilder> {
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Column(
      children: [
        header(),
        const SizedBox(height: 10),
        tableHeader(),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          child: Column(
            children: [],
          ),
        ),
        buildTotal(),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.indigo,
            primary: Colors.indigo,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onPressed: () {
            printDoc(orderData.orders[widget.index]);
          },
          child: const Text(
            "Save as PDF",
            style: TextStyle(color: Colors.white, fontSize: 20.00),
          ),
        ),
      ],
    );
  }

  Future<void> printDoc([OrderItem? order]) async {
    final doc = pw.Document();
    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return buildPrintableData(order);
        }));
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  Widget header() => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: const [
          Icon(
            Icons.file_open,
            color: Colors.indigo,
            size: 35.00,
          ),
          const SizedBox(height: 5),
          Text(
            "Pedido",
            style: TextStyle(fontSize: 23.00, fontWeight: FontWeight.bold),
          )
        ],
      );

  Widget tableHeader() => Container(
        color: const Color.fromARGB(255, 189, 255, 191),
        width: double.infinity,
        height: 36.00,
        child: const Center(
          child: Text(
            "Itens",
            style: TextStyle(
                color: Color.fromARGB(255, 0, 107, 4),
                fontSize: 20.00,
                fontWeight: FontWeight.bold),
          ),
        ),
      );

  Widget buildTotal() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Container(
          color: const Color.fromARGB(255, 255, 251, 251),
          width: double.infinity,
          height: 36.00,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Text(
                "\$ 23.50",
                style: TextStyle(
                  fontSize: 22.00,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 107, 4),
                ),
              ),
            ],
          ),
        ),
      );

  Widget paymentDetails(String title, String valor, bool color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                valor,
                style: TextStyle(
                  color: color ? Colors.green : Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Divider(),
        ],
      ),
    );
  }

  Widget titleObservation(String title, subtitle) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Container(
              child: Expanded(
                child: Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
