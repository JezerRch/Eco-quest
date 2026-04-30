import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const EcoBotApp());
}

class EcoBotApp extends StatelessWidget {
  const EcoBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eco-Bot',
      home: LoadingScreen(),
    );
  }
}
