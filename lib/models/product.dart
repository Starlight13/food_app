import 'package:food_app/models/nutritional_value.dart';

class Product {
  final String name;
  NutritionalValue? nutritionalValue;
  double grams;

  double? get calories => nutritionalValue?.calories == null
      ? null
      : nutritionalValue!.calories! * grams / 100;

  double? get fats => nutritionalValue?.fats == null
      ? null
      : nutritionalValue!.fats! * grams / 100;

  double? get carbs => nutritionalValue?.carbs == null
      ? null
      : nutritionalValue!.carbs! * grams / 100;

  double? get protein => nutritionalValue?.protein == null
      ? null
      : nutritionalValue!.protein! * grams / 100;

  Product({
    required this.name,
    required this.nutritionalValue,
    required this.grams,
  });
}
