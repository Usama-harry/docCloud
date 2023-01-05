import 'package:flutter/material.dart';
import 'package:get/get.dart';

//Screens
import './home_screen.dart';
import './authentication/auth_screen1.dart';
//Controller
import '../controllers/auth.dart';
import '../controllers/data.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var isLoading = false;

  @override
  void initState() {
    switchLoadingState();
    Future.delayed(const Duration(milliseconds: 1)).then((value) {
      final authController = Get.put(AuthController());
      final dataController = Get.put(DataController());
      if (authController.isAuthenticated) {
        //Authenticated
        dataController.loadCategories().then((isLoaded) {
          //Loading user data
          switchLoadingState();
          if (isLoaded) {
            Get.toNamed(HomeScreen.routeName);
          } else {
            Get.offAllNamed(SplashScreen.routeName);
          }
        });
      } else {
        switchLoadingState();
        Get.offNamed(AuthScreen1.routeName);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : null,
    );
  }

  void switchLoadingState() {
    setState(() {
      isLoading = !isLoading;
    });
  }
}
