import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rollin_user/presentation/authentication/login.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
       theme: ThemeData(
        // scaffoldBackgroundColor: AppColours.shineBlack,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'NotoSans'),
          bodyMedium: TextStyle(fontFamily: 'NotoSans'),
          displayLarge: TextStyle(fontFamily: 'NotoSans'),
          displayMedium: TextStyle(fontFamily: 'NotoSans'),
          displaySmall: TextStyle(fontFamily: 'NotoSans'),
          headlineMedium: TextStyle(fontFamily: 'NotoSans'),
          headlineSmall: TextStyle(fontFamily: 'NotoSans'),
          titleLarge: TextStyle(fontFamily: 'NotoSans'),
          titleMedium: TextStyle(fontFamily: 'NotoSans'),
          titleSmall: TextStyle(fontFamily: 'NotoSans'),
          bodySmall: TextStyle(fontFamily: 'NotoSans'),
          labelLarge: TextStyle(fontFamily: 'NotoSans'),
        ),
      ),
      home:  UserLoginScreen(),
    );
  }
}



