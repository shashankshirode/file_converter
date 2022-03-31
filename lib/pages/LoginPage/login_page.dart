// ignore_for_file: unused_local_variable, avoid_print, deprecated_member_use

import 'package:file_converter/pages/HomePage/home_page.dart';
import 'package:file_converter/pages/SignupPage/registration_page.dart';
import 'package:file_converter/utils/colors.dart';
import 'package:file_converter/utils/google_signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loggingIn = false;

  Future _verifyEmail() async {
    setState(() {
      _loggingIn = true;
    });
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: usernameController.text.trim(),
        password: passwordController.text.trim(),
      );
      print("--------------------------");
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return const HomePage();
      }));
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      _scaffoldKey.currentState!.removeCurrentSnackBar();
      _scaffoldKey.currentState!.showSnackBar(SnackBar(
        content: Text(e.message.toString()),
      ));
    } finally {
      setState(() {
        _loggingIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    var space = height > 650 ? kSpaceM : kSpaceS;

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: space),
                Text("Welcome back!",
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(color: kBlack, fontWeight: FontWeight.bold)),
                const SizedBox(height: kSpaceM),
                Text(
                  "A tool you need to work with in one place. Let's get Started!",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: kBlack.withOpacity(0.5)),
                ),
                SizedBox(height: 7 * space),
                Form(
                  child: Column(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(kPaddingM),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: kBlack.withOpacity(0.12)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.12),
                            ),
                          ),
                          hintText: "Username",
                          hintStyle: TextStyle(
                            color: kBlack.withOpacity(0.5),
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Icon(
                            Icons.mail,
                            color: kBlack.withOpacity(0.5),
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        autofocus: true,
                      ),
                      SizedBox(height: space),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(kPaddingM),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: kBlack.withOpacity(0.12)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.12),
                            ),
                          ),
                          hintText: "Password",
                          hintStyle: TextStyle(
                            color: kBlack.withOpacity(0.5),
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: kBlack.withOpacity(0.5),
                          ),
                        ),
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                      ),
                      SizedBox(height: space),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: double.infinity,
                        ),
                        child: FlatButton(
                          color: kBlue,
                          padding: const EdgeInsets.all(kPaddingM),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            _verifyEmail();
                          },
                          child: _loggingIn
                              ? const CircularProgressIndicator()
                              : Text(
                                  "Login to continue",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        color: kWhite,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 1.2 * space),
                const Divider(
                  height: 15,
                  thickness: 1,
                  color: kBlack,
                ),
                SizedBox(height: 1.2 * space),
                OutlineButton(
                  onPressed: () {
                    signInWithGoogle(context);
                  },
                  color: kWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: kPaddingL),
                        child: Image.asset(
                          "assets/login_registration_images/google_logo.png",
                          height: 48.0,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Continue with Google",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  color: kBlack.withOpacity(0.5),
                                  fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: space),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: double.infinity,
                  ),
                  child: FlatButton(
                    color: kBlack,
                    padding: const EdgeInsets.all(kPaddingM),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistrationPage(),
                        ),
                      );
                    },
                    child: Text("Create an account",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: kWhite, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
