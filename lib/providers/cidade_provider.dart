import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/http_exception.dart';

class Cidade with ChangeNotifier {
  final String? id;
  final String? cidadeName;

  Cidade({
    @required this.id,
    @required this.cidadeName,
  });
}

class CidadeProvider with ChangeNotifier {
  List<Cidade> _cidade = [];

  List<Cidade> get cidade {
    return [..._cidade];
  }

  Cidade findCidadeId(String id) {
    return _cidade.firstWhere((cidade) => cidade.id == id);
  }

  Future<void> addCidade(Cidade cidade) async {
    final url = Uri.parse('');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'cidade': cidade.cidadeName,
        }),
      );

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteCidade(String id) async {
    final url = Uri.parse('');
    final existingCidadeIndex = _cidade.indexWhere((cidade) => cidade.id == id);
    var existingCidade = _cidade[existingCidadeIndex];

    _cidade.removeAt(existingCidadeIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _cidade.insert(existingCidadeIndex, existingCidade);
      notifyListeners();
      throw HttpException('Não foi possível deletar o produto.');
    }
    existingCidade;
  }

  Future<void> updateCidade(String id, Cidade newCidade) async {
    final cidadeIndex = _cidade.indexWhere((cidade) => cidade.id == id);
    if (cidadeIndex >= 0) {
      final url = Uri.parse('');
      await http.patch(
        url,
        body: json.encode({
          'cidade': newCidade.cidadeName,
        }),
      );
      _cidade[cidadeIndex] = newCidade;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> loadCidades() async {
    final url = Uri.parse('');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Cidade> loadedCidades = [];
      extractedData.forEach((cidadeId, cidadeData) {
        loadedCidades.add(
          Cidade(
            id: cidadeId,
            cidadeName: cidadeData['cidade'],
          ),
        );
      });
      _cidade = loadedCidades;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
