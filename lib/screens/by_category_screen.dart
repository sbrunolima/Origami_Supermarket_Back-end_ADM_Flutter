import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/system_product_item.dart';

class ByCategoryScreen extends StatefulWidget {
  static const routeName = '/by-catedory-screen';

  @override
  State<ByCategoryScreen> createState() => _ByCategoryScreenState();
}

class _ByCategoryScreenState extends State<ByCategoryScreen> {
  var _isLoading = false;
  var _isInit = true;
  var title;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<ProductsProvider>(context).loadProducts();
      final pageId = ModalRoute.of(context)!.settings.arguments;
      if (pageId != null) {
        setState(() {
          title = pageId.toString();
        });
      }

      switch (title.toString()) {
        case 'Hortifruti':
          Provider.of<ProductsProvider>(context).showHortifruti();
          break;
        case 'Açougue':
          Provider.of<ProductsProvider>(context).showAcouge();
          break;
        case 'Congelados':
          Provider.of<ProductsProvider>(context).showCongelados();
          break;
        case 'Resfriados':
          Provider.of<ProductsProvider>(context).showResfriados();
          break;
        case 'Padaria':
          Provider.of<ProductsProvider>(context).showPadaria();
          break;
        case 'Paes e Bolos':
          Provider.of<ProductsProvider>(context).showPaeseBolos();
          break;
        case 'Mercearia':
          Provider.of<ProductsProvider>(context).showMercearia();
          break;
        case 'Matinais':
          Provider.of<ProductsProvider>(context).showMatinais();
          break;
        case 'Biscoitos':
          Provider.of<ProductsProvider>(context).showBiscoitos();
          break;
        case 'Bebidas':
          Provider.of<ProductsProvider>(context).showBebidas();
          break;
        case 'Limpeza':
          Provider.of<ProductsProvider>(context).showLimpeza();
          break;
        case 'Perfumaria':
          Provider.of<ProductsProvider>(context).showPerfumaria();
          break;
        case 'Pet Shop':
          Provider.of<ProductsProvider>(context).showPetShop();
          break;
        default:
          Provider.of<ProductsProvider>(context).showAll();
          break;
      }
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
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: 50,
            child: TextField(
              onChanged: (value) {
                searchProduct(value.toString());
              },
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.grey.shade200)),
                hintText: 'Buscar Produto',
                prefixIcon: const Icon(Icons.search, color: Colors.black),
              ),
            ),
          ),
        ),
      ),
      body: (_isLoading && productsData.items.length >= 1)
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
                    child: Center(
                      child: Text(
                        title.toString().toUpperCase(),
                        style: const TextStyle(
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
