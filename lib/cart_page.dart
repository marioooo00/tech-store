import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartScreen extends StatelessWidget {

  const CartScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final uid =
        FirebaseAuth
            .instance
            .currentUser!
            .uid;

    final cartRef =
        FirebaseFirestore
            .instance
            .collection("users")
            .doc(uid)
            .collection("cart");

    return Scaffold(

      backgroundColor:
          const Color(
        0xFF001F2D,
      ),

      body: SafeArea(

        child: StreamBuilder<QuerySnapshot>(

          stream:
              cartRef.snapshots(),

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

            var cartItems =
                snapshot.data!.docs;

            // =========================
            // EMPTY CART
            // =========================
            if (cartItems.isEmpty) {

              return Center(

                child: Column(

                  mainAxisAlignment:
                      MainAxisAlignment
                          .center,

                  children: [

                    Icon(

                      Icons
                          .shopping_cart_outlined,

                      size: 120,

                      color:
                          Colors.cyan
                              .withValues(
                        alpha: 0.7,
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    const Text(

                      "Your Cart Is Empty",

                      style: TextStyle(

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

                    const Text(

                      "Add Products To Start Shopping",

                      textAlign:
                          TextAlign.center,

                      style: TextStyle(

                        color:
                            Colors.white54,

                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }

            // =========================
            // TOTAL
            // =========================
            double total = 0;

            for (var item
                in cartItems) {

              var data =
                  item.data()
                      as Map<
                        String,
                        dynamic
                      >;

              int qty =
                  data['quantity'] ??
                  1;

              double price =
                  (data['price'] ?? 0)
                      .toDouble();

              total +=
                  price * qty;
            }

            return SingleChildScrollView(

              padding:
                  const EdgeInsets.all(
                12,
              ),

              child: Column(

                children: [

                  // =========================
                  // TITLE
                  // =========================
                  Container(

                    width:
                        double.infinity,

                    padding:
                        const EdgeInsets.all(
                      16,
                    ),

                    decoration:
                        BoxDecoration(

                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),

                      gradient:
                          LinearGradient(

                        colors: [

                          Colors.white
                              .withValues(
                            alpha: 0.08,
                          ),

                          Colors.cyan
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

                    child: Text(

                      "Your Cart (${cartItems.length} Items)",

                      textAlign:
                          TextAlign.center,

                      style:
                          const TextStyle(

                        color:
                            Colors.white,

                        fontSize: 28,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  // =========================
                  // ITEMS
                  // =========================
                  ListView.builder(

                    shrinkWrap:
                        true,

                    physics:
                        const NeverScrollableScrollPhysics(),

                    itemCount:
                        cartItems.length,

                    itemBuilder:
                        (
                          context,
                          index,
                        ) {

                      var data =
                          cartItems[index]
                                  .data()
                              as Map<
                                String,
                                dynamic
                              >;

                      int qty =
                          data['quantity'] ??
                          1;

                      return Container(

                        margin:
                            const EdgeInsets.only(
                          bottom: 14,
                        ),

                        padding:
                            const EdgeInsets.all(
                          12,
                        ),

                        decoration:
                            BoxDecoration(

                          borderRadius:
                              BorderRadius.circular(
                            25,
                          ),

                          gradient:
                              LinearGradient(

                            colors: [

                              Colors.white
                                  .withValues(
                                alpha: 0.06,
                              ),

                              Colors.cyan
                                  .withValues(
                                alpha: 0.03,
                              ),
                            ],
                          ),

                          border:
                              Border.all(
                            color:
                                Colors.cyan,
                          ),
                        ),

                        child: Row(

                          children: [

                            // =========================
                            // IMAGE
                            // =========================
                            Container(

                              width: 80,

                              height: 80,

                              decoration:
                                  BoxDecoration(

                                borderRadius:
                                    BorderRadius.circular(
                                  18,
                                ),

                                color:
                                    Colors.black
                                        .withValues(
                                  alpha: 0.2,
                                ),
                              ),

                              child: ClipRRect(

                                borderRadius:
                                    BorderRadius.circular(
                                  18,
                                ),

                                child:
                                    Image.network(

                                  data['image'],

                                  fit:
                                      BoxFit.contain,
                                ),
                              ),
                            ),

                            const SizedBox(
                              width: 14,
                            ),

                            // =========================
                            // INFO
                            // =========================
                            Expanded(

                              child: Column(

                                crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                children: [

                                  Row(

                                    children: [

                                      Expanded(

                                        child: Text(

                                          data['name'],

                                          maxLines: 1,

                                          overflow:
                                              TextOverflow.ellipsis,

                                          style:
                                              const TextStyle(

                                            color:
                                                Colors.white,

                                            fontSize: 20,

                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      // =========================
                                      // DELETE
                                      // =========================
                                      GestureDetector(

                                        onTap:
                                            () async {

                                          await cartRef
                                              .doc(
                                                cartItems[index]
                                                    .id,
                                              )
                                              .delete();
                                        },

                                        child:
                                            const Icon(

                                          Icons.delete,

                                          color:
                                              Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 8,
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

                                  const SizedBox(
                                    height: 10,
                                  ),

                                  // =========================
                                  // QUANTITY
                                  // =========================
                                  Row(

                                    children: [

                                      qtyButton(

                                        Icons.remove,

                                        () async {

                                          if (qty >
                                              1) {

                                            await cartRef
                                                .doc(
                                                  cartItems[index]
                                                      .id,
                                                )
                                                .update({

                                              "quantity":
                                                  qty -
                                                  1,
                                            });
                                          }
                                        },
                                      ),

                                      Padding(

                                        padding:
                                            const EdgeInsets.symmetric(
                                          horizontal:
                                              14,
                                        ),

                                        child: Text(

                                          qty.toString(),

                                          style:
                                              const TextStyle(

                                            color:
                                                Colors.white,

                                            fontSize: 20,

                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      qtyButton(

                                        Icons.add,

                                        () async {

                                          await cartRef
                                              .doc(
                                                cartItems[index]
                                                    .id,
                                              )
                                              .update({

                                            "quantity":
                                                qty +
                                                1,
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // =========================
                  // TOTAL BOX
                  // =========================
                  Container(

                    padding:
                        const EdgeInsets.all(
                      18,
                    ),

                    decoration:
                        BoxDecoration(

                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),

                      gradient:
                          LinearGradient(

                        colors: [

                          Colors.white
                              .withValues(
                            alpha: 0.08,
                          ),

                          Colors.cyan
                              .withValues(
                            alpha: 0.05,
                          ),
                        ],
                      ),

                      border:
                          Border.all(
                        color:
                            Colors.cyan,
                      ),
                    ),

                    child: Row(

                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                      children: [

                        const Text(

                          "Total",

                          style: TextStyle(

                            color:
                                Colors.white,

                            fontSize: 24,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        Text(

                          "\$${total.toStringAsFixed(0)}",

                          style:
                              const TextStyle(

                            color:
                                Colors.cyan,

                            fontSize: 26,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  // =========================
                  // CHECKOUT
                  // =========================
                  SizedBox(

                    width:
                        double.infinity,

                    height: 60,

                    child:
                        ElevatedButton(

                      onPressed: () {},

                      style:
                          ElevatedButton.styleFrom(

                        backgroundColor:
                            Colors.cyan,

                        foregroundColor:
                            Colors.black,

                        shape:
                            RoundedRectangleBorder(

                          borderRadius:
                              BorderRadius.circular(
                            30,
                          ),
                        ),
                      ),

                      child: const Text(

                        "Checkout",

                        style: TextStyle(

                          fontSize: 24,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 120,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // =========================
  // QTY BUTTON
  // =========================
  Widget qtyButton(

    IconData icon,

    VoidCallback onTap,
  ) {

    return GestureDetector(

      onTap: onTap,

      child: Container(

        padding:
            const EdgeInsets.all(
          8,
        ),

        decoration:
            BoxDecoration(

          color:
              Colors.cyan
                  .withValues(
            alpha: 0.2,
          ),

          borderRadius:
              BorderRadius.circular(
            12,
          ),
        ),

        child: Icon(

          icon,

          color:
              Colors.cyan,

          size: 20,
        ),
      ),
    );
  }
}