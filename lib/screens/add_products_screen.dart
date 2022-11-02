import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/system_product_item.dart';
import 'edit_product_screen.dart';
import '../screens/start_screen.dart';

class AddProductsScreen extends StatefulWidget {
  static const routeName = '/add-product';

  AddProductsScreen({Key? key}) : super(key: key);

  @override
  State<AddProductsScreen> createState() => _AddProductsScreenState();
}

class _AddProductsScreenState extends State<AddProductsScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<ProductsProvider>(context).loadProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> searchProduct(String query) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .findedProducts(query);
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          onPressed: () {
            Navigator.of(context).popAndPushNamed(StartScreen.routeName);
          },
        ),
        title: SizedBox(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged: (value) {
                searchProduct(value.toString());
              },
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.grey.shade200)),
                hintText: 'Buscar Produto',
                prefixIcon: const Icon(Icons.search, color: Colors.black),
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.redAccent,
              ),
              child: Row(
                children: const [Text('ADICIONAR'), Icon(Icons.add, size: 30)],
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
            ),
          ),
          const SizedBox(width: 60),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 80,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: const Center(
                      child: Text(
                        'ADICIONAR PRODUTOS',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: productsData.items.length,
                      itemBuilder: (_, i) => Column(
                        children: [
                          SystemProducItem(
                            productsData.items[i].id.toString(),
                            productsData.items[i].title.toString(),
                            productsData.items[i].imageUrl.toString(),
                            productsData.items[i].price.toString(),
                            productsData.items[i].sector.toString(),
                            productsData.items[i].offerPrice.toString(),
                            productsData.items[i].oferta,
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
