// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers

import 'package:file_converter/pages/HomePage/convert_from_pdf.dart';
import 'package:file_converter/pages/HomePage/convert_to_pdf.dart';
import 'package:file_converter/utils/colors.dart';
import 'package:file_converter/widgets/drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    var space = height > 650 ? kSpaceM : kSpaceS;

    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: <Color>[
              Colors.blue.shade900,
              Colors.blue.shade600,
              Colors.blue.shade400
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 6 * space),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1 * kPaddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "File Converter",
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                          color: kWhite,
                          fontSize: 45,
                        ),
                  ),
                  Text(
                    "All in one file converter",
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: kWhite.withOpacity(0.5),
                          fontSize: 25,
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3 * space),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: DefaultTabController(
                        length: 2,
                        child: Column(
                          children: <Widget>[
                            TabBar(
                              controller: _tabController,
                              tabs: [
                                Tab(
                                  child: Text(
                                    "Convert to PDF",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5!
                                        .copyWith(
                                          color: kBlack,
                                          fontSize: 18,
                                        ),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    "Convert from PDF",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5!
                                        .copyWith(
                                          color: kBlack,
                                          fontSize: 18,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height - 180,
                              width: double.infinity,
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  ConvertToPDF(),
                                  ConvertFromPDF(),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}
