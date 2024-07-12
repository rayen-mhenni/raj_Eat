import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:raj_eat/providers/product_provider.dart';
import 'package:raj_eat/providers/review_cart_provider.dart';
import 'package:raj_eat/providers/user_provider.dart';
import 'package:raj_eat/screens/home/singal_product.dart';
import 'package:raj_eat/config/colors.dart';
import 'package:raj_eat/screens/product_overview/product_overview.dart';
import 'package:raj_eat/screens/review_cart/review_cart.dart';
import '../search/search.dart';
import 'drawer_side.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProductProvider? productProvider;


  Widget _buildPizzaProduct(context) {
    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pizza'),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Search(
                    search: productProvider?.getPizzaProductDataList ?? [], // Safe access and provide default value
                  )));
                },
                child: Text('view all', style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: (productProvider?.getPizzaProductDataList ?? []).map((pizzaProductData) {
              return SingalProduct(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProductOverview(
                      productId: pizzaProductData.productId,
                      productPrice: pizzaProductData.productPrice,
                      productName: pizzaProductData.productName,
                      productImage: pizzaProductData.productImage,

                    ),
                  ));
                },
                productPrice: pizzaProductData.productPrice,
                productImage: pizzaProductData.productImage,
                productName: pizzaProductData.productName,
                productId: pizzaProductData.productId,
                productUnit:pizzaProductData ,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }


  Widget _buildSandwichProduct(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sandwich'),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Search(
                    search: productProvider?.getSandwichProductDataList ?? [], // Safe access and provide default value
                  )));
                },
                child:
              Text('view all', style: TextStyle(color: Colors.grey),
              ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              children: productProvider?.getSandwichProductDataList
                  ?.map(
                    (sandwichProductData) {
                  return  SingalProduct(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductOverview(
                          productId: sandwichProductData.productId,
                          productPrice: sandwichProductData.productPrice ,
                          productName:sandwichProductData.productName ,
                          productImage: sandwichProductData.productImage,

                        ),
                      ),
                      );
                    },
                    productPrice: sandwichProductData.productPrice ,
                    productImage: sandwichProductData.productImage,
                    productName: sandwichProductData.productName,
                    productId: sandwichProductData.productId,
                    productUnit:sandwichProductData ,
                  );
                },
              )
                  ?.toList() ??
                  [],
          ),
        ),

      ],
    );
  }

  Widget _buildMakloubProduct(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Makloub'),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Search(
                    search: productProvider?.getMakloubProductDataList ?? [], // Safe access and provide default value
                  )));
                },
                child:
              Text('view all', style: TextStyle(color: Colors.grey),
              ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: productProvider?.getMakloubProductDataList
                ?.map(
                  (makloubProductData) {
                return  SingalProduct(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProductOverview(
                        productId: makloubProductData.productId,
                        productPrice: makloubProductData.productPrice ,
                        productName: makloubProductData.productName ,
                        productImage: makloubProductData.productImage,

                      ),
                    ),
                    );
                  },
                  productPrice: makloubProductData.productPrice ,
                  productImage: makloubProductData.productImage,
                  productName: makloubProductData.productName,
                  productId: makloubProductData.productId,
                  productUnit:makloubProductData ,

                );
              },
            )
                ?.toList() ??
                [],
          ),
        ),

      ],
    );
  }

  @override
  void initState() {
    ProductProvider initproductProvider = Provider.of(context, listen: false);
    initproductProvider .fatchPizzaProductData();
    initproductProvider .fatchSandwichProductData();
    initproductProvider .fatchMakloubProductData();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    productProvider =Provider.of(context);
    UserProvider userProvider = Provider.of(context);
    userProvider.getUserData();
    return Scaffold(
      resizeToAvoidBottomInset: false,
     drawer: DrawerSide(userProvider: userProvider),
     appBar: AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      title: Text('Home',
        style: TextStyle(
          color: Colors.black,
            fontSize: 17),
    ),
      actions: [
      CircleAvatar(
       radius: 15,
       backgroundColor: primaryColor,
        child: IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Search(
                search: productProvider?.getAllProductSearch ?? [], // Use null-aware operator to safely access 'getAllProductSearch' property
              ),
            ));
          },
          icon: Icon(
            Icons.search,
            size: 17,
            color: textColor,
          ),
        ),



      ),
      Padding(

       padding: const EdgeInsets.symmetric(horizontal: 5),

       child: GestureDetector(
         onTap: (){
           Navigator.of(context).push(
             MaterialPageRoute(
               builder: (context) => Consumer<ReviewCartProvider>(
                 builder: (context, reviewCartProvider, _) => ReviewCart(
                   reviewCartProvider: reviewCartProvider,
                 ),
               ),
             ),
           );
         },
         child: CircleAvatar(
          backgroundColor: primaryColor,
          radius: 12,
          child: Icon(Icons.shop,size:17 ,color: textColor,),

             ),
       ),
    ),
    ],
      backgroundColor: primaryColor,
    ),

     body: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: ListView(
            children: [
          Container(
            height: 150,

          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_ykQZjPH3OAQTXDTc1DOIwXODiAGlrYGJUCJsdikpVQ&s '),
            ),
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),

          child: Row(
              children: [
                Expanded(
                 flex: 2,
                 child: Container(
                   child: Column(
                       children: [
                   Padding(

                   padding: const EdgeInsets.only(right: 130, bottom: 10),
                    child: Container(
                     height: 50,
                     width: 100,
                     decoration: BoxDecoration(
                       color: Color(0xffd1ad17),
                       borderRadius: BorderRadius.only(
                         bottomRight: Radius.circular(50),
                         bottomLeft: Radius.circular(50),
                       ),
                     ),
                      child: Center(
                        child: Text(
                          'RajEat',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            shadows: [
                              BoxShadow(
                                  color: Colors.green,
                                  blurRadius: 10,
                                  offset: Offset(3, 3))
                            ],
                          ),
                        ),
                      ),
                   ),
                   ),
                         Text(
                           'Welcome to rajEat',
                           style: TextStyle(
                               fontSize: 40,
                               color: Colors.green[100],
                               fontWeight: FontWeight.bold),
                         ),
                         Padding(
                           padding: const EdgeInsets.only(left: 20),
                           child: Text(
                             'reserve now!',
                             style: TextStyle(
                               color: Colors.white,
                             ),
                           ),
                         ),
                   ],
                   ),

             ),

            ),
                ],
          )
          ),




              _buildPizzaProduct(context),

              _buildMakloubProduct(context),

              _buildSandwichProduct(context),



            ],
        ),
    ),
    );
  }
}