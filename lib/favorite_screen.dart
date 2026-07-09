import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'product_details_screen.dart';

class FavoriteScreen
    extends StatelessWidget {

  const FavoriteScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final uid =
        FirebaseAuth
            .instance
            .currentUser!
            .uid;

    return Scaffold(

      backgroundColor:
          const Color(
        0xFF001F2D,
      ),

      appBar: AppBar(

        backgroundColor:
            Colors.transparent,

        elevation: 0,

        centerTitle: true,

        title: const Text(

          "Favorites",

          style: TextStyle(

            color:
                Colors.white,

            fontWeight:
                FontWeight.bold,

            fontSize: 24,
          ),
        ),
      ),

      body:
          StreamBuilder<QuerySnapshot>(

        stream:
            FirebaseFirestore
                .instance
                .collection("users")
                .doc(uid)
                .collection(
                  "favorites",
                )
                .snapshots(),

        builder:
            (
              context,
              snapshot,
            ) {

          if (!snapshot.hasData) {

            return const Center(

              child:
                  CircularProgressIndicator(
                color:
                    Colors.cyan,
              ),
            );
          }

          var products =
              snapshot.data!.docs;

          /// ❤️ EMPTY FAVORITES
          if (products.isEmpty) {

            return Center(

              child: Column(

                mainAxisAlignment:
                    MainAxisAlignment
                        .center,

                children: [

                  /// ❤️ ICON
                  Container(

                    padding:
                        const EdgeInsets.all(
                      30,
                    ),

                    decoration:
                        BoxDecoration(

                      shape:
                          BoxShape.circle,

                      color:
                          Colors.red
                              .withValues(
                        alpha: 0.08,
                      ),

                      boxShadow: [

                        BoxShadow(

                          color:
                              Colors.red
                                  .withValues(
                            alpha: 0.25,
                          ),

                          blurRadius:
                              30,

                          spreadRadius:
                              2,
                        ),
                      ],
                    ),

                    child:
                        const Icon(

                      Icons
                          .favorite_border,

                      size: 90,

                      color:
                          Colors.red,
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  /// ❤️ TITLE
                  const Text(

                    "Your Favorites Is Empty",

                    style: TextStyle(

                      color:
                          Colors.white,

                      fontSize: 32,

                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  /// ❤️ SUBTITLE
                  Text(

                    "Save Products You FAV Here",

                    style: TextStyle(

                      color:
                          Colors.white
                              .withValues(
                        alpha: 0.5,
                      ),

                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(

            padding:
                const EdgeInsets.all(
              12,
            ),

            itemCount:
                products.length,

            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(

              crossAxisCount: 2,

              childAspectRatio:
                  0.50,

              crossAxisSpacing:
                  10,

              mainAxisSpacing:
                  10,
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

              return Container(

                decoration:
                    BoxDecoration(

                  borderRadius:
                      BorderRadius.circular(
                    30,
                  ),

                  gradient:
                      LinearGradient(

                    colors: [

                      const Color(
                        0xFF021B2B,
                      ),

                      Colors.cyan
                          .withValues(
                        alpha: 0.15,
                      ),
                    ],

                    begin:
                        Alignment
                            .topLeft,

                    end:
                        Alignment
                            .bottomRight,
                  ),

                  border:
                      Border.all(

                    color:
                        Colors.cyan
                            .withValues(
                      alpha: 0.8,
                    ),

                    width: 1.5,
                  ),

                  boxShadow: [

                    BoxShadow(

                      color:
                          Colors.cyan
                              .withValues(
                        alpha: 0.25,
                      ),

                      blurRadius:
                          25,

                      spreadRadius:
                          2,
                    ),
                  ],
                ),

                child: Padding(

                  padding:
                      const EdgeInsets.all(
                    14,
                  ),

                  child: Column(

                    crossAxisAlignment:
                        CrossAxisAlignment
                            .center,

                    children: [

                      /// 🗑 DELETE BUTTON
                      Align(

                        alignment:
                            Alignment
                                .topLeft,

                        child:
                            GestureDetector(

                          onTap:
                              () async {

                            await FirebaseFirestore
                                .instance
                                .collection(
                                  "users",
                                )
                                .doc(uid)
                                .collection(
                                  "favorites",
                                )
                                .doc(
                                  products[index]
                                      .id,
                                )
                                .delete();
                          },

                          child:
                              Container(

                            padding:
                                const EdgeInsets.all(
                              8,
                            ),

                            decoration:
                                BoxDecoration(

                              shape:
                                  BoxShape.circle,

                              color:
                                  Colors.red
                                      .withValues(
                                alpha: 0.15,
                              ),

                              border:
                                  Border.all(

                                color:
                                    Colors.red,

                                width:
                                    1.2,
                              ),
                            ),

                            child:
                                const Icon(

                              Icons
                                  .delete_outline,

                              color:
                                  Colors.red,

                              size: 20,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 6,
                      ),

                      /// 🖼 IMAGE
                      SizedBox(

                        height: 95,

                        child:
                            Image.network(

                          data['image'],

                          fit:
                              BoxFit.contain,

                          width: 95,

                          height: 95,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      /// 🏷 NAME
                      Text(

                        data['name'],

                        maxLines: 2,

                        textAlign:
                            TextAlign.center,

                        overflow:
                            TextOverflow
                                .ellipsis,

                        style:
                            const TextStyle(

                          color:
                              Colors.white,

                          fontSize: 15,

                          fontWeight:
                              FontWeight.bold,

                          height: 1.2,
                        ),
                      ),

                      const SizedBox(
                        height: 6,
                      ),

                      /// 💰 PRICE
                      Text(

                        "\$${data['price']}",

                        style:
                            const TextStyle(

                          color:
                              Colors.cyan,

                          fontSize: 20,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      /// 🔥 ADD TO CART
                      SizedBox(

                        width:
                            double.infinity,

                        height: 38,

                        child:
                            ElevatedButton.icon(

                          onPressed:
                              () async {

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

                              int currentQuantity =
                                  doc['quantity'];

                              await cart
                                  .doc(
                                    doc.id,
                                  )
                                  .update({

                                "quantity":
                                    currentQuantity +
                                    1,
                              });

                            } else {

                              await cart.add({

                                "name":
                                    data['name'],

                                "price":
                                    data['price'],

                                "image":
                                    data['image'],

                                "quantity":
                                    1,
                              });
                            }
                          },

                          style:
                              ElevatedButton.styleFrom(

                            backgroundColor:
                                Colors.cyan,

                            foregroundColor:
                                Colors.black,

                            elevation:
                                10,

                            shadowColor:
                                Colors.cyan,

                            shape:
                                RoundedRectangleBorder(

                              borderRadius:
                                  BorderRadius.circular(
                                18,
                              ),
                            ),
                          ),

                          icon:
                              const Icon(

                            Icons
                                .shopping_cart_outlined,

                            size: 16,
                          ),

                          label:
                              const Text(

                            "Add To Cart",

                            style: TextStyle(

                              fontSize:
                                  10,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      /// 🔥 DETAILS
                      SizedBox(

                        width:
                            double.infinity,

                        height: 38,

                        child:
                            OutlinedButton.icon(

                          onPressed:
                              () {

                            Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder:
                                    (
                                      context,
                                    ) =>
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
                                alpha: 0.9,
                              ),

                              width:
                                  1.5,
                            ),

                            shape:
                                RoundedRectangleBorder(

                              borderRadius:
                                  BorderRadius.circular(
                                18,
                              ),
                            ),
                          ),

                          icon:
                              const Icon(

                            Icons
                                .visibility_outlined,

                            size: 16,

                            color:
                                Colors
                                    .purpleAccent,
                          ),

                          label:
                              const Text(

                            "Details",

                            style: TextStyle(

                              color:
                                  Colors
                                      .purpleAccent,

                              fontSize:
                                  10,

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
            },
          );
        },
      ),
    );
  }
}