// ignore_for_file: unused_local_variable

import 'package:file_converter/utils/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ConvertFromPDF extends StatefulWidget {
  const ConvertFromPDF({Key? key}) : super(key: key);

  @override
  State<ConvertFromPDF> createState() => _ConvertFromPDFState();
}

class _ConvertFromPDFState extends State<ConvertFromPDF> {
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
            height: MediaQuery.of(context).size.height - 100,
            child: GridView.count(
              padding: const EdgeInsets.only(top: 0.0),
              crossAxisCount: 2,
              primary: false,
              crossAxisSpacing: 20.0,
              childAspectRatio: 0.7,
              children: <Widget>[
                _buildCard(
                    "PDF to JPG",
                    "Convert each PDF page into a JPG image or extract all images contained in PDF",
                    "assets/homepage_images/image.png",
                    context),
                _buildCard(
                    "PDF to Word",
                    "Easily convert your PDF files into easy to edit DOC and DOCX documents",
                    "assets/homepage_images/word.png",
                    context),
                _buildCard(
                    "PDF to PPT",
                    "Turn your PDF files into easy to edit PPT and PPTX slideshows",
                    "assets/homepage_images/powerpoint.png",
                    context),
                _buildCard(
                    "PDF to Excel",
                    "Pull data straight from PDFs into Excel spreadsheet in a few short seconds",
                    "assets/homepage_images/excel.png",
                    context),
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
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['jpg'],
              );
              break;
            case "Word to PDF":
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['doc', 'docx'],
              );
              break;
            case "PPT to PDF":
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['ppt', 'pptx'],
              );
              break;
            case "Excel to PDF":
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['xls', 'xlsx'],
              );
              break;
            case "HTML to PDF":
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['html'],
              );
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
}
