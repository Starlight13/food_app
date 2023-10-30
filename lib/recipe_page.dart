import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:food_app/models/recipe.dart';
import 'package:food_app/string_extension.dart';

class RecipePage extends StatefulWidget {
  final Recipe recipe;

  const RecipePage({super.key, required this.recipe});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  Map<String, bool> ingredientAvailability = {};
  bool isIngredientsCollapsed = true;
  bool isStepsCollapsed = false;

  @override
  void initState() {
    super.initState();
    for (final ingredient in widget.recipe.ingredients) {
      ingredientAvailability[ingredient] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.recipe.name.capitalize),
        ),
        body: ListView(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Recipe for ${widget.recipe.servings.capitalize}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Ingredients",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: IconButton(
                        key: ValueKey(isIngredientsCollapsed),
                        onPressed: () {
                          setState(() {
                            isIngredientsCollapsed = !isIngredientsCollapsed;
                          });
                        },
                        icon: Icon(isIngredientsCollapsed
                            ? Icons.arrow_drop_down
                            : Icons.arrow_drop_up),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              alignment: Alignment.topCenter,
              duration: const Duration(milliseconds: 500),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: isIngredientsCollapsed
                    ? const SizedBox()
                    : Column(
                        children: ingredientAvailability.entries.map((e) {
                          return CheckboxListTile(
                            title: Text(e.key.capitalize),
                            value: e.value,
                            onChanged: (value) {
                              setState(() {
                                ingredientAvailability[e.key] = value!;
                              });
                            },
                          );
                        }).toList(),
                      ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Steps",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: IconButton(
                        key: ValueKey(isStepsCollapsed),
                        onPressed: () {
                          setState(() {
                            isStepsCollapsed = !isStepsCollapsed;
                          });
                        },
                        icon: Icon(isStepsCollapsed
                            ? Icons.arrow_drop_down
                            : Icons.arrow_drop_up),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              alignment: Alignment.topCenter,
              duration: const Duration(milliseconds: 500),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: isStepsCollapsed
                    ? const SizedBox()
                    : Column(
                        children: widget.recipe.steps.mapIndexed((index, e) {
                          return ListTile(
                            leading: Text('$index'),
                            title: Text(e.capitalize),
                          );
                        }).toList(),
                      ),
              ),
            ),
          ],
        ));
  }
}
