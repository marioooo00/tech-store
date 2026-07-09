import 'dart:async';

import 'package:flutter/material.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {

  String fullText =
      "Welcome";

  String displayedText = "";

  double progress = 0;

  @override
  void initState() {

    super.initState();

    startLoading();
  }

  // =========================
  // TYPING EFFECT
  // =========================
  void startLoading() {

    int index = 0;

    Timer.periodic(

      const Duration(
        milliseconds: 250,
      ),

      (timer) {

        if (index <
            fullText.length) {

          setState(() {

            displayedText +=
                fullText[index];

            progress =
                (index + 1) /
                fullText.length;
          });

          index++;

        } else {

          timer.cancel();

          Future.delayed(

            const Duration(
              seconds: 1,
            ),

            () {

              if (!mounted) {
                return;
              }

              Navigator.pushReplacement(

                context,

                MaterialPageRoute(

                  builder:
                      (context) =>
                          const LoginScreen(),
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Stack(

        children: [

          // =========================
          // BACKGROUND IMAGE
          // =========================
          SizedBox.expand(

            child: Image.asset(

              "assets/images/bg.jpg",

              fit: BoxFit.cover,
            ),
          ),

          // =========================
          // DARK OVERLAY
          // =========================
          Container(

            color:
                Colors.black
                    .withValues(
              alpha: 0.78,
            ),
          ),

          // =========================
          // CONTENT
          // =========================
          Center(

            child:
                Column(

              mainAxisSize:
                  MainAxisSize.min,

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
                // TYPING TEXT
                // =========================
                Text(

                  displayedText,

                  style: const TextStyle(

                    color:
                        Colors.cyanAccent,

                    fontSize: 32,

                    fontWeight:
                        FontWeight.bold,

                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),

                // =========================
                // PROGRESS BAR
                // =========================
                Container(

                  width: 220,

                  height: 8,

                  decoration:
                      BoxDecoration(

                    color:
                        Colors.white12,

                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),

                  child: Align(

                    alignment:
                        Alignment.centerLeft,

                    child:
                        AnimatedContainer(

                      duration:
                          const Duration(
                        milliseconds: 200,
                      ),

                      width:
                          220 * progress,

                      decoration:
                          BoxDecoration(

                        color:
                            Colors.cyanAccent,

                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),

                        boxShadow: [

                          BoxShadow(

                            color:
                                Colors.cyanAccent
                                    .withValues(
                              alpha: 0.5,
                            ),

                            blurRadius: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}