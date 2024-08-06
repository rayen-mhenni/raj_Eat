import 'package:flutter/material.dart';
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
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProductProvider? productProvider;

  Widget _buildPizzaProduct(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Pizza'),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Search(
                      search: productProvider?.getPizzaProductDataList ?? [], // Safe access and provide default value
                    ),
                  ));
                },
                child: const Text('view all', style: TextStyle(color: Colors.grey)),
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
                      productPrice: pizzaProductData.productPrice.toInt(),
                      productName: pizzaProductData.productName,
                      productImage: pizzaProductData.productImage,
                    ),
                  ));
                },
                productPrice: pizzaProductData.productPrice.toInt(),
                productImage: pizzaProductData.productImage,
                productName: pizzaProductData.productName,
                productId: pizzaProductData.productId,
                productUnit: pizzaProductData,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSandwichProduct(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Sandwich'),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Search(
                      search: productProvider?.getSandwichProductDataList ?? [], // Safe access and provide default value
                    ),
                  ));
                },
                child: const Text('view all', style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: (productProvider?.getSandwichProductDataList ?? []).map((sandwichProductData) {
              return SingalProduct(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProductOverview(
                      productId: sandwichProductData.productId,
                      productPrice: sandwichProductData.productPrice.toInt(),
                      productName: sandwichProductData.productName,
                      productImage: sandwichProductData.productImage,
                    ),
                  ));
                },
                productPrice: sandwichProductData.productPrice.toInt(),
                productImage: sandwichProductData.productImage,
                productName: sandwichProductData.productName,
                productId: sandwichProductData.productId,
                productUnit: sandwichProductData,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMakloubProduct(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Makloub'),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Search(
                      search: productProvider?.getMakloubProductDataList ?? [], // Safe access and provide default value
                    ),
                  ));
                },
                child: const Text('view all', style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: (productProvider?.getMakloubProductDataList ?? []).map((makloubProductData) {
              return SingalProduct(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProductOverview(
                      productId: makloubProductData.productId,
                      productPrice: makloubProductData.productPrice.toInt(),
                      productName: makloubProductData.productName,
                      productImage: makloubProductData.productImage,
                    ),
                  ));
                },
                productPrice: makloubProductData.productPrice.toInt(),
                productImage: makloubProductData.productImage,
                productName: makloubProductData.productName,
                productId: makloubProductData.productId,
                productUnit: makloubProductData,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    ProductProvider initproductProvider = Provider.of<ProductProvider>(context, listen: false);
    initproductProvider.fatchPizzaProductData();
    initproductProvider.fatchSandwichProductData();
    initproductProvider.fatchMakloubProductData();
  }

  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    userProvider.getUserData();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: DrawerSide(userProvider: userProvider),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Home', style: TextStyle(color: Colors.black, fontSize: 17)),
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
              onTap: () {
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
                child: Icon(Icons.shop, size: 17, color: textColor),
              ),
            ),
          ),
        ],
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_ykQZjPH3OAQTXDTc1DOIwXODiAGlrYGJUCJsdikpVQ&s'),
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
                                decoration: const BoxDecoration(
                                  color: Color(0xffd1ad17),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(50),
                                    bottomLeft: Radius.circular(50),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'RajEat Test',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      shadows: [
                                        BoxShadow(
                                          color: Colors.green,
                                          blurRadius: 10,
                                          offset: Offset(3, 3),
                                        ),
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20),
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
                ),
              ),
              _buildPizzaProduct(context),
              _buildMakloubProduct(context),
              _buildSandwichProduct(context),
            ],
          ),
        ),
      ),
    );
  }
}
