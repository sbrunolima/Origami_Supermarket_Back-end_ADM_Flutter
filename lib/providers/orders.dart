import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../providers/cart.dart';
import '../models/http_exception.dart';

class OrderItem {
  final String? id;
  final double? amount;
  final List<CartItem>? products;
  final DateTime? dateTime;
  final String? paymentType;
  final String? troco;
  final String? description;
  final String? cpf;
  final String? address;
  final String? nomeTel;
  final double? frete;
  final double? cartAmount;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
    @required this.paymentType,
    @required this.troco,
    @required this.description,
    @required this.cpf,
    @required this.address,
    @required this.nomeTel,
    @required this.frete,
    @required this.cartAmount,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse('');
    final response = await http.get(url);

    final List<OrderItem> loadedOrders = [];
    final extraxtedData = json.decode(response.body) as Map<String, dynamic>;
    if (extraxtedData == null) {
      return;
    }

    extraxtedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                    imageUrl: item['imageUrl'],
                  ))
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime']),
          paymentType: orderData['paymentType'],
          troco: orderData['troco'],
          description: orderData['description'],
          cpf: orderData['cpf'],
          address: orderData['address'],
          nomeTel: orderData['nomeTel'],
          frete: orderData['frete'],
          cartAmount: orderData['cartAmount'],
        ),
      );
    });
    _orders = loadedOrders.toList();
    notifyListeners();
  }

  Future<void> deleteOrder(String id) async {
    final url = Uri.parse('');
    final existingOrderIndex = _orders.indexWhere((prod) => prod.id == id);
    var existingOrder = _orders[existingOrderIndex];

    _orders.removeAt(existingOrderIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _orders.insert(existingOrderIndex, existingOrder);
      notifyListeners();
      throw HttpException('Não foi possível deletar o produto.');
    }
    existingOrder;
  }
}
