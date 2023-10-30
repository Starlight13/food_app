/// A class that represents a product's nutritional value.
/// It contains the product's name, calories, fats, carbs and protein.
///
/// The values are in 100g of the product.
class NutritionalValue {
  final String name;
  final double? calories;
  final double? fats;
  final double? carbs;
  final double? protein;

  NutritionalValue({
    required this.name,
    required this.calories,
    required this.fats,
    required this.carbs,
    required this.protein,
  });
}
