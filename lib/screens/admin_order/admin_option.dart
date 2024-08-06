import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raj_eat/models/product_option_model.dart/';
class AdminOption {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addProductOption(ProductOption productOption) async {
    try {
      // Référence à la collection "ProductOptions"
      CollectionReference productOptions = _firestore.collection('ProductOptions');

      // Ajouter le document à Firestore
      await productOptions.add(productOption.toMap());
      print('Document ajouté avec succès');
    } catch (error) {
      print('Erreur lors de l\'ajout du document: $error');
    }
  }
}