import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_link_screen.dart';
import '../providers/links_provider.dart';

class LinksWidget extends StatelessWidget {
  final String id;
  final String cidadeName;

  LinksWidget(this.id, this.cidadeName);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    return ListTile(
      leading: Container(
        height: 100,
        width: 100,
        child: Image.network(
          cidadeName.toString(),
          fit: BoxFit.cover,
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Text(cidadeName),
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
                    .pushNamed(EditLinksScreen.routeName, arguments: id);
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
                      await Provider.of<LinksProvider>(context, listen: false)
                          .deleteLink(id);
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
