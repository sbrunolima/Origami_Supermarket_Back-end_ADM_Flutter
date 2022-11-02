import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/order_items_list.dart';
import '../screens/start_screen.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders-screen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
  var index;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Acessa os pedidos
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          onPressed: () {
            Navigator.of(context).popAndPushNamed(StartScreen.routeName);
          },
        ),
        title: const Center(
          child: Text(
            'PEDIDOS',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 60,
              width: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                child: Row(
                  children: const [
                    Text('CARREGAR PEDIDOS'),
                    Icon(Icons.refresh_rounded, size: 30)
                  ],
                ),
                onPressed: () {
                  Future.delayed(Duration.zero).then((_) async {
                    setState(() {
                      _isLoading = true;
                    });
                    await Provider.of<Orders>(context, listen: false)
                        .fetchAndSetOrders();
                    setState(() {
                      _isLoading = false;
                    });
                  });
                },
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
      body: orderData.orders.length < 1
          ? noItenOnCart()
          : _isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(
                        color: Colors.grey,
                      ),
                      SizedBox(height: 5),
                      Text('Carregando...'),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: orderData.orders.length,
                          itemBuilder: (ctx, i) => OrdersItemsList(
                            orderData.orders[i],
                            i,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget noItenOnCart() {
    return Center(
      child: Column(
        children: const [
          SizedBox(height: 200),
          Icon(
            Icons.shopping_cart,
            color: Colors.grey,
            size: 100,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Nenhum pedido no sistema.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
