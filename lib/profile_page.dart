// profile_page.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() =>
      _ProfilePageState();
}

class _ProfilePageState
    extends State<ProfilePage> {

  final user =
      FirebaseAuth.instance.currentUser;

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  bool isLoading = false;

  // =========================
  // CONTROLLERS
  // =========================
  final nameController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  final birthController =
      TextEditingController();

  final addressController =
      TextEditingController();

  // =========================
  // INIT
  // =========================
  @override
  void initState() {

    super.initState();

    loadUserData();
  }

  // =========================
  // LOAD USER DATA
  // =========================
  Future<void> loadUserData() async {

    if (user == null) {
      return;
    }

    var doc = await firestore
        .collection("users")
        .doc(user!.uid)
        .get();

    if (doc.exists) {

      var data = doc.data()!;

      nameController.text =
          data['name'] ?? "";

      emailController.text =
          data['email'] ?? "";

      phoneController.text =
          data['phone'] ?? "";

      birthController.text =
          data['birth'] ?? "";

      addressController.text =
          data['address'] ?? "";

      setState(() {});
    }
  }

  // =========================
  // SAVE PROFILE
  // =========================
  Future<void> saveProfile() async {

    if (user == null) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      await firestore
          .collection("users")
          .doc(user!.uid)
          .set({

        "name":
            nameController.text,

        "email":
            emailController.text,

        "phone":
            phoneController.text,

        "birth":
            birthController.text,

        "address":
            addressController.text,

        "uid":
            user!.uid,
      });

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        const SnackBar(

          backgroundColor:
              Colors.cyan,

          content: Text(

            "Profile Updated 🔥",

            style: TextStyle(

              color: Colors.black,

              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  // =========================
  // LOGOUT
  // =========================
  Future<void> logout() async {

    await FirebaseAuth.instance
        .signOut();

    if (!mounted) {
      return;
    }

    Navigator.pushNamedAndRemoveUntil(

      context,

      '/login',

      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Container(

      color: const Color(
        0xff081420,
      ),

      child: SafeArea(

        child:
            SingleChildScrollView(

          physics:
              const BouncingScrollPhysics(),

          child: Column(
            children: [

              Container(

                width:
                    double.infinity,

                padding:
                    const EdgeInsets.symmetric(

                  horizontal: 20,

                  vertical: 20,
                ),

                decoration:
                    const BoxDecoration(

                  image:
                      DecorationImage(

                    image: AssetImage(
                      "assets/images/bg.jpg",
                    ),

                    fit:
                        BoxFit.cover,

                    opacity: 0.18,
                  ),
                ),

                child: Column(
                  children: [

                    // =========================
                    // TOP BAR
                    // =========================
                    Row(

                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [

                        Image.asset(
                          "assets/images/Logo.png",
                          width: 75,
                        ),

                        GestureDetector(

                          onTap: logout,

                          child: Container(

                            padding:
                                const EdgeInsets.symmetric(

                              horizontal: 14,

                              vertical: 10,
                            ),

                            decoration:
                                BoxDecoration(

                              borderRadius:
                                  BorderRadius.circular(
                                16,
                              ),

                              border:
                                  Border.all(
                                color:
                                    Colors.redAccent,
                              ),

                              color:
                                  Colors.redAccent
                                      .withValues(
                                alpha: 0.1,
                              ),
                            ),

                            child: const Row(
                              children: [

                                Icon(
                                  Icons.logout_rounded,
                                  color:
                                      Colors.redAccent,
                                  size: 18,
                                ),

                                SizedBox(
                                  width: 6,
                                ),

                                Text(
                                  "Logout",
                                  style: TextStyle(
                                    color:
                                        Colors.redAccent,
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

                    const SizedBox(
                      height: 30,
                    ),

                    // =========================
                    // PROFILE ICON
                    // =========================
                    Container(

                      height: 125,

                      width: 125,

                      decoration:
                          BoxDecoration(

                        shape:
                            BoxShape.circle,

                        gradient:
                            LinearGradient(

                          colors: [

                            Colors.cyan
                                .withValues(
                              alpha: 0.15,
                            ),

                            Colors.black
                                .withValues(
                              alpha: 0.3,
                            ),
                          ],

                          begin:
                              Alignment.topLeft,

                          end:
                              Alignment.bottomRight,
                        ),

                        border:
                            Border.all(

                          color:
                              Colors.cyanAccent,

                          width: 3,
                        ),

                        boxShadow: [

                          BoxShadow(

                            color:
                                Colors.cyan
                                    .withValues(
                              alpha: 0.35,
                            ),

                            blurRadius: 25,
                          ),
                        ],
                      ),

                      child: const Icon(

                        Icons.person_rounded,

                        size: 75,

                        color:
                            Colors.cyanAccent,
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Text(

                      nameController
                              .text
                              .isEmpty
                          ? "Your Name"
                          : nameController
                              .text,

                      style:
                          const TextStyle(

                        color:
                            Colors.cyanAccent,

                        fontSize: 28,

                        fontWeight:
                            FontWeight.bold,

                        letterSpacing:
                            1,
                      ),
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    Text(

                      emailController
                              .text
                              .isEmpty
                          ? "example@gmail.com"
                          : emailController
                              .text,

                      style:
                          TextStyle(

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
                    // FORM
                    // =========================
                    Container(

                      padding:
                          const EdgeInsets.all(
                        22,
                      ),

                      decoration:
                          BoxDecoration(

                        gradient:
                            LinearGradient(

                          colors: [

                            Colors.black
                                .withValues(
                              alpha: 0.25,
                            ),

                            Colors.cyan
                                .withValues(
                              alpha: 0.08,
                            ),
                          ],

                          begin:
                              Alignment.topLeft,

                          end:
                              Alignment.bottomRight,
                        ),

                        borderRadius:
                            BorderRadius.circular(
                          32,
                        ),

                        border:
                            Border.all(

                          color:
                              Colors.cyanAccent
                                  .withValues(
                            alpha: 0.7,
                          ),

                          width: 1.3,
                        ),

                        boxShadow: [

                          BoxShadow(

                            color:
                                Colors.cyan
                                    .withValues(
                              alpha: 0.12,
                            ),

                            blurRadius: 25,

                            spreadRadius: 1,
                          ),
                        ],
                      ),

                      child: Column(

                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          const Row(
                            children: [

                              Icon(
                                Icons.person,
                                color:
                                    Colors.cyanAccent,
                              ),

                              SizedBox(
                                width: 10,
                              ),

                              Text(
                                "My Profile",
                                style:
                                    TextStyle(

                                  color:
                                      Colors.white,

                                  fontSize: 24,

                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 22,
                          ),

                          buildField(

                            controller:
                                nameController,

                            title:
                                "Full Name",

                            hint:
                                "Full Name",

                            icon: Icons
                                .person_outline,
                          ),

                          buildField(

                            controller:
                                emailController,

                            title:
                                "Email",

                            hint:
                                "Your Email",

                            icon: Icons
                                .email_outlined,
                          ),

                          buildField(

                            controller:
                                phoneController,

                            title:
                                "Phone",

                            hint:
                                "Your Phone Number",

                            icon: Icons
                                .call_outlined,
                          ),

                          buildField(

                            controller:
                                birthController,

                            title:
                                "Date Of Birth",

                            hint:
                                "Day / Month / Year",

                            icon: Icons
                                .calendar_month_outlined,
                          ),

                          buildField(

                            controller:
                                addressController,

                            title:
                                "Address",

                            hint:
                                "Your Address",

                            icon: Icons
                                .location_on_outlined,

                            // maxLines: 3,
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // =========================
                          // SAVE BUTTON
                          // =========================
                          SizedBox(

                            width: double.infinity,

                            height: 55,

                            child: ElevatedButton(

                              onPressed:
                                  isLoading
                                      ? null
                                      : saveProfile,

                              style:
                                  ElevatedButton.styleFrom(

                                elevation: 0,

                                backgroundColor:
                                    Colors.transparent,

                                shadowColor:
                                    Colors.transparent,

                                padding:
                                    EdgeInsets.zero,

                                shape:
                                    RoundedRectangleBorder(

                                  borderRadius:
                                      BorderRadius.circular(
                                    18,
                                  ),
                                ),
                              ),

                              child: Ink(

                                decoration:
                                    BoxDecoration(

                                  borderRadius:
                                      BorderRadius.circular(
                                    18,
                                  ),

                                  gradient:
                                      const LinearGradient(

                                    colors: [

                                      Color(0xff00E5FF),

                                      Color(0xff3B82F6),
                                    ],

                                    begin:
                                        Alignment.centerLeft,

                                    end:
                                        Alignment.centerRight,
                                  ),

                                  boxShadow: [

                                    BoxShadow(

                                      color:
                                          Colors.cyan
                                              .withValues(
                                        alpha: 0.35,
                                      ),

                                      blurRadius: 20,

                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),

                                child: Container(

                                  alignment:
                                      Alignment.center,

                                  child:
                                      isLoading
                                          ? const CircularProgressIndicator(
                                              color:
                                                  Colors.white,
                                            )
                                          : const Row(

                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,

                                              children: [

                                                Icon(
                                                  Icons.save_rounded,
                                                  color:
                                                      Colors.white,
                                                  size: 20,
                                                ),

                                                SizedBox(
                                                  width: 10,
                                                ),

                                                Text(

                                                  "Save Changes",

                                                  style:
                                                      TextStyle(

                                                    color:
                                                        Colors.white,

                                                    fontSize:
                                                        17,

                                                    fontWeight:
                                                        FontWeight.bold,

                                                    letterSpacing:
                                                        0.8,
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
                    ),

                    const SizedBox(
                      height: 120,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // FIELD
  // =========================
  Widget buildField({

    required TextEditingController
        controller,

    required String title,

    required String hint,

    required IconData icon,

    int maxLines = 1,
  }) {

    return Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Text(

          title,

          style: const TextStyle(

            color: Colors.white,

            fontSize: 14,

            fontWeight:
                FontWeight.w500,
          ),
        ),

        const SizedBox(
          height: 8,
        ),

        SizedBox(

          height:
              maxLines == 1
                  ? 58
                  : 110,

          child: TextField(

            controller:
                controller,

            maxLines:
                maxLines,

            style:
                const TextStyle(

              color: Colors.white,

              fontSize: 14,
            ),

            decoration:
                InputDecoration(

              hintText:
                  hint,

              hintStyle:
                  const TextStyle(

                color:
                    Colors.white54,

                fontSize:
                    13,
              ),

              prefixIcon:
                  Icon(

                icon,

                color:
                    Colors.cyanAccent,

                size: 21,
              ),

              filled: true,

              fillColor:
                  Colors.black
                      .withValues(
                alpha: 0.35,
              ),

              enabledBorder:
                  OutlineInputBorder(

                borderRadius:
                    BorderRadius.circular(
                  16,
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
                  16,
                ),

                borderSide:
                    const BorderSide(

                  color:
                      Colors.cyanAccent,

                  width: 2.5,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(
          height: 14,
        ),
      ],
    );
  }
}