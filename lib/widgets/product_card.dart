import 'package:flutter/material.dart';
import 'package:food_app/models/product.dart';
import 'package:food_app/providers/products_provider.dart';
import 'package:food_app/string_extension.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Material(
      elevation: 4,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: theme.cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  product.name.capitalize,
                  style: textTheme.headlineMedium,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    context.read<ProductsProvider>().removeProduct(product);
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Quantity: ${product.grams.toStringAsFixed(1)}g",
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                "Calories: ${product.calories?.toStringAsFixed(1)}",
                style: textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      "Fats",
                      style: textTheme.labelLarge,
                    ),
                    Text(
                      "${product.fats?.toStringAsFixed(1)}",
                      style: textTheme.headlineMedium,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Carbs",
                      style: textTheme.labelLarge,
                    ),
                    Text(
                      "${product.carbs?.toStringAsFixed(1)}",
                      style: textTheme.headlineMedium,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Protein",
                      style: textTheme.labelLarge,
                    ),
                    Text(
                      "${product.protein?.toStringAsFixed(1)}",
                      style: textTheme.headlineMedium,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
