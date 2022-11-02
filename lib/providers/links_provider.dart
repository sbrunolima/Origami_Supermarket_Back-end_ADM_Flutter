import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../providers/links.dart';
import '../models/http_exception.dart';

class LinksProvider with ChangeNotifier {
  List<Links> _links = [];

  List<Links> get links {
    return [..._links];
  }

  Links findLinkId(String id) {
    return _links.firstWhere((link) => link.id == id);
  }

  // ADD LINKS e ADIT LINKS

  Future<void> addLink(Links links) async {
    final url = Uri.parse('');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'link': links.linkUrl,
        }),
      );

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateLinks(String id, Links newLink) async {
    final linkIndex = _links.indexWhere((link) => link.id == id);
    if (linkIndex >= 0) {
      final url = Uri.parse('');
      await http.patch(
        url,
        body: json.encode({
          'link': newLink.linkUrl,
        }),
      );
      _links[linkIndex] = newLink;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> loadLinks() async {
    final url = Uri.parse('');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Links> loadedLinks = [];
      extractedData.forEach((linkId, linkData) {
        loadedLinks.add(
          Links(
            id: linkId,
            linkUrl: linkData['link'],
          ),
        );
      });
      _links = loadedLinks;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteLink(String id) async {
    final url = Uri.parse('');
    final existingLinkIndex = _links.indexWhere((link) => link.id == id);
    var existingLink = _links[existingLinkIndex];

    _links.removeAt(existingLinkIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _links.insert(existingLinkIndex, existingLink);
      notifyListeners();
      throw HttpException('Não foi possível deletar o produto.');
    }
    existingLink;
  }
}
