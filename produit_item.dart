import 'package:flutter/material.dart';
import '../models/produit.dart';

class ProduitItem extends StatelessWidget {
  final Produit produit;

  ProduitItem({required this.produit});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text(produit.nom),
        subtitle: Text('Prix: ${produit.prix} € | Stock: ${produit.stock}'),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            // Supprimer le produit
          },
        ),
        onTap: () {
          // Naviguer vers l'écran de détail du produit
        },
      ),
    );
  }
}