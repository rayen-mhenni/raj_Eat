import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raj_eat/config/colors.dart';
import 'package:raj_eat/providers/review_cart_provider.dart';
import 'package:raj_eat/providers/wishlist_provider.dart';
import 'package:raj_eat/screens/review_cart/review_cart.dart';
import 'package:raj_eat/widgets/count.dart';

enum SinginCharacter { fill, outline }

class ProductOverview extends StatefulWidget {
  final String productName;
  final String productImage;
  final int productPrice;
  final String productId;

  const ProductOverview({
    Key? key,
    this.productImage = '',
    this.productName = '',
    this.productPrice = 0,
    this.productId = '',
  }) : super(key: key);

  @override
  _ProductOverviewState createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  SinginCharacter _character = SinginCharacter.fill;
  Map<String, bool> selectedOptions = {
    'Salad Mechwiya': false,
    'Oignons': false,
    'Salad': false,
    'Tomatoes': false,
  };

  bool wishListBool = false;

  @override
  void initState() {
    super.initState();
    getWishtListBool();
  }

  void getWishtListBool() {
    FirebaseFirestore.instance
        .collection("WishList")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("YourWishList")
        .doc(widget.productId)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          wishListBool = value.get("wishList");
        });
      }
    });
  }

  void updateProductOptions(String productId, Map<String, bool> selectedOptions, ReviewCartProvider reviewCartProvider) async {
    List<String> selectedOptionsList = [];
    selectedOptions.forEach((option, isSelected) {
      if (isSelected) {
        selectedOptionsList.add(option);
      }
    });

    // Mise à jour de Firestore sous la collection "UserSelections"
    await FirebaseFirestore.instance
        .collection("UserSelections")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Products")
        .doc(productId)
        .set({
      'productId': productId,
      'selectedOptions': selectedOptionsList,
    });


    reviewCartProvider.addReviewCartData(
        cartId: widget.productId,
        cartName: widget.productName,
        cartImage: widget.productImage,
        cartPrice: widget.productPrice,
        selectedOptions: selectedOptionsList,
        cartQuantity: 1
    );

    // Mise à jour des statistiques des options et diminution du stock
    await updateStockAndStatistics(productId, selectedOptionsList.length);
  }

  Future<void> updateStockAndStatistics(String productId, int optionsCount) async {
    DocumentReference productRef = FirebaseFirestore.instance.collection("UserSelections")
        .doc(FirebaseAuth.instance.currentUser!.uid).collection('Products').doc(productId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(productRef);

      if (!snapshot.exists) {
        throw Exception("Product does not exist!");
      }

      /*int currentStock = snapshot['stock'];
      if (currentStock < optionsCount) {
        throw Exception("Not enough stock!");
      }

      // Mise à jour du stock
      transaction.update(productRef, {'stock': currentStock - optionsCount});

      // Mise à jour des statistiques des options
      DocumentReference statsRef = FirebaseFirestore.instance.collection('OptionStatistics').doc(productId);
      DocumentSnapshot statsSnapshot = await transaction.get(statsRef);
      Map<String, dynamic> statsData = statsSnapshot.exists ? statsSnapshot.data() as Map<String, dynamic> : {};

      for (String option in selectedOptions.keys) {
        if (selectedOptions[option] == true) {
          statsData[option] = (statsData[option] ?? 0) + 1;
        }
      }

      transaction.set(statsRef, statsData);*/
    });
  }

  Widget bonntonNavigatorBar({
    Color iconColor = Colors.black,
    Color backgroundColor = Colors.white,
    Color color = Colors.black,
    String title = '',
    IconData iconData = Icons.error,
    Function()? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          color: backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 20,
                color: iconColor,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                title,
                style: TextStyle(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WishListProvider wishListProvider = Provider.of<WishListProvider>(context);
    return Consumer<ReviewCartProvider>(
        builder: (context, reviewCartProvider, _) {
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: textColor),
              title: Text(
                "Product Overview",
                style: TextStyle(color: textColor),
              ),
            ),

            bottomNavigationBar: Row(
              children: [
                bonntonNavigatorBar(
                    backgroundColor: textColor,
                    color: Colors.white70,
                    iconColor: Colors.grey,
                    title: "Add To WishList",
                    iconData: wishListBool ? Icons.favorite : Icons.favorite_outline,
                    onTap: () {
                      setState(() {
                        wishListBool = !wishListBool;
                      });
                      if (wishListBool) {
                        wishListProvider.addWishListData(
                          wishListId: widget.productId,
                          wishListImage: widget.productImage,
                          wishListName: widget.productName,
                          wishListPrice: widget.productPrice,
                          wishListQuantity: 2,
                        );
                      } else {
                        wishListProvider.deleteWishtList(widget.productId);
                      }
                    }),
                bonntonNavigatorBar(
                    backgroundColor: primaryColor,
                    color: textColor,
                    iconColor: Colors.white70,
                    title: "Go To Cart",
                    iconData: Icons.shop_outlined,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ReviewCart(
                            reviewCartProvider: reviewCartProvider,
                          ),
                        ),
                      );
                    }),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(widget.productName),
                          subtitle: Text("\$${widget.productPrice}"),
                        ),
                        Container(
                            height: 250,
                            padding: const EdgeInsets.all(40),
                            child: Image.network(
                              widget.productImage,
                            )),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          width: double.infinity,
                          child: Text(
                            "Available Options",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            children: selectedOptions.keys.map((option) {
                              return CheckboxListTile(
                                title: Text(option),
                                value: selectedOptions[option],
                                onChanged: (bool? value) {
                                  setState(() {
                                    selectedOptions[option] = value ?? false;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            updateProductOptions(widget.productId, selectedOptions, reviewCartProvider);
                          },
                          child: Text("Update Options"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}
