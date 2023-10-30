import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:food_app/bounding_box.dart';
import 'package:food_app/camera.dart';
import 'dart:math' as math;

import 'package:food_app/providers/products_provider.dart';
import 'package:food_app/providers/recipes_provider.dart';
import 'package:food_app/widgets/product_card.dart';
import 'package:food_app/widgets/recipe_card.dart';
import 'package:provider/provider.dart';
import 'package:tflite/tflite.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const HomePage(this.cameras, {super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<dynamic> _recognitions = [];
  int _imageHeight = 0;
  int _imageWidth = 0;

  bool isCameraOn = false;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  loadModel() async {
    String? res;

    res = await Tflite.loadModel(
      model: "assets/yolov2_tiny.tflite",
      labels: "assets/yolov2_tiny.txt",
    );

    print(res);
  }

  setRecognitions(recognitions, int imageHeight, int imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = context.watch<ProductsProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      bottomNavigationBar: Container(
        color: theme.colorScheme.surface,
        padding: EdgeInsets.fromLTRB(
            16, 8, 16, MediaQuery.of(context).padding.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Total', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              spacing: 10,
              children: [
                Text(
                    'Calories: ${productsProvider.totalCalories.toStringAsFixed(1)}'),
                Text('Fats: ${productsProvider.totalFats.toStringAsFixed(1)}'),
                Text(
                    'Carbs: ${productsProvider.totalCarbs.toStringAsFixed(1)}'),
                Text(
                    'Protein: ${productsProvider.totalProtein.toStringAsFixed(1)}'),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isCameraOn = !isCameraOn;
          });
        },
        child: Icon(!isCameraOn ? Icons.add : Icons.chevron_left),
      ),
      body: SafeArea(
        child: !isCameraOn
            ? const MainMenu()
            : Stack(
                children: [
                  Camera(
                    widget.cameras,
                    setRecognitions,
                  ),
                  LayoutBuilder(builder: (context, constraints) {
                    return BoundingBox(
                      _recognitions,
                      math.max(_imageHeight, _imageWidth),
                      math.min(_imageHeight, _imageWidth),
                      constraints.maxHeight,
                      constraints.maxWidth,
                    );
                  }),
                  const Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child:
                          Center(child: Text('Tap on the product to add it'))),
                ],
              ),
      ),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductsProvider productsProvider = context.watch<ProductsProvider>();
    final allProducts = productsProvider.getProducts;

    final recipesProvider = context.watch<RecipesProvider>();
    final allRecipes = recipesProvider.recipes;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: allProducts.length,
              itemBuilder: (context, index) {
                final product = allProducts[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ProductCard(product: product),
                );
              },
            ),
          ),
          Text(
            'Suggested recipes',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(
            height: 200,
            child: PageView.builder(
              itemCount: allRecipes.length,
              itemBuilder: (context, index) {
                final recipe = allRecipes[index];

                return RecipeCard(recipe: recipe);
              },
            ),
          ),
        ],
      ),
    );
  }
}
