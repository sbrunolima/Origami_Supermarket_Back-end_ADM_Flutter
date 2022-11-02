import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../providers/orders.dart';

buildPrintableData([OrderItem? order]) => pw.Column(
      children: [
        pw.Column(
          children: [
            pw.Container(
              height: 10,
              width: double.infinity,
              color: const PdfColor(0, 0, 0, 0.0),
              child: pw.Center(
                child: pw.Text(
                  'ITENS DO PEDIDO',
                  style: pw.TextStyle(
                    color: const PdfColor(1, 1, 1, 0.255),
                    fontSize: 6,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ),
            for (var i = 0; i < order!.products!.length; i++)
              pw.Container(
                color: i % 2 != 0
                    ? const PdfColor(0.9, 0.9, 0.9, 0.6)
                    : const PdfColor(1, 1, 1, 0.1),
                width: double.infinity,
                height: 8,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 8),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Row(
                        children: [
                          pw.Text(
                            i < 9 ? '0${1 + i}' : '${1 + i}',
                            style: const pw.TextStyle(
                              fontSize: 6,
                            ),
                          ),
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.symmetric(horizontal: 15),
                            child: pw.Text(
                              order.products![i].title.toString().toUpperCase(),
                              style: const pw.TextStyle(
                                color: PdfColor(0.1, 0.1, 0.1, 0.1),
                                fontSize: 6,
                              ),
                            ),
                          ),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Container(
                            width: 20,
                            child: pw.Text(
                              '${order.products![i].quantity.toString()}un',
                              style: const pw.TextStyle(
                                color: PdfColor(0.1, 0.1, 0.1, 0.1),
                                fontSize: 6,
                              ),
                            ),
                          ),
                          pw.Container(
                            width: 50,
                            child: pw.Text(
                              '${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(double.parse(order.products![i].price.toString()))}',
                              style: const pw.TextStyle(
                                color: PdfColor(0.1, 0.1, 0.1, 0.1),
                                fontSize: 6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        pw.Divider(),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.Container(
              decoration: pw.BoxDecoration(
                border:
                    pw.Border.all(color: const PdfColor(0.9, 0.9, 0.9, 0.6)),
                borderRadius: pw.BorderRadius.circular(0),
              ),
              width: 200,
              padding:
                  const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: pw.Column(
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Subtotal',
                        style: const pw.TextStyle(
                          color: PdfColor(0.1, 0.1, 0.1, 0.1),
                          fontSize: 6,
                        ),
                      ),
                      pw.Text(
                        '${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(double.parse(order.cartAmount.toString()))}',
                        style: pw.TextStyle(
                          color: const PdfColor(0.1, 0.1, 0.1, 0.1),
                          fontSize: 6,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 2),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Custo de entrega',
                        style: const pw.TextStyle(
                          color: PdfColor(0.1, 0.1, 0.1, 0.1),
                          fontSize: 6,
                        ),
                      ),
                      pw.Text(
                        '${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(double.parse(order.frete.toString()))}',
                        style: pw.TextStyle(
                          color: const PdfColor(0.1, 0.1, 0.1, 0.1),
                          fontSize: 6,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 2),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Total',
                        style: const pw.TextStyle(
                          color: PdfColor(0.1, 0.1, 0.1, 0.1),
                          fontSize: 6,
                        ),
                      ),
                      pw.Text(
                        '${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(double.parse(order.amount.toString()))}',
                        style: pw.TextStyle(
                          color: const PdfColor(0.1, 0.1, 0.1, 0.1),
                          fontSize: 6,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 2),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Pagamento',
                        style: const pw.TextStyle(
                          color: PdfColor(0.1, 0.1, 0.1, 0.1),
                          fontSize: 6,
                        ),
                      ),
                      pw.Text(
                        order.paymentType.toString(),
                        style: pw.TextStyle(
                          color: const PdfColor(0.1, 0.1, 0.1, 0.1),
                          fontSize: 6,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 6),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.Container(
              //margin: pw.EdgeInsets.symmetric(horizontal: 8),
              decoration: pw.BoxDecoration(
                border:
                    pw.Border.all(color: const PdfColor(0.9, 0.9, 0.9, 0.6)),
                borderRadius: pw.BorderRadius.circular(0),
              ),
              child: pw.Padding(
                padding:
                    const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Nome e Telefone: ${order.nomeTel}',
                      style: const pw.TextStyle(
                        color: PdfColor(0.1, 0.1, 0.1, 0.1),
                        fontSize: 6,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Endereço: ${order.address}',
                      style: const pw.TextStyle(
                        color: PdfColor(0.1, 0.1, 0.1, 0.1),
                        fontSize: 6,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'CPF Nota Fiscal: ${order.cpf}',
                      style: const pw.TextStyle(
                        color: PdfColor(0.1, 0.1, 0.1, 0.1),
                        fontSize: 6,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Troco para Valor: R\$ ${order.troco.toString().replaceAll('.', ',')}',
                      style: const pw.TextStyle(
                        color: PdfColor(0.1, 0.1, 0.1, 0.1),
                        fontSize: 6,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Container(
                      width: 300,
                      child: pw.Text(
                        'Observações: ${order.description}',
                        maxLines: 5,
                        style: const pw.TextStyle(
                          color: PdfColor(0.1, 0.1, 0.1, 0.1),
                          fontSize: 6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
