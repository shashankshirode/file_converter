// ignore_for_file: avoid_print

import 'dart:io';

import 'package:file_converter/utils/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class ConvertToPDF extends StatefulWidget {
  const ConvertToPDF({Key? key}) : super(key: key);

  @override
  State<ConvertToPDF> createState() => _ConvertToPDFState();
}

class _ConvertToPDFState extends State<ConvertToPDF> {
  FilePickerResult? result;
  PlatformFile? platformFile;
  var pdf = pw.Document();
  bool loading = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? user;
  String? userID;

  @override
  initState() {
    super.initState();
    initUser();
  }

  initUser() async {
    user = _firebaseAuth.currentUser!;
    userID = user!.uid;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: ListView(
        padding: const EdgeInsets.only(top: 0.0),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 15.0, bottom: 30),
            width: MediaQuery.of(context).size.width - 30,
            height: MediaQuery.of(context).size.height - 10,
            child: GridView.count(
              padding: const EdgeInsets.only(top: 0.0),
              crossAxisCount: 2,
              primary: false,
              crossAxisSpacing: 20.0,
              childAspectRatio: 0.8,
              children: <Widget>[
                _buildCard(
                  "JPG to PDF",
                  "Convert JPG image to PDF in seconds",
                  "assets/homepage_images/image.png",
                  context,
                ),
                _buildCard(
                  "Word to PDF",
                  "Make docx and doc files easy to read by converting them to PDF",
                  "assets/homepage_images/word.png",
                  context,
                ),
                _buildCard(
                  "PPT to PDF",
                  "Make PPT and PPTX files easy to read by converting them to PDF",
                  "assets/homepage_images/powerpoint.png",
                  context,
                ),
                _buildCard(
                  "Excel to PDF",
                  "Make excel sheets easy to read by converting them to PDF",
                  "assets/homepage_images/excel.png",
                  context,
                ),
                _buildCard("HTML to PDF", "Convert webpages in HTML to PDF",
                    "assets/homepage_images/html5.png", context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String name, String desc, String imgPath, context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 15.0, bottom: 5.0, left: 5.0, right: 5.0),
      child: InkWell(
        onTap: () async {
          switch (name) {
            case "JPG to PDF":
              result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['jpg', 'jpeg', 'png'],
              );
              if (result != null) {
                platformFile = result!.files.first;
                setState(() {});
                _showModal(platformFile, "JPG");
              }
              break;
            case "Word to PDF":
              break;
            case "PPT to PDF":
              break;
            case "Excel to PDF":
              break;
            case "HTML to PDF":
              break;
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: imgPath,
                        child: Container(
                          height: 85,
                          width: 85,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                imgPath,
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    name,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: kBlack,
                        ),
                  ),
                  Text(
                    desc,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: kBlack.withOpacity(0.5),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showModal(PlatformFile? file, String sourceExt) {
    final kb = file!.size / 1024;
    final mb = kb / 1024;
    final size = (mb >= 1)
        ? '${mb.toStringAsFixed(2)} MB'
        : '${kb.toStringAsFixed(2)} KB';
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          height: 330.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('File Name: ${file.name}',
                    style: const TextStyle(
                      fontSize: 16,
                    )),
                const SizedBox(height: 10),
                Text('File Size: $size',
                    style: const TextStyle(
                      fontSize: 16,
                    )),
                const SizedBox(height: 10),
                Text('File Extension: ${file.extension}',
                    style: const TextStyle(
                      fontSize: 16,
                    )),
                const SizedBox(height: 10),
                Text('File Path: ${file.path}',
                    style: const TextStyle(
                      fontSize: 16,
                    )),
                const SizedBox(
                  height: 40,
                ),
                Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      _startConversion(file, sourceExt);
                    },
                    child: const Text("Proceed to Convert"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _imageToPDF(PlatformFile? file) async {
    setState(() {
      loading = true;
    });
    var myFile = File(file!.path.toString());
    final _image = pw.MemoryImage(myFile.readAsBytesSync());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(_image),
          ); // Center
        },
      ),
    );
    savePDF(file.name.toString());
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

  Future<void> savePDF(String? fileName) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          color: Colors.transparent,
          height: 300,
          child: Dialog(
              child: Stack(
            alignment: FractionalOffset.center,
            children: const <Widget>[
              CircularProgressIndicator(),
            ],
          )),
        );
      },
    );
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          print(directory!.path);
          String newPath = "";
          List<String> folders = directory.path.split("/");
          for (int x = 1; x < folders.length; x++) {
            String folder = folders[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/App Converter/$userID";
          directory = Directory(newPath);
          print("-------------------------------------");
          print(directory.path);
        }
      }

      if (!await directory!.exists()) {
        await directory.create(recursive: true);
      }

      if (await directory.exists()) {
        File saveFile = File(directory.path + "/${fileName}_converted.pdf");
        await saveFile.writeAsBytes(await pdf.save());
        await Future.delayed(const Duration(seconds: 2), () {});
        pdf = pw.Document();
        Fluttertoast.showToast(msg: "Success");
        Navigator.pop(context);
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  _startConversion(PlatformFile? file, String sourceExt) {
    Navigator.pop(context);
    _imageToPDF(file);
  }
}
