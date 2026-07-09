import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'sign_up.dart';
import 'home_screen.dart';

class LoginScreen
    extends StatefulWidget {

  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {

    emailController.dispose();

    passwordController.dispose();

    super.dispose();
  }

  // =========================
  // LOGIN
  // =========================
  Future<void> login() async {

    setState(() {
      isLoading = true;
    });

    try {

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(

        email:
            emailController.text.trim(),

        password:
            passwordController.text.trim(),
      );

      if (!mounted) {
        return;
      }

      // =========================
      // SUCCESS MESSAGE
      // =========================
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        const SnackBar(

          backgroundColor:
              Colors.green,

          content: Text(

            "Login Successful ✅",

            style: TextStyle(

              color:
                  Colors.white,

              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ),
      );

      await Future.delayed(

        const Duration(
          seconds: 2,
        ),
      );

      if (!mounted) {
        return;
      }

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder:
              (context) =>
                  const HomeScreen(),
        ),
      );

    } on FirebaseAuthException {

      if (!mounted) {
        return;
      }

      // =========================
      // ERROR MESSAGE
      // =========================
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        const SnackBar(

          backgroundColor:
              Colors.redAccent,

          content: Text(

            "Failed Login ❌",

            style: TextStyle(

              color:
                  Colors.white,

              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      resizeToAvoidBottomInset:
          true,

      body: Stack(

        children: [

          // =========================
          // BACKGROUND
          // =========================
          SizedBox.expand(

            child: Image.asset(

              'assets/images/bg.jpg',

              fit: BoxFit.cover,
            ),
          ),

          // =========================
          // OVERLAY
          // =========================
          Container(

            color:
                Colors.black
                    .withValues(
              alpha: 0.55,
            ),
          ),

          // =========================
          // CONTENT
          // =========================
          SafeArea(

            child: Center(

              child:
                  SingleChildScrollView(

                child: Padding(

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),

                  child: Column(

                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,

                    children: [

                      // =========================
                      // LOGO
                      // =========================
                      Image.asset(

                        'assets/images/Logo.png',

                        width: 150,
                      ),

                      const SizedBox(
                        height: 35,
                      ),

                      // =========================
                      // CARD
                      // =========================
                      Container(

                        padding:
                            const EdgeInsets.all(
                          22,
                        ),

                        decoration:
                            BoxDecoration(

                          color:
                              const Color.fromARGB(
                            110,
                            0,
                            80,
                            90,
                          ),

                          borderRadius:
                              BorderRadius.circular(
                            28,
                          ),

                          border:
                              Border.all(

                            color:
                                Colors.cyanAccent
                                    .withValues(
                              alpha: 0.35,
                            ),
                          ),

                          boxShadow: [

                            BoxShadow(

                              color:
                                  Colors.cyan
                                      .withValues(
                                alpha: 0.18,
                              ),

                              blurRadius: 25,
                            ),
                          ],
                        ),

                        child: Column(

                          children: [

                            const Text(

                              "Log In",

                              style: TextStyle(

                                fontSize: 30,

                                color:
                                    Colors.white,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            Text(

                              "Welcome Back",

                              style: TextStyle(

                                color:
                                    Colors.white
                                        .withValues(
                                  alpha: 0.7,
                                ),

                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(
                              height: 30,
                            ),

                            // =========================
                            // EMAIL
                            // =========================
                            _buildField(

                              Icons.email_rounded,

                              "Enter Your Email",

                              controller:
                                  emailController,
                            ),

                            const SizedBox(
                              height: 18,
                            ),

                            // =========================
                            // PASSWORD
                            // =========================
                            _buildField(

                              Icons.lock_rounded,

                              "Enter Password",

                              obscure: true,

                              controller:
                                  passwordController,
                            ),

                            const SizedBox(
                              height: 30,
                            ),

                            // =========================
                            // LOGIN BUTTON
                            // =========================
                            SizedBox(

                              width:
                                  double.infinity,

                              height: 60,

                              child:
                                  ElevatedButton(

                                onPressed:
                                    isLoading
                                        ? null
                                        : login,

                                style:
                                    ElevatedButton.styleFrom(

                                  backgroundColor:
                                      Colors.transparent,

                                  shadowColor:
                                      Colors.transparent,

                                  elevation: 0,

                                  padding:
                                      EdgeInsets.zero,

                                  shape:
                                      RoundedRectangleBorder(

                                    borderRadius:
                                        BorderRadius.circular(
                                      20,
                                    ),
                                  ),
                                ),

                                child:
                                    Container(

                                  decoration:
                                      BoxDecoration(

                                    borderRadius:
                                        BorderRadius.circular(
                                      20,
                                    ),

                                    border:
                                        Border.all(

                                      color:
                                          Colors.cyanAccent,

                                      width: 1.5,
                                    ),

                                    color:
                                        Colors.transparent,

                                    boxShadow: [

                                      BoxShadow(

                                        color:
                                            Colors.cyanAccent
                                                .withValues(
                                          alpha: 0.15,
                                        ),

                                        blurRadius:
                                            18,
                                      ),
                                    ],
                                  ),

                                  child: Center(

                                    child:
                                        isLoading
                                            ? const CircularProgressIndicator(
                                                color:
                                                    Colors.cyanAccent,
                                              )
                                            : const Text(

                                                "Log In",

                                                style:
                                                    TextStyle(

                                                  color:
                                                      Colors.cyanAccent,

                                                  fontSize:
                                                      22,

                                                  fontWeight:
                                                      FontWeight.bold,
                                                ),
                                              ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 22,
                            ),

                            // =========================
                            // SIGN UP
                            // =========================
                            GestureDetector(

                              onTap: () {

                                Navigator.push(

                                  context,

                                  MaterialPageRoute(

                                    builder:
                                        (
                                          context,
                                        ) =>
                                            const SignUpScreen(),
                                  ),
                                );
                              },

                              child:
                                  const Text.rich(

                                TextSpan(

                                  text:
                                      "Dont Have Account ? ",

                                  style: TextStyle(

                                    color:
                                        Colors.white70,
                                  ),

                                  children: [

                                    TextSpan(

                                      text:
                                          "Sign Up",

                                      style:
                                          TextStyle(

                                        color:
                                            Colors.cyanAccent,

                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // TEXT FIELD
  // =========================
  Widget _buildField(

    IconData icon,

    String hint, {

    bool obscure = false,

    required TextEditingController
        controller,
  }) {

    return TextField(

      controller:
          controller,

      obscureText:
          obscure,

      style:
          const TextStyle(

        color: Colors.white,
      ),

      decoration:
          InputDecoration(

        prefixIcon:
            Icon(

          icon,

          color:
              Colors.cyanAccent,
        ),

        hintText:
            hint,

        hintStyle:
            const TextStyle(

          color:
              Colors.white70,
        ),

        filled: true,

        fillColor:
            Colors.black
                .withValues(
          alpha: 0.2,
        ),

        enabledBorder:
            OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(
            15,
          ),

          borderSide:
              BorderSide(

            color:
                Colors.cyanAccent
                    .withValues(
              alpha: 0.4,
            ),
          ),
        ),

        focusedBorder:
            OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(
            15,
          ),

          borderSide:
              const BorderSide(

            color:
                Colors.cyanAccent,

            width: 2,
          ),
        ),
      ),
    );
  }
}