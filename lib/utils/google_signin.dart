// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_converter/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      // Getting users credential
      UserCredential? result =
          await FirebaseAuth.instance.signInWithCredential(authCredential);
      if (result != null) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(result.user!.uid)
            .set({
          'name': result.user!.displayName,
          'email': result.user!.email,
          'createdAt': DateTime.now(),
        });
        Navigator.popAndPushNamed(context, MyRoutes.homeRoute);
      } else {
        Fluttertoast.showToast(msg: "Error while signing with Google");
      }
    }
  } catch (e) {
    Fluttertoast.showToast(msg: e.toString());
  }
}
