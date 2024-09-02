import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raj_eat/screens/home/admin_screen.dart';
import 'package:raj_eat/screens/home/delivery_screens.dart';
import 'package:raj_eat/screens/home/home_screen.dart';
import 'package:raj_eat/singup/forgot_password_page.dart';
import 'package:raj_eat/singup/sing_up_page.dart';
import '../providers/user_provider.dart';
import '../repository/firebase_auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<LoginPage> {
  late UserProvider userProvider;
  bool _isSigning = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'RajEat',
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                      shadows: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.green.shade900,
                          offset: const Offset(3, 3),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () async {
                _signIn();
              },
              child: Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: _isSigning
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text(
                    "Sign in",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () async {
                _signInWithGoogle();
              },
              child: Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.google,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Sign in with Google",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                );
              },
              child: const Text(
                "Mot de passe oublié?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()),
                          (route) => false,
                    );
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _signIn() async {
    setState(() {
      _isSigning = true;
    });
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    User? user = await _authService.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      String? role = await _authService.getUserRole(user.uid);

      if (role != null) {
        userProvider.addUserData(
          currentUser: user,
          userEmail: user.email ?? '',
          userImage: user.photoURL ?? '',
          userName: user.displayName ?? '',
          role: role,
        );

        if (role == 'admin') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminScreen()),
          );
        }
       else if (role == 'delivery') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DeliveryScreen()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      }
    } else {
      const snackBar = SnackBar(
        content: Text('Invalid email or password'),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  _signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
        User? user = userCredential.user;

        if (user != null) {
          String? role = await _authService.getUserRole(user.uid);

          if (role != null) {
            userProvider.addUserData(
              currentUser: user,
              userEmail: user.email ?? '',
              userImage: user.photoURL ?? '',
              userName: user.displayName ?? '',
              role: role,
            );

            if (role == 'admin') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminScreen()),
              );
            }else if (role == 'delivery') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DeliveryScreen()),
              );
            }
            else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            }
          }
        }
      }
    } catch (e) {
      const snackBar = SnackBar(
        content: Text('Some error occurred'),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
