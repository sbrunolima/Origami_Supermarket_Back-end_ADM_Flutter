import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../providers/product.dart';
import '../models/http_exception.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  var _onlyOfertas = false;
  var _onlyHortifruti = false;
  var _onlyAcougue = false;
  var _onlyCongelados = false;
  var _onlyResfriados = false;
  var _onlyPadaria = false;
  var _onlyPaeseBolos = false;
  var _onlyMercearia = false;
  var _onlyMatinais = false;
  var _onlyBiscoitos = false;
  var _onlyBebidas = false;
  var _onlyLimpeza = false;
  var _onlyPerfumaria = false;
  var _onlyPetShop = false;

  //Retorna apenas os itens selecionados
  List<Product> get items {
    if (_onlyHortifruti) {
      return _items
          .where((prodItem) => prodItem.sector == 'Hortifruti')
          .toList();
    }
    if (_onlyAcougue) {
      return _items.where((prodItem) => prodItem.sector == 'Acougue').toList();
    }

    if (_onlyCongelados) {
      return _items
          .where((prodItem) => prodItem.sector == 'Congelados')
          .toList();
    }
    if (_onlyResfriados) {
      return _items
          .where((prodItem) => prodItem.sector == 'Resfriados')
          .toList();
    }
    if (_onlyPadaria) {
      return _items.where((prodItem) => prodItem.sector == 'Padaria').toList();
    }
    if (_onlyPaeseBolos) {
      return _items
          .where((prodItem) => prodItem.sector == 'Pães e Bolos')
          .toList();
    }
    if (_onlyMercearia) {
      return _items
          .where((prodItem) => prodItem.sector == 'Mercearia')
          .toList();
    }
    if (_onlyMatinais) {
      return _items.where((prodItem) => prodItem.sector == 'Matinais').toList();
    }
    if (_onlyBiscoitos) {
      return _items
          .where((prodItem) => prodItem.sector == 'Biscoitos')
          .toList();
    }
    if (_onlyBebidas) {
      return _items.where((prodItem) => prodItem.sector == 'Bebidas').toList();
    }
    if (_onlyLimpeza) {
      return _items.where((prodItem) => prodItem.sector == 'Limpeza').toList();
    }
    if (_onlyPerfumaria) {
      return _items
          .where((prodItem) => prodItem.sector == 'Perfumaria')
          .toList();
    }
    if (_onlyPetShop) {
      return _items.where((prodItem) => prodItem.sector == 'Pet Shop').toList();
    }

    if (_onlyOfertas) {
      return _items.where((prodItem) => prodItem.oferta).toList();
    }

    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> loadProducts() async {
    final url = Uri.parse('');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProduct = [];
      extractedData.forEach((productId, productData) {
        loadedProduct.add(
          Product(
            id: productId,
            title: productData['title'],
            price: productData['price'],
            offerPrice: productData['offerPrice'],
            imageUrl: productData['imageUrl'],
            sector: productData['sector'],
            oferta: productData['oferta'],
            granel: productData['granel'],
          ),
        );
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse('');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'price': product.price,
          'offerPrice': product.offerPrice,
          'imageUrl': product.imageUrl,
          'sector': product.sector,
          'oferta': product.oferta,
          'granel': product.granel,
        }),
      );

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        price: product.price,
        offerPrice: product.offerPrice,
        imageUrl: product.imageUrl.toString(),
        sector: product.sector,
        oferta: false,
      );

      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((product) => product.id == id);
    if (productIndex >= 0) {
      final url = Uri.parse('');
      await http.patch(
        url,
        body: json.encode({
          'title': newProduct.title,
          'price': newProduct.price,
          'offerPrice': newProduct.offerPrice,
          'imageUrl': newProduct.imageUrl,
          'sector': newProduct.sector,
          'oferta': newProduct.oferta,
          'granel': newProduct.granel,
        }),
      );
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse('');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Não foi possível deletar o produto.');
    }
    existingProduct;
  }

  Future<void> findedProducts(String query) async {
    final url = Uri.parse('');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProduct = [];
      extractedData.forEach((productId, productData) {
        if (productData['title']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase())) {
          loadedProduct.add(
            Product(
              id: productId,
              title: productData['title'],
              price: productData['price'],
              offerPrice: productData['offerPrice'],
              imageUrl: productData['imageUrl'],
              sector: productData['sector'],
              oferta: productData['oferta'],
              granel: productData['granel'],
            ),
          );
        }
      });
      _items = loadedProduct;

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  //Todos os seletores de setores
  void showOfertas() {
    _onlyOfertas = true;
    _onlyHortifruti = false;
    _onlyAcougue = false;
    _onlyCongelados = false;
    _onlyResfriados = false;
    _onlyPadaria = false;
    _onlyPaeseBolos = false;
    _onlyMercearia = false;
    _onlyMatinais = false;
    _onlyBiscoitos = false;
    _onlyBebidas = false;
    _onlyLimpeza = false;
    _onlyPerfumaria = false;
    _onlyPetShop = false;

    notifyListeners();
  }

  void showAcouge() {
    _onlyAcougue = true;
    _onlyBebidas = false;
    _onlyHortifruti = false;
    _onlyCongelados = false;
    _onlyResfriados = false;
    _onlyPadaria = false;
    _onlyPaeseBolos = false;
    _onlyMercearia = false;
    _onlyMatinais = false;
    _onlyBiscoitos = false;
    _onlyLimpeza = false;
    _onlyPerfumaria = false;
    _onlyPetShop = false;
    notifyListeners();
  }

  void showHortifruti() {
    _onlyHortifruti = true;
    _onlyAcougue = false;
    _onlyBebidas = false;
    _onlyCongelados = false;
    _onlyResfriados = false;
    _onlyPadaria = false;
    _onlyPaeseBolos = false;
    _onlyMercearia = false;
    _onlyMatinais = false;
    _onlyBiscoitos = false;
    _onlyLimpeza = false;
    _onlyPerfumaria = false;
    _onlyPetShop = false;
    notifyListeners();
  }

  void showCongelados() {
    _onlyCongelados = true;
    _onlyHortifruti = false;
    _onlyAcougue = false;
    _onlyBebidas = false;
    _onlyResfriados = false;
    _onlyPadaria = false;
    _onlyPaeseBolos = false;
    _onlyMercearia = false;
    _onlyMatinais = false;
    _onlyBiscoitos = false;
    _onlyLimpeza = false;
    _onlyPerfumaria = false;
    _onlyPetShop = false;
    notifyListeners();
  }

  void showResfriados() {
    _onlyResfriados = true;
    _onlyCongelados = false;
    _onlyHortifruti = false;
    _onlyAcougue = false;
    _onlyBebidas = false;
    _onlyPadaria = false;
    _onlyPaeseBolos = false;
    _onlyMercearia = false;
    _onlyMatinais = false;
    _onlyBiscoitos = false;
    _onlyLimpeza = false;
    _onlyPerfumaria = false;
    _onlyPetShop = false;
    notifyListeners();
  }

  void showPadaria() {
    _onlyPadaria = true;
    _onlyResfriados = false;
    _onlyCongelados = false;
    _onlyHortifruti = false;
    _onlyAcougue = false;
    _onlyBebidas = false;
    _onlyPaeseBolos = false;
    _onlyMercearia = false;
    _onlyMatinais = false;
    _onlyBiscoitos = false;
    _onlyLimpeza = false;
    _onlyPerfumaria = false;
    _onlyPetShop = false;
    notifyListeners();
  }

  void showPaeseBolos() {
    _onlyPaeseBolos = true;
    _onlyPadaria = false;
    _onlyResfriados = false;
    _onlyCongelados = false;
    _onlyHortifruti = false;
    _onlyAcougue = false;
    _onlyBebidas = false;
    _onlyMercearia = false;
    _onlyMatinais = false;
    _onlyBiscoitos = false;
    _onlyLimpeza = false;
    _onlyPerfumaria = false;
    _onlyPetShop = false;
    notifyListeners();
  }

  void showMercearia() {
    _onlyMercearia = true;
    _onlyPaeseBolos = false;
    _onlyPadaria = false;
    _onlyResfriados = false;
    _onlyCongelados = false;
    _onlyHortifruti = false;
    _onlyAcougue = false;
    _onlyBebidas = false;
    _onlyMatinais = false;
    _onlyBiscoitos = false;
    _onlyLimpeza = false;
    _onlyPerfumaria = false;
    _onlyPetShop = false;
    notifyListeners();
  }

  void showMatinais() {
    _onlyMatinais = true;
    _onlyMercearia = false;
    _onlyPaeseBolos = false;
    _onlyPadaria = false;
    _onlyResfriados = false;
    _onlyCongelados = false;
    _onlyHortifruti = false;
    _onlyAcougue = false;
    _onlyBebidas = false;
    _onlyBiscoitos = false;
    _onlyLimpeza = false;
    _onlyPerfumaria = false;
    _onlyPetShop = false;
    notifyListeners();
  }

  void showBiscoitos() {
    _onlyBiscoitos = true;
    _onlyMatinais = false;
    _onlyMercearia = false;
    _onlyPaeseBolos = false;
    _onlyPadaria = false;
    _onlyResfriados = false;
    _onlyCongelados = false;
    _onlyHortifruti = false;
    _onlyAcougue = false;
    _onlyBebidas = false;
    _onlyLimpeza = false;
    _onlyPerfumaria = false;
    _onlyPetShop = false;
    notifyListeners();
  }

  void showLimpeza() {
    _onlyLimpeza = true;
    _onlyBiscoitos = false;
    _onlyMatinais = false;
    _onlyMercearia = false;
    _onlyPaeseBolos = false;
    _onlyPadaria = false;
    _onlyResfriados = false;
    _onlyCongelados = false;
    _onlyHortifruti = false;
    _onlyAcougue = false;
    _onlyBebidas = false;
    _onlyPerfumaria = false;
    _onlyPetShop = false;
    notifyListeners();
  }

  void showPerfumaria() {
    _onlyPerfumaria = true;
    _onlyLimpeza = false;
    _onlyBiscoitos = false;
    _onlyMatinais = false;
    _onlyMercearia = false;
    _onlyPaeseBolos = false;
    _onlyPadaria = false;
    _onlyResfriados = false;
    _onlyCongelados = false;
    _onlyHortifruti = false;
    _onlyAcougue = false;
    _onlyBebidas = false;
    _onlyPetShop = false;
    notifyListeners();
  }

  void showPetShop() {
    _onlyPetShop = true;
    _onlyPerfumaria = false;
    _onlyLimpeza = false;
    _onlyBiscoitos = false;
    _onlyMatinais = false;
    _onlyMercearia = false;
    _onlyPaeseBolos = false;
    _onlyPadaria = false;
    _onlyResfriados = false;
    _onlyCongelados = false;
    _onlyHortifruti = false;
    _onlyAcougue = false;
    _onlyBebidas = false;
    notifyListeners();
  }

  void showBebidas() {
    _onlyBebidas = true;
    _onlyHortifruti = false;
    _onlyAcougue = false;
    _onlyCongelados = false;
    _onlyResfriados = false;
    _onlyPadaria = false;
    _onlyPaeseBolos = false;
    _onlyMercearia = false;
    _onlyMatinais = false;
    _onlyBiscoitos = false;
    _onlyLimpeza = false;
    _onlyPerfumaria = false;
    _onlyPetShop = false;
    notifyListeners();
  }

  void showAll() {
    _onlyOfertas = false;
    _onlyHortifruti = false;
    _onlyAcougue = false;
    _onlyBebidas = false;
    _onlyCongelados = false;
    _onlyResfriados = false;
    _onlyPadaria = false;
    _onlyPaeseBolos = false;
    _onlyMercearia = false;
    _onlyMatinais = false;
    _onlyBiscoitos = false;
    _onlyLimpeza = false;
    _onlyPerfumaria = false;
    _onlyPetShop = false;
    notifyListeners();
  }
}
