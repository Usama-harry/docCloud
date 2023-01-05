import 'package:flutter/material.dart';
import 'package:get/get.dart';

//Screens
import './home_screen.dart';
import './authentication/auth_screen1.dart';
//Controller
import '../controllers/auth.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1)).then((value) {
      final authController = Get.put(AuthController());
      if (authController.isAuthenticated) {
        Get.toNamed(HomeScreen.routeName);
      } else {
        Get.toNamed(AuthScreen1.routeName);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
