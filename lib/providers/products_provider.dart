import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:food_app/app_constants.dart';
import 'package:food_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  final List<Product> _products = [];

  double get totalCalories =>
      _products.map((e) => e.calories).whereNotNull().sum;
  double get totalFats => _products.map((e) => e.fats).whereNotNull().sum;
  double get totalCarbs => _products.map((e) => e.carbs).whereNotNull().sum;
  double get totalProtein => _products.map((e) => e.protein).whereNotNull().sum;

  Future<void> addProduct(String product) async {
    final existing = _products
        .firstWhereOrNull((p) => p.name.toLowerCase() == product.toLowerCase());

    if (existing != null) {
      existing.grams = existing.grams + 100;
    } else {
      final List<NutritionalValue> values = await getNutritionalValue(product);
      if (values.isNotEmpty) {
        for (final value in values) {
          _products.add(
            Product(
              name: product,
              nutritionalValue: value,
              grams: 100,
            ),
          );
        }
      } else {
        _products.add(
          Product(name: product, nutritionalValue: null, grams: 100),
        );
      }
    }

    notifyListeners();
  }

  void removeProduct(Product product) {
    _products.remove(product);
    notifyListeners();
  }

  Future<List<NutritionalValue>> getNutritionalValue(String product) async {
    final List<NutritionalValue> nutritionalValues = [];
    try {
      var url = Uri.https(
        Constants.url,
        'v1/nutrition',
        {'ingredient': product},
      );
      var response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final re = jsonDecode(response.body) as List<dynamic>;

      for (final item in re) {
        try {
          final NutritionalValue value = NutritionalValue(
              name: item['name'] as String,
              calories: item['calories'],
              fats: item['fat_total_g'],
              carbs: item['carbohydrates_total_g'],
              protein: item['protein_g']);
          nutritionalValues.add(value);
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      print(e);
    }

    return nutritionalValues;
  }

  List<Product> get getProducts => _products;
}
