import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:raj_eat/app/splash_screen/splash_screen.dart';
import 'package:raj_eat/firebase_options.dart';
import 'package:raj_eat/providers/check_out_provider.dart';
import 'package:raj_eat/providers/product_provider.dart';
import 'package:raj_eat/providers/review_cart_provider.dart';
import 'package:raj_eat/providers/user_provider.dart';
import 'package:raj_eat/providers/wishlist_provider.dart';
import 'package:raj_eat/repository/firebase_auth_service.dart';
import 'package:raj_eat/singin/login_page.dart';
import 'package:raj_eat/singup/sing_up_page.dart';
import 'package:raj_eat/config/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    Get.put(FirebaseAuthService());
  } catch (error) {
    print("Error initializing Firebase: $error");
    // Handle the error here, such as showing an error dialog or logging the error
    // You may want to terminate the app or retry the initialization
    return;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider<ReviewCartProvider>(
          create: (context) => ReviewCartProvider(),
        ),
        ChangeNotifierProvider<WishListProvider>(
          create: (context) => WishListProvider(),
        ),
        ChangeNotifierProvider<CheckoutProvider>(
          create: (context) => CheckoutProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: primaryColor,
          scaffoldBackgroundColor: scaffoldBackgroundColor,
          // Optionally define more theme properties here
        ),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Firebase',
        routes: {
          '/': (context) => const SplashScreen(
            // Decide whether to show LoginPage or HomePage based on user authentication
            child: LoginPage(),
          ),
          '/login': (context) => const LoginPage(),
          '/signUp': (context) => const SignUpPage(),
        },
      ),
    );
  }
}
