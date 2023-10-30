import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:food_app/providers/products_provider.dart';
import 'package:food_app/providers/recipes_provider.dart';
import 'package:provider/provider.dart';
import 'home.dart';

late List<CameraDescription> cameras;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }

  final products = ProductsProvider();
  final recipes = RecipesProvider(products: products);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductsProvider>.value(value: products),
        ChangeNotifierProvider<RecipesProvider>.value(value: recipes),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tflite real-time detection',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: HomePage(cameras),
    );
  }
}
