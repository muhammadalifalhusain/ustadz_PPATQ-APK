import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ⛔️ Hanya untuk testing: hapus session biar selalu ke login dulu
  // final prefs = await SharedPreferences.getInstance();
  // await prefs.clear();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PPATQ RAUDLATUL FALAH',
      home: SplashScreen(), 
    );
  }
}
