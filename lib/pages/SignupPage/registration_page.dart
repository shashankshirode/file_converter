// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, unused_field, unused_local_variable, avoid_print, body_might_complete_normally_nullable, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_converter/pages/SignupPage/header.dart';
import 'package:file_converter/utils/colors.dart';
import 'package:file_converter/utils/google_signin.dart';
import 'package:file_converter/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool _loggingIn = false;

  Future _register() async {
    setState(() {
      _loggingIn = true;
    });
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': userController.text.trim(),
        'email': emailController.text.trim(),
        'createdAt': DateTime.now(),
      });
      await _firebaseAuth.currentUser!
          .updateDisplayName(userController.text.trim());
      Navigator.popAndPushNamed(context, MyRoutes.homeRoute);
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
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RegistrationHeader(),
              SizedBox(height: 6 * space),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPaddingL),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(kPaddingM),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.12),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.12),
                            ),
                          ),
                          hintText: 'Name',
                          hintStyle: TextStyle(
                            color: kBlack.withOpacity(0.5),
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Icon(
                            Icons.person,
                            color: kBlack.withOpacity(0.5),
                          ),
                        ),
                        obscureText: false,
                        controller: userController,
                        textInputAction: TextInputAction.next,
                        validator: _validateName,
                        textCapitalization: TextCapitalization.words,
                      ),
                      SizedBox(height: space),
                      TextFormField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(kPaddingM),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.12),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.12),
                            ),
                          ),
                          hintText: 'Username',
                          hintStyle: TextStyle(
                            color: kBlack.withOpacity(0.5),
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Icon(
                            Icons.email,
                            color: kBlack.withOpacity(0.5),
                          ),
                        ),
                        obscureText: false,
                        controller: emailController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                      SizedBox(height: space),
                      TextFormField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(kPaddingM),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.12),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.12),
                            ),
                          ),
                          hintText: 'Password',
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
                        controller: passwordController,
                        textInputAction: TextInputAction.next,
                        validator: _validatePassword,
                      ),
                      SizedBox(height: 2 * space),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: double.infinity,
                        ),
                        child: FlatButton(
                          color: kBlue,
                          padding: const EdgeInsets.all(kPaddingM),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState != null &&
                                _formKey.currentState!.validate()) {
                              _register();
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: _loggingIn
                              ? CircularProgressIndicator()
                              : Text(
                                  "Register",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                          color: kWhite,
                                          fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                      SizedBox(height: 1.2 * space),
                      const Divider(
                        height: 15,
                        thickness: 1,
                        color: kBlack,
                      ),
                      SizedBox(height: 1.2 * space),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: double.infinity,
                        ),
                        child: OutlineButton(
                          onPressed: () {
                            signInWithGoogle(context);
                          },
                          color: kBlack,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: kPaddingL),
                                child: Image.asset(
                                  "assets/login_registration_images/google_logo.png",
                                  height: 48,
                                ),
                              ),
                              Text(
                                "Continue with Google",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      color: kBlack,
                                      fontWeight: FontWeight.bold,
                                    ),
                              )
                            ],
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
      ),
    );
  }

  String? _validateName(String? text) {
    if (text == null || text.trim().isEmpty) {
      return "This Field is required!";
    }
  }

  String? _validateEmail(String? text) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(pattern);
    if (text == null || text.trim().isEmpty) {
      return "This Field is required!";
    }
    if (!regExp.hasMatch(text)) {
      return "Enter correct email";
    }
  }

  String? _validatePassword(String? text) {
    if (text == null || text.trim().isEmpty) {
      return "This Field is required!";
    } else if (!RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(text)) {
      return "Password should have Uppercase, Lowercase, Numeric, Special Character";
    }
  }
}
