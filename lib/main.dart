import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:rollin_user/constants.dart';
import 'package:rollin_user/presentation/splash_screen/splash_screen.dart';


void main() async {

 _setUp();
 await Firebase.initializeApp();

  runApp(const MyApp());
}
Future<void> _setUp ()async{
  
  WidgetsFlutterBinding.ensureInitialized();
  
  Stripe.publishableKey = stripePublishableKey;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
       theme: ThemeData(
        
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
      home:  SplashScreen(),
    );
  }
}
