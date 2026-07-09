import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'cart_page.dart';
import 'favorite_screen.dart';
import 'product_details_screen.dart';
import 'profile_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {

  int currentIndex = 0;

  final PageController
      pageController =
      PageController();

  final TextEditingController
      searchController =
      TextEditingController();

  String searchText = "";
  
  String userName = "User";

  @override
  void initState() {

    super.initState();

    loadUserData();
  }

  // =========================
  // LOAD USER DATA
  // =========================
  Future<void> loadUserData()
  async {

    final user =
        FirebaseAuth
            .instance
            .currentUser;

    if (user == null) {
      return;
    }

    var doc =
        await FirebaseFirestore
            .instance
            .collection("users")
            .doc(user.uid)
            .get();

    if (doc.exists) {

      setState(() {

        userName =
            doc['name'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final pages = [

      homeContent(),

      const CartScreen(),

      const FavoriteScreen(),

      const ProfilePage(),
    ];

    return Scaffold(

      backgroundColor:
          const Color(
        0xFF001F2D,
      ),

      body:
          Stack(

        children: [

          // =========================
          // BACKGROUND
          // =========================
          SizedBox.expand(

            child: Image.asset(

              "assets/images/bg.jpg",

              fit: BoxFit.cover,
            ),
          ),

          Container(

            color:
                Colors.black
                    .withValues(
              alpha: 0.55,
            ),
          ),

          pages[currentIndex],
        ],
      ),

      bottomNavigationBar:
          UltraBottomBar(

        currentIndex:
            currentIndex,

        onTap: (index) {

          setState(() {

            currentIndex =
                index;
          });
        },
      ),
    );
  }

  // =========================
  // HOME CONTENT
  // =========================
  Widget homeContent() {

    return SafeArea(

      child: Column(

        children: [

          const SizedBox(
            height: 18,
          ),

          // =========================
          // TOP SECTION
          // =========================
          Padding(

            padding:
                const EdgeInsets.symmetric(
              horizontal: 18,
            ),

            child: Column(

              children: [

                // =========================
                // LOGO + WELCOME
                // =========================
                Row(

                  children: [

                    Container(

                      padding:
                          const EdgeInsets.all(
                        10,
                      ),

                      decoration:
                          BoxDecoration(

                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),

                        gradient:
                            LinearGradient(

                          colors: [

                            Colors.cyan
                                .withValues(
                              alpha: 0.18,
                            ),

                            Colors.blue
                                .withValues(
                              alpha: 0.08,
                            ),
                          ],
                        ),

                        border:
                            Border.all(
                          color:
                              Colors.cyan,
                        ),
                      ),

                      child: Image.asset(

                        'assets/images/Logo.png',

                        width: 45,
                      ),
                    ),

                    const SizedBox(
                      width: 14,
                    ),

                    Expanded(

                      child: Column(

                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          Text(

                            "Welcome Back ",

                            style: TextStyle(

                              color:
                                  Colors.white
                                      .withValues(
                                alpha: 0.65,
                              ),

                              fontSize: 15,
                            ),
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          Text(

                            userName,

                            overflow:
                                TextOverflow
                                    .ellipsis,

                            style:
                                const TextStyle(

                              color:
                                  Colors.cyanAccent,

                              fontSize: 27,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 22,
                ),

                // =========================
                // SEARCH
                // =========================
                TextField(

                  controller:
                      searchController,

                  onChanged: (value) {

                    setState(() {

                      searchText =
                          value
                              .toLowerCase();
                    });
                  },

                  style:
                      const TextStyle(

                    color:
                        Colors.white,
                  ),

                  decoration:
                      InputDecoration(

                    hintText:
                        "Search Product...",

                    hintStyle:
                        const TextStyle(

                      color:
                          Colors.white54,
                    ),

                    prefixIcon:
                        const Icon(

                      Icons.search_rounded,

                      color:
                          Colors.cyan,

                      size: 28,
                    ),

                    filled: true,

                    fillColor:
                        Colors.black
                            .withValues(
                      alpha: 0.22,
                    ),

                    contentPadding:
                        const EdgeInsets.symmetric(
                      vertical: 18,
                    ),

                    enabledBorder:
                        OutlineInputBorder(

                      borderRadius:
                          BorderRadius.circular(
                        22,
                      ),

                      borderSide:
                          BorderSide(

                        color:
                            Colors.cyan
                                .withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),

                    focusedBorder:
                        OutlineInputBorder(

                      borderRadius:
                          BorderRadius.circular(
                        22,
                      ),

                      borderSide:
                          const BorderSide(

                        color:
                            Colors.cyan,

                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          // =========================
          // BODY
          // =========================
          Expanded(

            child:
                SingleChildScrollView(

              physics:
                  const BouncingScrollPhysics(),

              child: Column(

                children: [

                  // =========================
                  // OFFERS
                  // =========================
                  SizedBox(

                    height: 210,

                    child:
                        StreamBuilder<QuerySnapshot>(

                      stream:
                          FirebaseFirestore
                              .instance
                              .collection(
                                "offers",
                              )
                              .snapshots(),

                      builder:
                          (
                            context,
                            snapshot,
                          ) {

                        if (!snapshot
                            .hasData) {

                          return const Center(

                            child:
                                CircularProgressIndicator(
                              color:
                                  Colors.cyan,
                            ),
                          );
                        }

                        var offers =
                            snapshot
                                .data!
                                .docs;

                        return Column(

                          children: [

                            SizedBox(

                              height: 180,

                              child:
                                  PageView.builder(

                                controller:
                                    pageController,

                                itemCount:
                                    offers.length,

                                itemBuilder:
                                    (
                                      context,
                                      index,
                                    ) {

                                  var data =
                                      offers[index]
                                              .data()
                                          as Map<
                                            String,
                                            dynamic
                                          >;

                                  return Padding(

                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal:
                                          16,
                                    ),

                                    child:
                                        Container(

                                      decoration:
                                          BoxDecoration(

                                        borderRadius:
                                            BorderRadius.circular(
                                          30,
                                        ),

                                        gradient:
                                            const LinearGradient(

                                          colors: [

                                            Color(
                                              0xFF021B2B,
                                            ),

                                            Color(
                                              0xFF06344D,
                                            ),
                                          ],
                                        ),

                                        border:
                                            Border.all(

                                          color:
                                              Colors.cyan,
                                        ),
                                      ),

                                      child:
                                          Row(

                                        children: [

                                          Expanded(

                                            child:
                                                Padding(

                                              padding:
                                                  const EdgeInsets.all(
                                                20,
                                              ),

                                              child:
                                                  Text(

                                                data['title'],

                                                style:
                                                    const TextStyle(

                                                  color:
                                                      Colors.cyan,

                                                  fontSize:
                                                      28,

                                                  fontWeight:
                                                      FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),

                                          Expanded(

                                            child:
                                                Image.network(

                                              data['image'],

                                              fit:
                                                  BoxFit.contain,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            SmoothPageIndicator(

                              controller:
                                  pageController,

                              count:
                                  offers.length,

                              effect:
                                  const ExpandingDotsEffect(

                                activeDotColor:
                                    Colors.cyan,

                                dotColor:
                                    Colors.white24,

                                dotHeight:
                                    8,

                                dotWidth:
                                    8,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  // =========================
                  // PRODUCTS
                  // =========================
                  Padding(

                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),

                    child:
                        StreamBuilder<QuerySnapshot>(

                      stream:
                          FirebaseFirestore
                              .instance
                              .collection(
                                "products",
                              )
                              .snapshots(),

                      builder:
                          (
                            context,
                            snapshot,
                          ) {

                        if (!snapshot
                            .hasData) {

                          return const Center(

                            child:
                                CircularProgressIndicator(
                              color:
                                  Colors.cyan,
                            ),
                          );
                        }

                        var products =
                            snapshot
                                .data!
                                .docs
                                .where((doc) {

                          var data =
                              doc.data()
                                  as Map<
                                    String,
                                    dynamic
                                  >;

                          return data['name']
                              .toString()
                              .toLowerCase()
                              .contains(
                                searchText,
                              );
                        }).toList();

                        return GridView.builder(

                          shrinkWrap:
                              true,

                          physics:
                              const NeverScrollableScrollPhysics(),

                          itemCount:
                              products.length,

                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(

                            crossAxisCount:
                                2,

                            childAspectRatio:
                                0.50,
                          ),

                          itemBuilder:
                              (
                                context,
                                index,
                              ) {

                            var data =
                                products[index]
                                        .data()
                                    as Map<
                                      String,
                                      dynamic
                                    >;

                            return productCard(
                              data,
                            );
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(
                    height: 120,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // PRODUCT CARD
  // =========================
  Widget productCard(
    Map<String, dynamic> data,
  ) {

    return GestureDetector(

      onTap: () {

        Navigator.push(

          context,

          MaterialPageRoute(

            builder:
                (context) =>
                    ProductDetailsScreen(
                      productData:
                          data,
                    ),
          ),
        );
      },

      child: Container(

        margin:
            const EdgeInsets.all(8),

        padding:
            const EdgeInsets.all(12),

        decoration:
            BoxDecoration(

          borderRadius:
              BorderRadius.circular(
            28,
          ),

          gradient:
              LinearGradient(

            colors: [

              Colors.black
                  .withValues(
                alpha: 0.25,
              ),

              Colors.cyan
                  .withValues(
                alpha: 0.12,
              ),
            ],
          ),

          border:
              Border.all(

            color:
                Colors.cyan
                    .withValues(
              alpha: 0.7,
            ),
          ),
        ),

        child: Column(

          children: [

           Align(
  alignment: Alignment.topRight,
  child: FutureBuilder<DocumentSnapshot>(
    future: FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('favorites')
        .doc(data['name'].toString())
        .get(),

    builder: (context, snapshot) {

      bool isFavorite =
          snapshot.data?.exists ?? false;

      return IconButton(

        onPressed: () async {

          final uid =
              FirebaseAuth
                  .instance
                  .currentUser!
                  .uid;

          String productId =
              data['name'].toString();

          var favRef =
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('favorites')
                  .doc(productId);

          var favDoc =
              await favRef.get();

          if (favDoc.exists) {

            await favRef.delete();

          } else {

            await favRef.set({

              'id': productId,
              'name': data['name'],
              'price': data['price'],
              'image': data['image'],
              'description':
                  data['description'],
            });
          }

          setState(() {});
        },

        icon: Icon(

          isFavorite
              ? Icons.favorite
              : Icons.favorite_border,

          color:
              isFavorite
                  ? Colors.red
                  : Colors.white,
        ),
      );
    },
  ),
),

            SizedBox(

              height: 100,

              child: Image.network(
                data['image'],
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            Text(

              data['name'],

              textAlign:
                  TextAlign.center,

              maxLines: 2,

              overflow:
                  TextOverflow
                      .ellipsis,

              style:
                  const TextStyle(

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

              "\$${data['price']}",

              style:
                  const TextStyle(

                color:
                    Colors.cyan,

                fontSize: 24,

                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const Spacer(),

            // =========================
            // ADD TO CART
            // =========================
            SizedBox(

              width:
                  double.infinity,

              child:
                  ElevatedButton(

                onPressed: () async {

                  final uid =
                      FirebaseAuth
                          .instance
                          .currentUser!
                          .uid;

                  var cart =
                      FirebaseFirestore
                          .instance
                          .collection(
                            "users",
                          )
                          .doc(uid)
                          .collection(
                            "cart",
                          );

                  var existing =
                      await cart
                          .where(
                            "name",
                            isEqualTo:
                                data['name'],
                          )
                          .get();

                  if (existing
                      .docs
                      .isNotEmpty) {

                    var doc =
                        existing
                            .docs
                            .first;

                    int quantity =
                        doc['quantity'];

                    await cart
                        .doc(doc.id)
                        .update({

                      "quantity":
                          quantity + 1,
                    });

                  } else {

                    await cart.add({

                      "name":
                          data['name'],

                      "price":
                          data['price'],

                      "image":
                          data['image'],

                      "quantity": 1,
                    });
                  }

                  if (!mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(

                    const SnackBar(

                      content: Text(
                        "Added To Cart",
                      ),
                    ),
                  );
                },

                style:
                    ElevatedButton.styleFrom(

                  backgroundColor:
                      Colors.cyan,

                  foregroundColor:
                      Colors.black,
                ),

                child: const Text(
                  "Add To Cart",
                ),
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            // =========================
            // DETAILS
            // =========================
            SizedBox(

              width:
                  double.infinity,

              child:
                  OutlinedButton(

                onPressed: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder:
                          (context) =>
                              ProductDetailsScreen(
                                productData:
                                    data,
                              ),
                    ),
                  );
                },

                style:
                    OutlinedButton.styleFrom(

                  side:
                      BorderSide(

                    color:
                        Colors
                            .purpleAccent
                            .withValues(
                      alpha: 0.8,
                    ),
                  ),

                  shape:
                      RoundedRectangleBorder(

                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
                  ),
                ),

                child:
                    const Text(

                  "Details",

                  style: TextStyle(

                    color:
                        Colors
                            .purpleAccent,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================
// BOTTOM BAR
// =========================
class UltraBottomBar
    extends StatelessWidget {

  final int currentIndex;

  final Function(int) onTap;

  const UltraBottomBar({

    super.key,

    required this.currentIndex,

    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final icons = [

      Icons.home_rounded,

      Icons.shopping_cart_rounded,

      Icons.favorite_rounded,

      Icons.person_rounded,
    ];

    return Container(

      margin:
          const EdgeInsets.all(15),

      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
      ),

      height: 80,

      decoration:
          BoxDecoration(

        borderRadius:
            BorderRadius.circular(
          30,
        ),

        color:
            Colors.black
                .withValues(
          alpha: 0.35,
        ),

        border:
            Border.all(

          color:
              Colors.cyan
                  .withValues(
            alpha: 0.25,
          ),
        ),

        boxShadow: [

          BoxShadow(

            color:
                Colors.cyan
                    .withValues(
              alpha: 0.08,
            ),

            blurRadius: 20,
          ),
        ],
      ),

      child: Row(

        mainAxisAlignment:
            MainAxisAlignment
                .spaceAround,

        children: List.generate(
          icons.length,
          (index) {

            bool isSelected =
                currentIndex ==
                    index;

            return GestureDetector(

              onTap: () =>
                  onTap(index),

              child: AnimatedContainer(

                duration:
                    const Duration(
                  milliseconds: 250,
                ),

                padding:
                    const EdgeInsets.all(
                  12,
                ),

                decoration:
                    BoxDecoration(

                  shape:
                      BoxShape.circle,

                  color:
                      isSelected
                          ? Colors.cyan
                              .withValues(
                              alpha: 0.18,
                            )
                          : Colors
                              .transparent,

                  boxShadow:
                      isSelected
                          ? [

                              BoxShadow(

                                color:
                                    Colors.cyan
                                        .withValues(
                                  alpha:
                                      0.25,
                                ),

                                blurRadius:
                                    18,
                              ),
                            ]
                          : [],
                ),

                child: Icon(

                  icons[index],

                  size: 30,

                  color:
                      isSelected
                          ? Colors.cyanAccent
                          : Colors.white54,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}