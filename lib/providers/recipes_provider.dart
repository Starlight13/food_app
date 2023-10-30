import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_app/app_constants.dart';
import 'package:food_app/providers/products_provider.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class RecipesProvider extends ChangeNotifier {
  final List<Recipe> _recipes = [];

  final ProductsProvider products;

  RecipesProvider({required this.products}) {
    products.addListener(_updateRecipes);
  }

  List<Recipe> get recipes => _recipes;

  Future<void> _updateRecipes() async {
    _recipes.clear();
    _recipes.addAll(await _getRecipes());

    notifyListeners();
  }

  Future<List<Recipe>> _getRecipes() async {
    final List<Recipe> recipes = [];

    final Iterable<String> products =
        this.products.getProducts.map((e) => e.name);

    if (products.isEmpty) return [];

    try {
      var url = Uri.https(
        Constants.url,
        'v1/recipe',
        {'ingredients': products.join(' ')},
      );
      var response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final re = jsonDecode(response.body) as List<dynamic>;

      for (final item in re) {
        try {
          final Recipe recipe = Recipe(
              name: item['title'] as String,
              ingredients: (item['ingredients'] as String).split('|'),
              steps: (item['instructions'] as String).split('. '),
              servings: item['servings']);
          _recipes.add(recipe);
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      print(e);
    }

    return recipes;
  }

  @override
  void dispose() {
    products.removeListener(_updateRecipes);
    super.dispose();
  }
}
