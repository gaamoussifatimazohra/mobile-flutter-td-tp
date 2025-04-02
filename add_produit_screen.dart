import 'package:flutter/material.dart';
import '../models/produit.dart';
import '../services/api_service.dart';

class AddProduitScreen extends StatefulWidget {
  @override
  _AddProduitScreenState createState() => _AddProduitScreenState();
}

class _AddProduitScreenState extends State<AddProduitScreen> {
  final _formKey = GlobalKey<FormState>(); // Clé pour valider le formulaire
  final _nomController = TextEditingController(); // Contrôleur pour le champ "Nom"
  final _prixController = TextEditingController(); // Contrôleur pour le champ "Prix"
  final _stockController = TextEditingController(); // Contrôleur pour le champ "Stock"
  final _categorieController = TextEditingController(); // Contrôleur pour le champ "Catégorie"
  final ApiService apiService = ApiService(); // Instance du service API
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un produit'), // Titre de l'écran
      ),
      body: Padding(
        padding: EdgeInsets.all(16), // Espacement autour du formulaire
        child: Form(
          key: _formKey, // Associe la clé du formulaire
          child: Column(
            children: [
              // Champ pour le nom du produit
              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              // Champ pour le prix du produit
              TextFormField(
                controller: _prixController,
                decoration: InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.number, // Clavier numérique
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prix';
                  }
                  return null;
                },
              ),
              // Champ pour le stock du produit
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number, // Clavier numérique
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un stock';
                  }
                  return null;
                },
              ),
              // Champ pour la catégorie du produit
              TextFormField(
                controller: _categorieController,
                decoration: InputDecoration(labelText: 'Catégorie'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une catégorie';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16), // Espacement entre les champs et le bouton
              // Bouton pour ajouter le produit
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Crée un nouvel objet Produit avec les données du formulaire
                    Produit newProduit = Produit(
                      id: 0, // L'ID sera généré par l'API
                      nom: _nomController.text,
                      prix: double.parse(_prixController.text),
                      stock: int.parse(_stockController.text),
                      categorie: _categorieController.text,
                    );

                    try {
                      // Envoie une requête POST à l'API pour ajouter le produit
                      await apiService.createProduit(newProduit);
                      // Revenir à l'écran précédent après l'ajout
                      Navigator.pop(context);
                    } catch (e) {
                      // Affiche un message d'erreur en cas de problème
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erreur: $e')),
                      );
                    }
                  }
                },
                child: Text('Ajouter'), // Texte du bouton
              ),
            ],
          ),
        ),
      ),
    );
  }
}