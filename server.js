const express = require('express');
const fs = require('fs');
const path = require('path');

const app = express();
const port = 3000;

app.use(express.json());

// Chemin vers le fichier produit.json
const produitsPath = path.join(__dirname, 'data', 'produits.json');

// Route GET /produits
app.get('/produits', (req, res) => {
  fs.readFile(produitsPath, 'utf8', (err, data) => {
    if (err) {
      return res.status(500).json({ error: 'Erreur lors de la lecture des produits' });
    }
    const produits = JSON.parse(data);
    res.json(produits);
  });
});

// Route POST /produits
app.post('/produits', (req, res) => {
  const newProduct = req.body;

  // Validation des données
  if (!newProduct.nom || !newProduct.prix || newProduct.prix <= 0) {
    return res.status(400).json({ error: 'Données invalides' });
  }

  fs.readFile(produitsPath, 'utf8', (err, data) => {
    if (err) {
      return res.status(500).json({ error: 'Erreur lors de la lecture des produits' });
    }
    const produits = JSON.parse(data);
    newProduct.id = produits.length + 1; // Génère un ID simple
    produits.push(newProduct);
    fs.writeFile(produitsPath, JSON.stringify(produits, null, 2), (err) => {
      if (err) {
        return res.status(500).json({ error: 'Erreur lors de l\'écriture des produits' });
      }
      res.status(201).json(newProduct);
    });
  });
});

// Route PUT /produits/:id
app.put('/produits/:id', (req, res) => {
  const productId = parseInt(req.params.id); // Récupère l'ID du produit
  const updatedProduct = req.body; // Récupère les nouvelles données du produit

  // Vérifie que les données sont valides
  if (!updatedProduct.nom || !updatedProduct.prix || updatedProduct.prix <= 0) {
    return res.status(400).json({ error: 'Données invalides' });
  }

  // Lit le fichier produit.json
  fs.readFile(produitsPath, 'utf8', (err, data) => {
    if (err) {
      return res.status(500).json({ error: 'Erreur lors de la lecture des produits' });
    }

    // Parse les produits existants
    let produits = JSON.parse(data);

    // Trouve l'index du produit à mettre à jour
    const index = produits.findIndex(p => p.id === productId);

    // Si le produit n'existe pas, renvoie une erreur 404
    if (index === -1) {
      return res.status(404).json({ error: 'Produit non trouvé' });
    }

    // Met à jour le produit
    produits[index] = { ...produits[index], ...updatedProduct };

    // Sauvegarde les modifications dans le fichier produit.json
    fs.writeFile(produitsPath, JSON.stringify(produits, null, 2), (err) => {
      if (err) {
        return res.status(500).json({ error: 'Erreur lors de l\'écriture des produits' });
      }
    //DELETE 
    app.delete('/commandes/:id', (req, res) => {
        const commandeId = parseInt(req.params.id);
      
        fs.readFile(commandesPath, 'utf8', (err, data) => {
          if (err) {
            return res.status(500).json({ error: 'Erreur lors de la lecture des commandes' });
          }
          let commandes = JSON.parse(data);
          const index = commandes.findIndex(c => c.id === commandeId);
      
          if (index === -1) {
            return res.status(404).json({ error: 'Commande non trouvée' });
          }
      
          commandes.splice(index, 1);
          fs.writeFile(commandesPath, JSON.stringify(commandes, null, 2), (err) => {
            if (err) {
              return res.status(500).json({ error: 'Erreur lors de l\'écriture des commandes' });
            }
            res.status(204).send();
          });
        });
      });

      // Renvoie le produit mis à jour
      res.json(produits[index]);
    });
  });
});

// Démarrer le serveur
app.listen(port, () => {
  console.log(`Serveur en cours d'exécution sur http://localhost:${port}`);
});