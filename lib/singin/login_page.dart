import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raj_eat/screens/home/home_screen.dart';

import 'package:raj_eat/singup/sing_up_page.dart';

import '../providers/user_provider.dart';
import '../repository/firebase_auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';


class LoginPage extends StatefulWidget {

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<LoginPage> {
  late UserProvider userProvider;

  bool _isSigning = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
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

      body: Container(

        height: double.infinity,
        width: double.infinity,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
        Container(
          height: 200,
          width: double.infinity,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
          Text(
            'RajEat',
            style:
            TextStyle(fontSize: 50, color: Colors.white, shadows: [
              BoxShadow(
                blurRadius: 5,
                color: Colors.green.shade900,
                offset: Offset(3, 3),
              )
            ]),
          ),
              ],
          ),
        ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 32.0),
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
                    child: _isSigning ? CircularProgressIndicator(
                      color: Colors.white,) : Text(
                      "Sign in",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
              ),
            ),

            SizedBox(height: 32.0),
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
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.google, color: Colors.white,),
                    SizedBox(width: 5,),
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
            SizedBox(
              height: 20,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                          (route) => false,
                    );
                  },
                  child: Text(
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

    // Call your authentication service to sign in
    User? user = await _authService.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSigning = false;
    });
    if (user != null) {
      userProvider.addUserData(
        currentUser: user,
        userEmail: user.email??'',
        userImage: user.photoURL??'',
        userName: user.displayName??'',
      );
      // Navigate to the next screen after successful sign-in
      Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()),);
    } else {
      // Show a snackbar for unsuccessful sign-in
      final snackBar = SnackBar(
        content: Text('Invalid email or password'),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  _signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn
          .signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await
        googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );


        await _firebaseAuth.signInWithCredential(credential);
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()),);
      }
    } catch (e) {
      // Show a snackbar for unsuccessful sign-in
      final snackBar = SnackBar(
        content: Text('some error occured'),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

