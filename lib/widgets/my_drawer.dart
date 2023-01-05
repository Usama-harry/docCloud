import 'package:flutter/material.dart';
import 'package:get/get.dart';

//Controller
import '../controllers/auth.dart';
//SCreens
import '../views/splash_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.8,
      child: Drawer(
        child: Column(
          children: [
            SizedBox(
              height: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top,
            ),
            const Spacer(),
            drawerItemBuilder(
              Icons.logout,
              'Logout',
              'End current session',
              () {
                authController.signOut();
                Get.offAllNamed(SplashScreen.routeName);
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  ListTile drawerItemBuilder(
    IconData icon,
    String title,
    String subTitle,
    Function() onPressed,
  ) {
    return ListTile(
      onTap: onPressed,
      leading: const Icon(
        Icons.logout,
        size: 35,
      ),
      title: Text(title),
      subtitle: Text(subTitle),
    );
  }
}
