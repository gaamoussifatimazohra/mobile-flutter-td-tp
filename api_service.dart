import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/produit.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000';

  Future<List<Produit>> fetchProduits() async {
    final response = await http.get(Uri.parse('$baseUrl/produits'));
    

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Produit.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors de la récupération des produits');
    }
  }

  Future<Produit> createProduit(Produit produit) async {
    final response = await http.post(
      Uri.parse('$baseUrl/produits'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(produit.toJson()),
    );

    if (response.statusCode == 201) {
      return Produit.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erreur lors de la création du produit');
    }
  }

  Future<Produit> updateProduit(int id, Produit produit) async {
    final response = await http.put(
      Uri.parse('$baseUrl/produits/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(produit.toJson()),
    );

    if (response.statusCode == 200) {
      return Produit.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erreur lors de la mise à jour du produit');
    }
  }

  Future<void> deleteProduit(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/produits/$id'));

    if (response.statusCode != 204) {
      throw Exception('Erreur lors de la suppression du produit');
    }
  }
}