import 'package:flutter/material.dart';
import 'package:get/get.dart';

//Screens
import '../splash_screen.dart';
//state
import '../../controllers/auth.dart';
//Widgets
import '../../widgets/my_text_field.dart';
//Utils
import '../../Utils/utils.dart';

class AuthScreen2 extends StatefulWidget {
  static const routeName = '/auth2';
  const AuthScreen2({super.key});

  @override
  State<AuthScreen2> createState() => _AuthScreen2State();
}

class _AuthScreen2State extends State<AuthScreen2> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final auth = Get.find<AuthController>();
  final name = Get.arguments;

  var isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.backGroundColor,
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.privacy_tip,
                    color: Colors.green,
                    size: 120,
                  ),
                  const SizedBox(height: 70),
                  const Text(
                    'Enter your details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please enter your details to continue',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    label: 'Email',
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    label: 'Password',
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      if (value.length < 8) {
                        return 'Password must contain 8 characters';
                      }
                      return null;
                    },
                    isObsecure: true,
                  ),
                  MyTextField(
                    label: 'Confirm Password',
                    controller: _confirmPasswordController,
                    isObsecure: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      if (value != _passwordController.text) {
                        return 'Password do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  elevatedButtonBuilder(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void validate() {
    if (_formKey.currentState!.validate()) {
      isLoading.value = true;

      auth
          .signUp(name, _emailController.text, _passwordController.text)
          .then((isSignedUp) {
        isLoading.value = false;
        if (isSignedUp) {
          Get.toNamed(SplashScreen.routeName);
        } else {
          showAlertDialog(context, 'There was problem signing up');
        }
      }).catchError((error) {
        isLoading.value = false;
        showAlertDialog(context, error.toString());
      });
    }
  }

  Widget elevatedButtonBuilder() {
    return Obx(
      () => isLoading.value
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : ElevatedButton(
              onPressed: validate,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  MyColors.accentColor,
                ),
              ),
              child: const Text('Register'),
            ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
