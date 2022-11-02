import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewUser {
  final String? id;
  final String? name;
  final String? fone;
  final String? rua;
  final String? complemento;
  final String? cidade;
  bool hasAddress;

  NewUser({
    @required this.id,
    @required this.name,
    @required this.fone,
    @required this.rua,
    @required this.complemento,
    @required this.cidade,
    this.hasAddress = false,
  });
}

class User with ChangeNotifier {
  List<NewUser> _users = [];

  final String authToken;
  final String userId;

  User(this.authToken, this.userId, this._users);

  List<NewUser> get users {
    return [..._users];
  }

  NewUser findById(String id) {
    return _users.firstWhere((user) => user.id == id);
  }

  //Adicoina os pedidos no API firebase
  Future<void> addUser(NewUser newUser) async {
    final url = Uri.parse('');
    final response = await http.post(
      url,
      body: json.encode(
        {
          'nome': newUser.name,
          'fone': newUser.fone,
          'rua': newUser.rua,
          'complemento': newUser.complemento,
          'cidade': newUser.cidade,
          'hasAddress': true,
        },
      ),
    );
    notifyListeners();
  }

  Future<void> fetchUserData() async {
    final url = Uri.parse('');

    final response = await http.get(url);
    final List<NewUser> loadedUser = [];
    final extraxtedData = json.decode(response.body) as Map<String, dynamic>;
    if (extraxtedData == null) {
      return;
    }

    extraxtedData.forEach((orderId, userData) {
      loadedUser.add(
        NewUser(
          id: orderId,
          name: userData['nome'],
          fone: userData['fone'],
          rua: userData['rua'],
          complemento: userData['complemento'],
          cidade: userData['cidade'],
          hasAddress: userData['hasAddress'],
        ),
      );
    });
    _users = loadedUser.toList();

    notifyListeners();

    print('has addres: ${userId}');
  }

  Future<void> updateUserAdress(String id, NewUser editedUser) async {
    final userIndex = _users.indexWhere((user) => user.id == id);
    if (userIndex >= 0) {
      final url = Uri.parse('');
      await http.patch(
        url,
        body: json.encode({
          'nome': editedUser.name,
          'fone': editedUser.fone,
          'rua': editedUser.rua,
          'complemento': editedUser.complemento,
          'cidade': editedUser.cidade,
          'hasAddress': editedUser.hasAddress,
        }),
      );
      _users[userIndex] = editedUser;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> clear() async {
    _users.clear();
    notifyListeners();
  }
}
