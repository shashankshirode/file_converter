import 'package:file_converter/utils/colors.dart';
import 'package:file_converter/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    initUser();
  }

  initUser() async {
    user = _firebaseAuth.currentUser!;
    setState(() {});
  }

  _changePasswordModal(context) {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    final _formKey = GlobalKey<FormState>();

    String? _validatePassword(String? text) {
      if (text == null || text.trim().isEmpty) {
        return "This Field is required!";
      } else if (!RegExp(
              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
          .hasMatch(text)) {
        return "Password should have Uppercase, Lowercase, Numeric, Special Character";
      }
      return null;
    }

    String? _validateConfirmPassword(String? text) {
      if (text == null || text.trim().isEmpty) {
        return "This Field is required!";
      } else if (passwordController.text.trim() != text) {
        return "Password is not matching!";
      }
      return null;
    }

    Future _changePassword() async {
      try {
        user!
            .updatePassword(passwordController.text.trim())
            .then(
              (value) => Fluttertoast.showToast(msg: "Password changed!"),
            )
            .catchError((err) {
          Fluttertoast.showToast(msg: "$err");
        });
      } catch (e) {
        Fluttertoast.showToast(msg: "$e");
      }
      Navigator.pop(context);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 350),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text("Forgot Password"),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(kPaddingM),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kBlack.withOpacity(0.12)),
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(
                              color: kBlack.withOpacity(0.5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          validator: _validatePassword,
                          obscureText: true,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: confirmPasswordController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(kPaddingM),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kBlack.withOpacity(0.12)),
                            ),
                            hintText: "Confirm Password",
                            hintStyle: TextStyle(
                              color: kBlack.withOpacity(0.5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          validator: _validateConfirmPassword,
                          obscureText: true,
                        ),
                        const SizedBox(height: 55),
                        ElevatedButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState != null &&
                                _formKey.currentState!.validate()) {
                              _changePassword();
                            }
                          },
                          child: const Text("Proceed"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        color: kWhite,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: kWhite,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                          ),
                        )
                      ],
                    ),
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                          "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Shashank Shirode",
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: kBlack),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      "shashankshirode@gmail.com",
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: kBlack.withOpacity(0.6),
                            fontSize: 14,
                          ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ConstrainedBox(
                      constraints:
                          const BoxConstraints.tightFor(width: 180, height: 40),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(kBlue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        child: const Text("Upgrade to PRO"),
                      ),
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    ConstrainedBox(
                      constraints:
                          const BoxConstraints.tightFor(width: 320, height: 47),
                      child: ElevatedButton(
                        onPressed: () {
                          _changePasswordModal(context);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color?>(
                              Colors.grey[200]),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        child: Row(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Icon(
                              Icons.lock_open_sharp,
                              color: kBlack,
                            ),
                            const SizedBox(width: 25),
                            const Text(
                              "Change Password",
                              style: TextStyle(color: kBlack, fontSize: 16),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: kBlack,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ConstrainedBox(
                      constraints:
                          const BoxConstraints.tightFor(width: 320, height: 47),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color?>(
                              Colors.grey[200]),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        child: Row(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Icon(
                              Icons.question_answer,
                              color: kBlack,
                            ),
                            const SizedBox(width: 25),
                            const Text(
                              "Help & Support",
                              style: TextStyle(color: kBlack, fontSize: 16),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: kBlack,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ConstrainedBox(
                      constraints:
                          const BoxConstraints.tightFor(width: 320, height: 47),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color?>(
                              Colors.grey[200]),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        child: Row(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Icon(
                              Icons.share,
                              color: kBlack,
                            ),
                            const SizedBox(width: 25),
                            const Text(
                              "Invite a Friend",
                              style: TextStyle(color: kBlack, fontSize: 16),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: kBlack,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ConstrainedBox(
                      constraints:
                          const BoxConstraints.tightFor(width: 320, height: 47),
                      child: ElevatedButton(
                        onPressed: () async {
                          await _firebaseAuth.signOut();
                          Navigator.pushNamed(context, MyRoutes.introRoute);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color?>(
                              Colors.grey[200]),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        child: Row(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Icon(
                              Icons.logout_sharp,
                              color: kBlack,
                            ),
                            const SizedBox(width: 25),
                            const Text(
                              "Logout",
                              style: TextStyle(color: kBlack, fontSize: 16),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: kBlack,
                                  ),
                                ],
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
          ),
        ),
      ),
    );
  }
}
