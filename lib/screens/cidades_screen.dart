import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cidade_provider.dart';
import '../widgets/cidade_widget.dart';
import 'edit_cidade_screen.dart';
import '../screens/start_screen.dart';

class CidadesScreen extends StatefulWidget {
  static const routeName = '/cidades-product';

  CidadesScreen({Key? key}) : super(key: key);

  @override
  State<CidadesScreen> createState() => _CidadesScreenState();
}

class _CidadesScreenState extends State<CidadesScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<CidadeProvider>(context).loadCidades().then((_) {
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
    final productsData = Provider.of<CidadeProvider>(context);
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
            'CIDADES',
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
                itemCount: productsData.cidade.length,
                itemBuilder: (_, i) => Column(
                  children: [
                    CidadeWidget(
                      productsData.cidade[i].id.toString(),
                      productsData.cidade[i].cidadeName.toString(),
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
                    width: 195,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                      ),
                      child: Row(
                        children: const [
                          Text('ADICIONAR CIDADE'),
                          Icon(Icons.add, size: 30)
                        ],
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(EditCidadeScreen.routeName);
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
