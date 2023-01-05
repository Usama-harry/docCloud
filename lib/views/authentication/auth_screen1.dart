import 'package:documents/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//controller
import '../../controllers/auth.dart';
//Screens
import './auth_screen2.dart';
import '../splash_screen.dart';
//Widgets
import '../../widgets/my_text_field.dart';

enum AuthMode { login, register, reset }

class AuthScreen1 extends StatefulWidget {
  static const routeName = '/auth1';
  const AuthScreen1({super.key});

  @override
  State<AuthScreen1> createState() => _AuthScreen1State();
}

class _AuthScreen1State extends State<AuthScreen1> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final authController = Get.find<AuthController>();

  var authMode = AuthMode.login;
  var isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Text(
                    isLoginMode
                        ? 'Enter your details'
                        : isRegisterMode
                            ? 'Enter your name'
                            : 'Reset Password',
                    style: titleTextStyle,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isLoginMode
                        ? 'Please enter your details to continue'
                        : isRegisterMode
                            ? 'Please enter your name to get started'
                            : 'Enter your email to send an reset password link',
                    style: descriptionTextStyle,
                  ),
                  const SizedBox(height: 10),
                  if (isRegisterMode)
                    MyTextField(
                      label: 'Name',
                      controller: _nameController,
                      isRequired: true,
                    ),
                  if (!isRegisterMode)
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
                  if (isLoginMode)
                    if (isLoginMode)
                      MyTextField(
                        label: 'Password',
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                        isObsecure: true,
                      ),
                  const SizedBox(height: 10),
                  if (!isRegisterMode) forgetPasswordButton(),
                  const SizedBox(height: 30),
                  elevatedButtonBuilder(),
                  const SizedBox(height: 10),
                  if (!isResetMode)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLoginMode
                              ? 'Don\'t have an account?'
                              : 'Already have an account?',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        InkWell(
                          onTap: () => setAuthMode(
                            authMode == AuthMode.login
                                ? AuthMode.register
                                : AuthMode.login,
                          ),
                          child: Text(
                            isLoginMode ? ' Register' : ' Login',
                            style: TextStyle(
                              color: MyColors.accentColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
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
      if (isRegisterMode) {
        isLoading.value = false;
        Get.toNamed(
          AuthScreen2.routeName,
          arguments: _nameController.text,
        );
      } else if (isLoginMode) {
        login();
      } else {
        authController.resetPassword(_emailController.text).then((value) {
          isLoading.value = false;
          setAuthMode(AuthMode.login);
          showAlertDialog(
            context,
            'Email was sent. Please check your inbox(inlcuding junk) to reset your password',
            isError: false,
          );
        }).catchError((error) {
          isLoading.value = false;
          showAlertDialog(context, error.toString());
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InkWell forgetPasswordButton() {
    return InkWell(
      onTap: () => setAuthMode(
        authMode == AuthMode.login ? AuthMode.reset : AuthMode.login,
      ),
      child: Text(
        isLoginMode ? 'Forget password?' : 'Login?',
        style: const TextStyle(
          color: Colors.grey,
        ),
      ),
    );
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
              child: Text(isLoginMode
                  ? 'Login'
                  : isRegisterMode
                      ? 'Continue'
                      : 'Reset'),
            ),
    );
  }

  void login() {
    authController
        .signIn(_emailController.text, _passwordController.text)
        .then((isSignedIn) {
      isLoading.value = false;
      if (isSignedIn) {
        Get.offAllNamed(SplashScreen.routeName);
      } else {
        showAlertDialog(context, 'There was problem signing you in');
      }
    }).catchError((error) {
      isLoading.value = false;
      showAlertDialog(context, error.toString());
    });
  }

  void setAuthMode(newMode) {
    setState(() {
      authMode = newMode;
    });
  }

  bool get isLoginMode {
    return authMode == AuthMode.login;
  }

  bool get isRegisterMode {
    return authMode == AuthMode.register;
  }

  bool get isResetMode {
    return authMode == AuthMode.reset;
  }
}
