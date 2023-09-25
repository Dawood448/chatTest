import 'package:chat_test/Auth/auth_controller.dart';
import 'package:chat_test/Views/home_screen.dart';
import 'package:chat_test/Views/signUp_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/lottie_animation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final authController = Get.put(AuthController());
  bool isLoading = false;
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  isEmailValid(String email) {
    // Regular expression for a valid email format
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
    );
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: isLoading
            ? const Center(
                child: Loading(),
              )
            : Form(
                key: key,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        child: const LoadingHome(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an email address.';
                          }
                          if (!isEmailValid(value)) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Field cannot be empty';
                          }
                          return null;
                        },
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (key.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              await authController.login(
                                  email: emailController.text,
                                  password: passwordController.text);
                              Get.off(() => const HomeScreen());
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: Colors.greenAccent.shade400,
                                  content: const Text("Login Successful"),
                                ),
                              );
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 3),
                                  showCloseIcon: true,
                                  backgroundColor: Colors.red.shade400,
                                  content: Text("Failed: $e"),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          "Login",
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        onPressed: () {
                          Get.off(() => const SignUpScreen());
                        },
                        child: const Text("Register .. ?"),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
