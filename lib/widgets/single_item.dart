import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:raj_eat/config/colors.dart';
import 'package:raj_eat/providers/review_cart_provider.dart';
import 'package:raj_eat/widgets/count.dart';




class SingleItem extends StatefulWidget {
  bool isBool = false;
  String productImage;
  String productName;
  int productPrice;
  String productId;
  int productQuantity;
  Function onDelete;
  bool wishList = false;

  SingleItem(
      {super.key, this.isBool = false, required this.productPrice, required this.productImage, required this.productName, required this.productId, required this.productQuantity, required this.onDelete,this.wishList = false,}); // Define isBool parameter in the constructor

  @override
  _SingleItemState createState() => _SingleItemState();
}

class _SingleItemState extends State<SingleItem> {
  ReviewCartProvider reviewCartProvider = ReviewCartProvider();
  int count = 0;
  getCount() {
    setState(() {
      count = widget.productQuantity;
    });
  }
  @override
  Widget build(BuildContext context) {
    getCount();
    reviewCartProvider = Provider.of<ReviewCartProvider>(context);
    reviewCartProvider.getReviewCartData();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:10),
          child: Row(
            children: [
              Expanded(child: SizedBox(
                height: 100,
                child: Center(
                  child: Image.network(widget.productImage,),
                ),
              ),
              ),
              Expanded(
                child: SizedBox(
                  height: 100,
                  child: Column(
                    mainAxisAlignment: widget.isBool == false ?
                    MainAxisAlignment.spaceAround
                        : MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.productName,
                            style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                            ),
                          ),
                          Text("${widget.productPrice}d" ,
                            style: TextStyle(
                              color: textColor,
                              fontWeight:  FontWeight.bold,


                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child:
                Container(
                  height: 100,
                  padding:widget.isBool == false?const EdgeInsets.symmetric(horizontal: 15,vertical: 32)
                      :const EdgeInsets.only(left: 15,right:15 ),
                  child: widget.isBool==false?
                  Count(
                    productId: widget.productId,
                    productImage: widget.productImage,
                    productName: widget.productName,
                    productPrice: widget.productPrice,

                  )
                      :Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: widget.onDelete != null ? () => widget.onDelete() : null,
                          child: const Icon(Icons.delete,size: 30,color: Colors.black45,
                          ),
                        ),
                        const SizedBox(

                          height: 5,
                        ),
                        widget.wishList == false
                            ? Container(
                          height: 25,
                          width: 70,

                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child:Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (count == 1) {
                                      Fluttertoast.showToast(
                                        msg:
                                        "You reach minimum limit",

                                      );
                                    } else {
                                      setState(() {
                                        count--;
                                      });
                                      reviewCartProvider
                                          .updateReviewCartData(
                                        cartImage:
                                        widget.productImage,
                                        cartId: widget.productId,
                                        cartName:
                                        widget.productName,
                                        cartPrice:
                                        widget.productPrice,
                                        cartQuantity: count,
                                      );
                                    }
                                  },
                                  child:Icon(
                                    Icons.remove,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                ),
                                Text("$count",
                                  style: TextStyle(
                                    color: primaryColor,

                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (count < 10) {
                                      setState(() {
                                        count++;
                                      });
                                      reviewCartProvider
                                          .updateReviewCartData(
                                        cartImage:
                                        widget.productImage,
                                        cartId: widget.productId,
                                        cartName:
                                        widget.productName,
                                        cartPrice:
                                        widget.productPrice,
                                        cartQuantity: count,
                                      );
                                    }
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ) ,
                        )

                            : Container(),

                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
        widget.isBool == false?Container():const Divider(
          height: 1,
          color: Colors.black45,
        ),
      ],
    );
  }
}