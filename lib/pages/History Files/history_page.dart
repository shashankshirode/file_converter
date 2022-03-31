// ignore_for_file: avoid_print

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Directory? directory;
  List<FileSystemEntity> _folders = [];
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  User? user;
  String? userID;

  @override
  initState() {
    super.initState();
    initUser();
    _getDirectory();
  }

  initUser() async {
    user = _firebaseAuth.currentUser!;
    userID = user!.uid;
    setState(() {});
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<void> _getDirectory() async {
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          var systemDir =
              Directory("/storage/emulated/0/App Converter/$userID");
          setState(() {
            _folders = systemDir.listSync(recursive: true, followLinks: false);
          });
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    setState(() {});
  }

  String _getFileName(String? path) {
    final List<String> newName = path!.split('/');
    return newName.last;
  }

  Future<void> shareFile(String? path, String? fileName) async {
    try {
      Share.shareFiles(['$path'], text: '$fileName', subject: '$fileName');
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> deleteFile(String path) async {
    final newFile = File(path);
    try {
      newFile.delete();
      Fluttertoast.showToast(msg: "File deleted!");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future uploadFile(String? path, String fileName) async {
    final File selectedFile = File(path!);
    final destination = '$userID';
    try {
      Reference reference = _storage.ref(destination).child(fileName);
      UploadTask uploadTask = reference.putFile(selectedFile);
      await uploadTask.whenComplete(
        () => {
          Fluttertoast.showToast(msg: "Upload completed!"),
        },
      );
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      appBar: AppBar(
        title: const Text("Processed Files"),
      ),
      body: (_folders.isEmpty)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Center(
                  child: Text(
                    "Files not found!",
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _folders.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(IconData(
                            0xe342,
                            fontFamily: 'MaterialIcons',
                          )),
                          trailing: PopupMenuButton<int>(
                            icon: const Icon(Icons.more_vert),
                            color: Colors.white,
                            itemBuilder: (context) => [
                              PopupMenuItem<int>(
                                value: 1,
                                child: InkWell(
                                  child: Row(children: const [
                                    Icon(Icons.open_in_new),
                                    SizedBox(width: 10),
                                    Text("Open"),
                                  ]),
                                  onTap: () {
                                    OpenFile.open(_folders[index].path);
                                  },
                                ),
                              ),
                              PopupMenuItem<int>(
                                value: 2,
                                child: InkWell(
                                  child: Row(
                                    children: const [
                                      Icon(Icons.share),
                                      SizedBox(width: 10),
                                      Text("Share"),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  shareFile(_folders[index].path,
                                      _getFileName(_folders[index].path));
                                },
                              ),
                              PopupMenuItem<int>(
                                value: 3,
                                child: InkWell(
                                  child: Row(
                                    children: const [
                                      Icon(Icons.delete),
                                      SizedBox(width: 10),
                                      Text("Delete"),
                                    ],
                                  ),
                                  onTap: () {
                                    deleteFile(_folders[index].path);
                                  },
                                ),
                              ),
                              PopupMenuItem<int>(
                                value: 4,
                                child: InkWell(
                                  child: Row(
                                    children: const [
                                      Icon(Icons.upload),
                                      SizedBox(width: 10),
                                      Text("Upload"),
                                    ],
                                  ),
                                  onTap: () {
                                    uploadFile(_folders[index].path,
                                        _getFileName(_folders[index].path));
                                  },
                                ),
                              ),
                            ],
                          ),
                          title: Text(_getFileName(_folders[index].path)),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
