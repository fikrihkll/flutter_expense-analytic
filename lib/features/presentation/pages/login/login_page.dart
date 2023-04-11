
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_app/features/presentation/routes/route.dart' as route;
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/ic_apple.png", width: 24,),
                  const SizedBox(width: 16,),
                  Text("Login with Apple"),
                ],
              ),
              const SizedBox(height: 16,),
              GestureDetector(
                onTap: () {
                  // Invoke
                  _handleSignIn();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/ic_google.png", width: 24,),
                    const SizedBox(width: 16,),
                    Text("Login with Google"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
        ],
      );
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

}
