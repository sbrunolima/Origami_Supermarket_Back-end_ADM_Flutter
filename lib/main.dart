import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/ofertas_screen.dart';
import './screens/orders_screen.dart';
import './providers/orders.dart';
import './screens/start_screen.dart';
import './screens/add_products_screen.dart';
import './providers/products_provider.dart';
import 'screens/edit_product_screen.dart';
import 'screens/by_category_screen.dart';
import './screens/departments_screen.dart';
import './screens/cidades_screen.dart';
import 'screens/edit_cidade_screen.dart';
import './screens/edit_link_screen.dart'; 
import './screens/propagandas_screen.dart';
import './screens/frete_screen.dart';
import './providers/frete_provider.dart';
import './screens/edit_frete_screen.dart';
import './providers/links_provider.dart';
import '../providers/cidade_provider.dart';
import './invoice/invoice_page.dart';

void main() => runApp(ShopAdmin());

class ShopAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => ProductsProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => LinksProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => CidadeProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Orders(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => FreteProvider(),
          ),
          // ChangeNotifierProvider(
          //   create: (ctx) => Payment(),
          // ),
        ],
        child: MaterialApp(
          title: 'Shop App ADMIN',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: StartScreen(),
          routes: {
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            StartScreen.routeName: (ctx) => StartScreen(),
            AddProductsScreen.routeName: (ctx) => AddProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            OfertasScreen.routeName: (ctc) => OfertasScreen(),
            ByCategoryScreen.routeName: (ctx) => ByCategoryScreen(),
            DepartmentScreen.routeName: (ctx) => DepartmentScreen(),
            CidadesScreen.routeName: (ctx) => CidadesScreen(),
            EditLinksScreen.routeName: (ctx) => EditLinksScreen(),
            EditCidadeScreen.routeName: (ctx) => EditCidadeScreen(),
            PropagandasScreen.routeName: (ctx) => PropagandasScreen(),
            FreteScreen.routeName: (ctx) => FreteScreen(),
            EditFreteScreen.routeName: (ctx) => EditFreteScreen(),
            InvoiceScreen.routeName: (ctx) => InvoiceScreen(),
          },
        ));
  }
}
