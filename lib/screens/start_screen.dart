import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/buttons_widgets.dart';
import '../screens/orders_screen.dart';
import '../screens/add_products_screen.dart';
import '../providers/products_provider.dart';
import '../screens/ofertas_screen.dart';
import '../screens/departments_screen.dart';
import '../screens/cidades_screen.dart';
import '../screens/propagandas_screen.dart';
import '../screens/frete_screen.dart';

class StartScreen extends StatelessWidget {
  static const routeName = '/start-screen';

  @override
  Widget build(BuildContext context) {
    final sizedBox = const SizedBox(width: 20);
    final sizedBox2 = const SizedBox(width: 25);
    final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Center(child: Text('Delivery Admin')),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .popAndPushNamed(OrdersScreen.routeName);
                    },
                    child: ButtonsWidget('assets/pedidos.png', 'Ver Pedidos'),
                  ),
                  sizedBox,
                  GestureDetector(
                    onTap: () {
                      productsData.showAll();
                      Navigator.of(context)
                          .popAndPushNamed(AddProductsScreen.routeName);
                    },
                    child: ButtonsWidget(
                        'assets/cadastrar.png', 'Cadastrar/Editar Itens'),
                  ),
                  sizedBox,
                  GestureDetector(
                    onTap: () {
                      productsData.showOfertas();
                      Navigator.of(context)
                          .popAndPushNamed(OfertasScreen.routeName);
                    },
                    child: ButtonsWidget(
                        'assets/ofertasMenu.png', 'Produtos em Oferta'),
                  ),
                  sizedBox,
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .popAndPushNamed(DepartmentScreen.routeName);
                    },
                    child: ButtonsWidget(
                        'assets/departamentos.png', 'Departamentos'),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .popAndPushNamed(CidadesScreen.routeName);
                    },
                    child: ButtonsWidget('assets/cidades.png', 'Cidades'),
                  ),
                  sizedBox2,
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .popAndPushNamed(PropagandasScreen.routeName);
                    },
                    child:
                        ButtonsWidget('assets/propagandas.png', 'Propagandas'),
                  ),
                  sizedBox2,
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .popAndPushNamed(FreteScreen.routeName);
                    },
                    child: ButtonsWidget('assets/frete.png', 'Frete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Created by:'),
              const SizedBox(width: 10),
              Image.asset(
                'assets/brunologo.png',
                scale: 10,
              ),
              const SizedBox(width: 2),
              const Text('Bruno L. Santos'),
              const SizedBox(width: 10),
              const Text('- version[1.0.r22-05]'),
            ],
          ),
        ),
      ],
    );
  }
}
