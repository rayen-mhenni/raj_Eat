import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:raj_eat/app/splash_screen/splash_screen.dart';
import 'package:raj_eat/firebase_options.dart';
import 'package:raj_eat/providers/cart_provider.dart';
import 'package:raj_eat/providers/check_out_provider.dart';
import 'package:raj_eat/providers/product_provider.dart';
import 'package:raj_eat/providers/review_cart_provider.dart';
import 'package:raj_eat/providers/user_provider.dart';
import 'package:raj_eat/providers/wishlist_provider.dart';
import 'package:raj_eat/repository/exceptions/firebase_notifaction_service.dart';
import 'package:raj_eat/repository/firebase_auth_service.dart';
import 'package:raj_eat/singin/login_page.dart';
import 'package:raj_eat/singup/sing_up_page.dart';
import 'package:raj_eat/config/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(FirebaseAuthService()))
      .catchError((error) {
    print("Error initializing Firebase: $error");
    // Handle the error here, such as showing an error dialog or logging the error
  });
  FirebaseNotificationService.setupFirebaseMessaging();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CartProvider>(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
        create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(create: (context) => ReviewCartProvider(),
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
        ),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Firebase',
        routes: {
          '/': (context) => const SplashScreen(
            // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
            child: LoginPage(),
          ),
          '/login': (context) => const LoginPage(),
          '/signUp': (context) => const SignUpPage(),
        },
      ),
    );
  }
}
