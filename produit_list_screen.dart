import 'package:flutter/material.dart';
import 'add_produit_screen.dart'; // Importe l'écran d'ajout de produit
import '../models/produit.dart'; // Importe le modèle Produit
import '../services/api_service.dart'; // Importe le service API

class ProduitListScreen extends StatefulWidget {
  @override
  _ProduitListScreenState createState() => _ProduitListScreenState();
}

class _ProduitListScreenState extends State<ProduitListScreen> {
  final ApiService apiService = ApiService(); // Instance du service API
  late Future<List<Produit>> futureProduits; // Future pour stocker les produits

  @override
  void initState() {
    super.initState();
    futureProduits = apiService.fetchProduits(); // Charge les produits au démarrage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des produits'), // Titre de l'écran
      ),
      body: FutureBuilder<List<Produit>>(
        future: futureProduits,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Affiche un indicateur de chargement pendant le chargement des données
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Affiche un message d'erreur si la requête échoue
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Affiche un message si la liste des produits est vide
            return Center(child: Text('Aucun produit trouvé'));
          } else {
            // Affiche la liste des produits
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Produit produit = snapshot.data![index];
                return ListTile(
                  title: Text(produit.nom), // Nom du produit
                  subtitle: Text('Prix: ${produit.prix} € | Stock: ${produit.stock}'), // Détails du produit
                  onTap: () {
                    // Navigue vers l'écran de détail du produit (à implémenter)
                  },
                );
              },
            );
          }
        },
      ),
      // Bouton flottant pour ajouter un produit
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigue vers l'écran d'ajout de produit
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProduitScreen()),
          );
        },
        child: Icon(Icons.add), // Icône du bouton
      ),
    );
  }
}