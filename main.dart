import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = 'http://localhost:3000';

Future<void> afficherProduits() async {
  final response = await http.get(Uri.parse('$baseUrl/produits'));
  if (response.statusCode == 200) {
    final produits = jsonDecode(response.body);
    print('Produits disponibles :');
    produits.forEach((produit) {
      print('Nom: ${produit['nom']}, Prix: ${produit['prix']} DH');
    });
  } else {
    print('Erreur lors de la récupération des produits.');
  }
}

Future<void> ajouterProduit(String nom, double prix, int stock, String categorie) async {
  final produit = {
    'nom': nom,
    'prix': prix,
    'stock': stock,
    'categorie': categorie,
  };
  final response = await http.post(
    Uri.parse('$baseUrl/produits'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(produit),
  );
  if (response.statusCode == 201) {
    print('Produit ajouté avec succès.');
  } else {
    print('Erreur lors de l\'ajout du produit.');
  }
}

void main() async {
  // Exemples d'utilisation
  await afficherProduits();
  await ajouterProduit('Tablette', 1500.0, 10, 'Électronique');
  await afficherProduits();
}