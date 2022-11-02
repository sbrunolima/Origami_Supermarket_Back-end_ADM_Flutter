import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/frete_provider.dart';
import '../widgets/frete_widget.dart';
import '../screens/edit_frete_screen.dart';
import '../screens/start_screen.dart';

class FreteScreen extends StatefulWidget {
  static const routeName = '/frete-product';

  FreteScreen({Key? key}) : super(key: key);

  @override
  State<FreteScreen> createState() => _FreteScreenState();
}

class _FreteScreenState extends State<FreteScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<FreteProvider>(context).loadFretes().then((_) {
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
    final freteData = Provider.of<FreteProvider>(context);
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
            'FRETE',
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
                itemCount: freteData.frete.length,
                itemBuilder: (_, i) => Column(
                  children: [
                    FreteWidget(
                      freteData.frete[i].id.toString(),
                      freteData.frete[i].valorFrete.toString(),
                    ),
                    const Divider(),
                  ],
                ),
              ),
            ),
            if (freteData.frete.length < 1)
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 185,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueAccent,
                        ),
                        child: Row(
                          children: const [
                            Text('ADICIONAR FRETE'),
                            Icon(Icons.add, size: 30)
                          ],
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(EditFreteScreen.routeName);
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
