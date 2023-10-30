import 'package:flutter/material.dart';
import 'package:food_app/models/recipe.dart';
import 'package:food_app/recipe_page.dart';
import 'package:food_app/string_extension.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 4,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RecipePage(recipe: recipe),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: theme.cardColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.name.capitalize,
                  style: textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 0,
                  children: [
                    for (final ingredient in recipe.ingredients.take(2))
                      Chip(
                        label: Text(ingredient.capitalize),
                      ),
                    if (recipe.ingredients.length > 2)
                      const Chip(
                        label: Text("..."),
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
