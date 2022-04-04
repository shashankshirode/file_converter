// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:file_converter/pages/Cloud%20Files/file_detail.dart';
import 'package:file_converter/pages/Cloud%20Files/firebase_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class CloudFiles extends StatefulWidget {
  const CloudFiles({Key? key}) : super(key: key);

  @override
  State<CloudFiles> createState() => _CloudFilesState();
}

class _CloudFilesState extends State<CloudFiles> {
  String pageTitle = "Cloud Files";
  late Future<List<FirebaseFile>> futureFiles;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? user;
  String? userID;

  @override
  initState() {
    super.initState();
    initUser();
    futureFiles = FirebaseApi.listAll(userID!);
  }

  initUser() async {
    user = _firebaseAuth.currentUser!;
    userID = user!.uid;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pageTitle)),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<FirebaseFile>>(
                future: futureFiles,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    default:
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text('Some error occurred!'));
                      } else {
                        final files = snapshot.data!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildHeader(files.length),
                            const SizedBox(height: 12),
                            Expanded(
                              child: ListView.builder(
                                itemCount: files.length,
                                itemBuilder: (context, index) {
                                  final file = files[index];
                                  return buildFile(context, file);
                                },
                              ),
                            ),
                          ],
                        );
                      }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFile(BuildContext context, FirebaseFile file) => ListTile(
        leading: const Icon(
          IconData(
            0xe342,
            fontFamily: 'MaterialIcons',
          ),
        ),
        title: Text(
          file.name,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: () {
          OpenFile.open(file.url.trim());
        },
        trailing: PopupMenuButton<int>(
          icon: const Icon(Icons.more_vert),
          color: Colors.white,
          itemBuilder: (context) => [
            PopupMenuItem<int>(
              value: 1,
              child: InkWell(
                child: Row(children: const [
                  Icon(Icons.download_for_offline),
                  SizedBox(width: 10),
                  Text("Save as Offline"),
                ]),
                onTap: () {
                  String url =
                      "http://www.africau.edu/images/default/sample.pdf";
                },
              ),
            ),
            PopupMenuItem<int>(
              value: 2,
              child: InkWell(
                child: Row(children: const [
                  Icon(Icons.delete_forever_outlined),
                  SizedBox(width: 10),
                  Text("Delete"),
                ]),
                onTap: () {},
              ),
            ),
          ],
        ),
      );

  Widget buildHeader(int length) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: length != 0
          ? Text(
              "$length files are available in your account",
              style: const TextStyle(fontSize: 16),
            )
          : Expanded(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 250,
                    ),
                    const Text(
                      "No files found!",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
