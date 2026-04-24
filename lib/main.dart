import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/loading_screen.dart';
import 'firebase_options.dart';

/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // ESSA LINHA É VITAL PARA WEB
  );
  runApp(EcoBotApp());
}
*/


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializa o Firebase
  runApp(EcoBotApp());
}

class EcoBotApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eco-Bot',
      home: LoadingScreen(),
    );
  }
}