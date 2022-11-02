import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../invoice/invoice_page.dart';

class OrdersItemsList extends StatefulWidget {
  final OrderItem order;

  final int index;
  OrdersItemsList(this.order, this.index);

  @override
  State<OrdersItemsList> createState() => _OrdersItemsListState();
}

class _OrdersItemsListState extends State<OrdersItemsList> {
  var _expanded = false;
  var _expandedPayments = false;
  var index;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            child: ListTile(
              title: Text(
                'Pedido ID: ${widget.order.id}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                DateFormat('dd/MM/yyy -- hh:mm:ss')
                    .format(widget.order.dateTime!),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  _expanded
                      ? Icons.expand_less_outlined
                      : Icons.expand_more_outlined,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Column(
                children: [
                  const Divider(color: Colors.black),
                  const SizedBox(height: 20),

                  Container(
                    height:
                        min(widget.order.products!.length * 20.0 + 500, 500),
                    child: ListView(
                      children: widget.order.products!
                          .map((prod) => ListTile(
                                leading: Image.network(prod.imageUrl),
                                title: Text(prod.title!),
                                subtitle: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Preço: ${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(double.parse(prod.price.toString()))} ',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Quant: ${prod.quantity} un',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // TOTAL DA COMPRA
                  const Divider(color: Colors.black),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 6),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _expandedPayments = !_expandedPayments;
                            });
                          },
                          child: Container(
                            width: 280,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.blueAccent,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text(
                                  'Detalhes de Pagamento',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    _expandedPayments
                                        ? Icons.expand_less_outlined
                                        : Icons.expand_more_outlined,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _expandedPayments = !_expandedPayments;
                                    });
                                  },
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_expandedPayments)
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        paymentDetails(
                          'Subtotal',
                          '${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(double.parse(widget.order.cartAmount.toString()))}',
                          false,
                        ),
                        paymentDetails(
                          'Custo de entrega',
                          '${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(double.parse(widget.order.frete.toString()))}',
                          false,
                        ),
                        paymentDetails(
                          'Total',
                          '${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(double.parse(widget.order.amount.toString()))}',
                          true,
                        ),
                        paymentDetails(
                          'Pagamento',
                          '${widget.order.paymentType}',
                          true,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                titleObservation('Nome e Telefone: ',
                                    '${widget.order.nomeTel}'),
                                const SizedBox(height: 8),
                                titleObservation(
                                    'Endereço: ', '${widget.order.address}'),
                                const SizedBox(height: 8),
                                titleObservation(
                                    'CPF Nota Fiscal: ', '${widget.order.cpf}'),
                                const SizedBox(height: 8),
                                titleObservation(
                                  'Troco para Valor: ',
                                  'R\$ ${widget.order.troco.toString().replaceAll('.', ',')}',
                                ),
                                const SizedBox(height: 8),
                                titleObservation('Observações: ',
                                    '${widget.order.description}'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 30,
                                width: 180,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blueAccent,
                                  ),
                                  child: const Text(
                                    'IMPRIMIR PEDIDO',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  onPressed: () async {
                                    Navigator.of(context).pushNamed(
                                        InvoiceScreen.routeName,
                                        arguments: widget.index);
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                width: 180,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.redAccent,
                                  ),
                                  child: const Text(
                                    'FINALIZAR PEDIDO',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  onPressed: () {
                                    popDialog(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 15),
                ],
              ),
            ),
        ],
      ),
    );
  }

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
        const SizedBox(height: 5),
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

  Future popDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        child: AlertDialog(
          title: const Center(
            child: Text(
              'FINALIZAR PEDIDO!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Container(
            child: const Text(
              'Tem certeza que o pedido foi completado? Continuar irá deletar o pedido do sistema.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  child: const Text(
                    'SIM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await Provider.of<Orders>(context, listen: false)
                        .deleteOrder(widget.order.id.toString());
                  },
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  child: const Text(
                    'NÃO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
