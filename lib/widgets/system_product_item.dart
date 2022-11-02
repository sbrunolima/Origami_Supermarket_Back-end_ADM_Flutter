import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products_provider.dart';

class SystemProducItem extends StatelessWidget {
  var priceFormat = NumberFormat("###,###", "br");
  final String id;
  final String title;
  final String imageUrl;
  final String price;
  final String sector;
  final String offerPrice;
  var oferta;

  SystemProducItem(this.id, this.title, this.imageUrl, this.price, this.sector,
      this.offerPrice, this.oferta);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final producData = Provider.of<ProductsProvider>(context);

    return ListTile(
      title: Text(title),
      leading: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
        ),
        child: Image.network(imageUrl),
      ),
      subtitle: Row(
        children: [
          const Text(
            'Setor:  ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            sector.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          // Text(
          //   '  - ${oferta.toString()}',
          //   style: const TextStyle(
          //     fontWeight: FontWeight.bold,
          //     color: Colors.red,
          //   ),
          // ),
        ],
      ),
      trailing: Container(
        width: 300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            oferta
                ? Image.asset('assets/oferta.png')
                : Image.asset('assets/ofertablank.png'),
            const SizedBox(width: 30),
            Text(
              oferta
                  ? '${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(double.parse(offerPrice))}'
                  : '${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(double.parse(price))}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 30),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                popDialog(context);
              },
            ),
          ],
        ),
      ),
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
              'DELETAR PRODUTO',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Container(
            child: const Text(
              'Tem certeza que deseja deletar o produto?',
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
                SizedBox(
                  height: 50,
                  width: 150,
                  child: ElevatedButton(
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
                      await Provider.of<ProductsProvider>(context,
                              listen: false)
                          .deleteProduct(id);
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 150,
                  child: ElevatedButton(
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
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
