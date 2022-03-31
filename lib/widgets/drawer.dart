import 'package:file_converter/utils/colors.dart';
import 'package:file_converter/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? userName;
  String? userEmail;
  User? user;

  @override
  void initState() {
    super.initState();
    initUser();
  }

  initUser() async {
    user = _firebaseAuth.currentUser!;
    setState(() {
      userName = user!.displayName;
      userEmail = user!.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Container(
          color: kWhite,
          child: ListView(
            children: [
              DrawerHeader(
                padding: EdgeInsets.zero,
                child: UserAccountsDrawerHeader(
                  margin: EdgeInsets.zero,
                  accountName: Text("${user!.displayName}"),
                  accountEmail: Text("${user!.email}"),
                  currentAccountPicture: const CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(
                  IconData(
                    0xea16,
                    fontFamily: 'MaterialIcons',
                  ),
                ),
                title: const Text(
                  "Home",
                  textScaleFactor: 1.2,
                ),
                onTap: () {},
              ),
              Divider(
                height: 2,
                color: kBlack.withOpacity(0.1),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 8),
                child: Text(
                  "File Conversions",
                  style:
                      TextStyle(fontSize: 15, color: kBlack.withOpacity(0.4)),
                ),
              ),
              ListTile(
                  leading:
                      const Icon(IconData(0xe314, fontFamily: 'MaterialIcons')),
                  title: const Text(
                    "Processed Files",
                    textScaleFactor: 1.2,
                    style: TextStyle(color: kBlack),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, MyRoutes.processedFiles);
                  }),
              ListTile(
                  leading: const Icon(
                    IconData(0xf745, fontFamily: 'MaterialIcons'),
                  ),
                  title: const Text(
                    "View Files",
                    textScaleFactor: 1.2,
                    style: TextStyle(color: kBlack),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, MyRoutes.firebaseFiles);
                  }),
              Divider(
                height: 2,
                color: kBlack.withOpacity(0.1),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 8),
                child: Text(
                  "Privacy",
                  style:
                      TextStyle(fontSize: 15, color: kBlack.withOpacity(0.4)),
                ),
              ),
              ListTile(
                leading: const Icon(
                  IconData(
                    0xe57f,
                    fontFamily: 'MaterialIcons',
                  ),
                ),
                title: const Text(
                  "Settings",
                  textScaleFactor: 1.2,
                  style: TextStyle(color: kBlack),
                ),
                onTap: () {
                  Navigator.pushNamed(context, MyRoutes.accountSettingsRoute);
                },
              ),
              const ListTile(
                leading: Icon(IconData(0xea37, fontFamily: 'MaterialIcons')),
                title: Text(
                  "About us",
                  textScaleFactor: 1.2,
                  style: TextStyle(color: kBlack),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: Text(
                      'Version 1.0.0',
                      style: TextStyle(color: kBlack.withOpacity(0.7)),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
