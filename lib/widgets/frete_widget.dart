import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../screens/edit_frete_screen.dart';

class FreteWidget extends StatelessWidget {
  final String id;
  final String valorFrete;

  FreteWidget(this.id, this.valorFrete);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    return ListTile(
      leading: Container(
        height: 100,
        width: 100,
        child: const Icon(
          Icons.monetization_on_outlined,
          size: 30,
          color: Colors.green,
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          '${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(double.parse(valorFrete))}',
        ),
      ),
      trailing: Container(
        width: 300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 30),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () async {
                Navigator.of(context)
                    .pushNamed(EditFreteScreen.routeName, arguments: id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
