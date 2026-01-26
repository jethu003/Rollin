import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rollin_user/presentation/authentication/login.dart';
import 'package:rollin_user/presentation/resourses/app_colours.dart';
import 'package:rollin_user/presentation/screens/bottom_navigator/bottom_navigator.dart';
import 'package:rollin_user/presentation/widgets/custom_shimmer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Color primaryColor =
      Color.fromARGB(255, 184, 134, 11); // Gold

  static const Duration _shimmerDuration = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _navigateAfterShimmer();
  }

  Future<void> _navigateAfterShimmer() async {
    
    await Future.delayed(_shimmerDuration);

    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => const BottomNavigator(),
    ),
  );
} else {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) =>  UserLoginScreen(),
    ),
  );
}

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 245, 232, 196),
              primaryColor,
              Color.fromARGB(255, 120, 88, 8),
            ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: Center(
          child: CustomShimmer(
            duration: _shimmerDuration,
            baseColor: AppColours.shineBlack,
            highlightColor: AppColours.shineWhite,
            child: const _Logo(),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logos.png',
      width: 230,
      height: 180,
    );
  }
}
