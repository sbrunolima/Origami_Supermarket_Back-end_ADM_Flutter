import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/links_provider.dart';
import '../screens/edit_link_screen.dart';
import '../widgets/links_widget.dart';
import '../screens/start_screen.dart';

class PropagandasScreen extends StatefulWidget {
  static const routeName = '/propagandas-product';

  PropagandasScreen({Key? key}) : super(key: key);

  @override
  State<PropagandasScreen> createState() => _PropagandasScreenState();
}

class _PropagandasScreenState extends State<PropagandasScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<LinksProvider>(context).loadLinks().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<LinksProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          onPressed: () {
            Navigator.of(context).popAndPushNamed(StartScreen.routeName);
          },
        ),
        title: const Center(
          child: Text(
            'PROPAGANDAS',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: productsData.links.length,
                itemBuilder: (_, i) => Column(
                  children: [
                    LinksWidget(
                      productsData.links[i].id.toString(),
                      productsData.links[i].linkUrl.toString(),
                    ),
                    const Divider(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  SizedBox(
                    height: 40,
                    width: 175,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                      ),
                      child: Row(
                        children: const [
                          Text('ADICIONAR LINK'),
                          Icon(Icons.add, size: 30)
                        ],
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(EditLinksScreen.routeName);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
