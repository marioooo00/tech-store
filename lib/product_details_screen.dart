import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductDetailsScreen
    extends StatefulWidget {

  final Map<String, dynamic> productData;

  const ProductDetailsScreen({

    super.key,

    required this.productData,
  });

  @override
  State<ProductDetailsScreen>
      createState() =>
          _ProductDetailsScreenState();
}

class _ProductDetailsScreenState
    extends State<ProductDetailsScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(
        0xFF001F2D,
      ),

      appBar: AppBar(

        backgroundColor:
            Colors.transparent,

        elevation: 0,

        iconTheme:
            const IconThemeData(

          color:
              Colors.white,
        ),
      ),

      body:
          SingleChildScrollView(

        padding:
            const EdgeInsets.all(
          20,
        ),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // =========================
            // IMAGE
            // =========================
            Center(

              child: Hero(

                tag:
                    widget.productData['image'],

                child: Image.network(

                  widget.productData['image'],

                  height: 300,

                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            // =========================
            // NAME
            // =========================
            Text(

              widget.productData['name'],

              style:
                  const TextStyle(

                color:
                    Colors.white,

                fontSize: 28,

                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            // =========================
            // PRICE
            // =========================
            Text(

              "\$${widget.productData['price']}",

              style:
                  const TextStyle(

                color:
                    Colors.cyan,

                fontSize: 26,

                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // =========================
            // DESCRIPTION
            // =========================
            Text(

              widget.productData['description']
                      ??
                  "No Description",

              style:
                  const TextStyle(

                color:
                    Colors.white70,

                fontSize: 16,

                height: 1.6,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // =========================
            // RATING
            // =========================
            Row(

              children: [

                const Icon(

                  Icons.star,

                  color:
                      Colors.amber,

                  size: 24,
                ),

                const SizedBox(
                  width: 6,
                ),

                Text(

                  widget.productData['rating']
                      .toString(),

                  style:
                      const TextStyle(

                    color:
                        Colors.white,

                    fontSize: 18,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  width: 8,
                ),

                const Text(

                  "(120 Reviews)",

                  style: TextStyle(

                    color:
                        Colors.white54,

                    fontSize: 14,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 35,
            ),

            // =========================
            // ADD TO CART BUTTON
            // =========================
            SizedBox(

              width:
                  double.infinity,

              height: 55,

              child:
                  ElevatedButton(

                style:
                    ElevatedButton.styleFrom(

                  backgroundColor:
                      Colors.cyan,

                  foregroundColor:
                      Colors.black,

                  elevation: 10,

                  shape:
                      RoundedRectangleBorder(

                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),
                ),

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
                                widget.productData['name'],
                          )
                          .get();

                  // =========================
                  // IF PRODUCT EXISTS
                  // =========================
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

                    // =========================
                    // ADD NEW PRODUCT
                    // =========================
                    await cart.add({

                      "name":
                          widget.productData['name'],

                      "price":
                          widget.productData['price'],

                      "image":
                          widget.productData['image'],

                      "quantity":
                          1,
                    });
                  }

                 if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Added To Cart"),
                  ),
                );
                },

                child:
                    const Text(

                  "Add To Cart",

                  style: TextStyle(

                    fontSize: 18,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}