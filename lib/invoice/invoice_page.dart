import 'package:flutter/material.dart';
import 'printable_data.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import './invoice_table.dart';
import '../providers/orders.dart';

class InvoiceScreen extends StatefulWidget {
  static const routeName = '/invoice-screen';

  InvoiceScreen([String? id]);

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  var _isInit = true;
  var index;
  int quantity = 1;

  var receivedArg = "";
  var sendedArg = "authScreen";

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final pageId = ModalRoute.of(context)!.settings.arguments;
      if (pageId != null) {
        setState(() {
          index = int.tryParse(pageId.toString());
        });
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final sizedBox = const SizedBox(height: 20);
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.00),
          child: Column(
            children: [
              ListTile(
                leading: Image.asset("assets/logo.png"),
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Pedido ID: ${orderData.orders[index].id}",
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    DateFormat('dd/MM/yyy -- hh:mm:ss')
                        .format(orderData.orders[index].dateTime!),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              Container(
                height: 30,
                width: double.infinity,
                color: Colors.blueAccent,
                child: const Center(
                    child: Text(
                  'ITENS DO PEDIDO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ),
              const SizedBox(height: 10),
              for (var i = 0; i < orderData.orders[index].products!.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    color: i % 2 != 0 ? Colors.grey.shade200 : Colors.white,
                    width: double.infinity,
                    height: 26.00,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                                i < 9 ? '0${quantity + i}' : '${quantity + i}'),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Image.network(orderData
                                  .orders[index].products![i].imageUrl
                                  .toString()),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(orderData
                                  .orders[index].products![i].title
                                  .toString()),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                '${orderData.orders[index].products![i].quantity}un',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                '${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(double.parse(orderData.orders[index].products![i].price.toString()))}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              sizedBox,
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  children: [
                    sizedBox,
                    paymentDetails(
                      'Subtotal',
                      '${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(double.parse(orderData.orders[index].cartAmount.toString()))}',
                      false,
                    ),
                    paymentDetails(
                      'Custo de entrega',
                      '${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(double.parse(orderData.orders[index].frete.toString()))}',
                      false,
                    ),
                    paymentDetails(
                      'Total',
                      '${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(double.parse(orderData.orders[index].amount.toString()))}',
                      false,
                    ),
                    paymentDetails(
                      'Pagamento',
                      '${orderData.orders[index].paymentType}',
                      true,
                    ),
                    sizedBox,
                  ],
                ),
              ),
              sizedBox,
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      titleObservation('Nome e Telefone: ',
                          '${orderData.orders[index].nomeTel}'),
                      const SizedBox(height: 8),
                      titleObservation(
                          'Endereço: ', '${orderData.orders[index].address}'),
                      const SizedBox(height: 8),
                      titleObservation('CPF Nota Fiscal: ',
                          '${orderData.orders[index].cpf}'),
                      const SizedBox(height: 8),
                      titleObservation(
                        'Troco para Valor: ',
                        'R\$ ${orderData.orders[index].troco.toString().replaceAll('.', ',')}',
                      ),
                      const SizedBox(height: 8),
                      titleObservation('Observações: ',
                          '${orderData.orders[index].description}'),
                    ],
                  ),
                ),
              ),
              const Divider(),
              if (_isInit)
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, i) {
                      index = i;

                      return InvoiceBuilder(
                        orderData.orders[i],
                        i,
                      );
                    }),
              const SizedBox(width: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 30,
                    width: 240,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        onPrimary: Colors.blueAccent,
                        primary: Colors.blueAccent,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: () async {
                        final doc = pw.Document();
                        doc.addPage(
                          pw.Page(
                            pageFormat: PdfPageFormat.a4,
                            build: (context) {
                              return buildPrintableData(
                                  orderData.orders[index]);
                            },
                          ),
                        );

                        await Printing.layoutPdf(
                            onLayout: (PdfPageFormat format) async =>
                                doc.save());
                      },
                      child: const Text(
                        'Imprimir pedido',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    width: 240,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        onPrimary: Colors.red,
                        primary: Colors.redAccent,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> printDoc([OrderItem? order]) async {
    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [buildPrintableData(order)],
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  Widget paymentDetails(String title, String valor, bool color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                valor,
                style: TextStyle(
                  color: color ? Colors.green : Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (!color) const Divider(),
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
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Container(
              child: Expanded(
                child: Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
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
