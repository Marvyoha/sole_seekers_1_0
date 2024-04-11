import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/shoes_model.dart';

class QueryProvider extends ChangeNotifier {
  QueryProvider() {
    querySetter();
  }
  final _shoesPGDb = FirebaseFirestore.instance
      .collection('catalogs')
      .withConverter<Item>(
          fromFirestore: (snapshot, _) => Item.fromJson(snapshot.data()!),
          toFirestore: (item, _) => item.toJson());

  bool nike = false,
      adidas = false,
      reebok = false,
      nakedWolfe = false,
      newBalance = false;

  late Query<Item> newQuery;

  CollectionReference<Item> get shoesPGDb => _shoesPGDb;

  String checkSelectedBrand() {
    if (nike) return 'nike';
    if (adidas) return 'adidas';
    if (reebok) return 'reebok';
    if (nakedWolfe) return 'nakedWolfe';
    if (newBalance) return 'newBalance';
    return 'allItems';
  }

  void querySetter() {
    String selected = checkSelectedBrand();

    switch (selected) {
      case 'nike':
        newQuery = shoesPGDb.where("brand", isEqualTo: 'nike');
      case 'adidas':
        newQuery = shoesPGDb.where("brand", isEqualTo: 'adidas');
      case 'reebok':
        newQuery = shoesPGDb.where("brand", isEqualTo: 'reebok');
      case 'nakedWolfe':
        newQuery = shoesPGDb.where("brand", isEqualTo: 'nakedWolfe');
      case 'newBalance':
        newQuery = shoesPGDb.where("brand", isEqualTo: 'newBalance');
      default:
        newQuery = shoesPGDb.orderBy('id');
    }
    notifyListeners();
  }
}
