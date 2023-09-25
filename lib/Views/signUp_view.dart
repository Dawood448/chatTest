import 'package:chat_test/Views/home_screen.dart';
import 'package:chat_test/Views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Auth/auth_controller.dart';
import '../Utils/image_picker.dart';
import '../Utils/lottie_animation.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
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
        title: const Text("SignUp Screen"),
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
                      const MyImagePicker(),
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
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: "Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an email address.';
                          }
                          if (!isEmailValid(value)) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
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
                        controller: passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Field cannot be empty';
                          }
                          return null;
                        },
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
                            String? dpLink =
                                await MyImagePickerState.uploadImage();
                            if (dpLink!.isEmpty) {
                              setState(() {
                                isLoading = false;
                              });
                                ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: Colors.greenAccent.shade400,
                                  content: const Text(
                                      "Image not set"),
                                ),
                              );
                            }
                            try {
                              await authController.register(
                                emailController.text,
                                passwordController.text,
                                nameController.text,
                                dpLink,
                              );
                              setState(() {
                                isLoading = false;
                              });
                              Get.off(() => const HomeScreen());
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: Colors.greenAccent.shade400,
                                  content: const Text(
                                      "Account is created successfully"),
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
                                  content: Text("Registration failed: $e"),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text("Register"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        onPressed: () {
                          Get.off(() => const LoginScreen());
                        },
                        child: const Text("Login .. ?"),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
