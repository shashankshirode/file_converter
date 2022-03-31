// ignore_for_file: use_key_in_widget_constructors
import 'package:file_converter/pages/LoginPage/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class IntroPage extends StatelessWidget {
  final List<PageViewModel> pages = [
    PageViewModel(
      title: 'Convert File',
      body: 'Easily convert your files on a tap',
      image: SvgPicture.asset("assets/intro_images/convert_file_svg.svg",
          semanticsLabel: 'Convert file Logo'),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
        titlePadding: EdgeInsets.only(top: 70),
        imagePadding: EdgeInsets.only(top: 100, right: 50, left: 50),
      ),
    ),
    PageViewModel(
      title: 'Share Converted File',
      body: 'Share your customized files to your belongings',
      image: SvgPicture.asset("assets/intro_images/share_file.svg",
          semanticsLabel: 'Share file Logo'),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
        titlePadding: EdgeInsets.only(top: 70),
        imagePadding: EdgeInsets.only(top: 100, right: 50, left: 50),
      ),
    ),
    PageViewModel(
      title: 'Upload File to cloud',
      body: 'Upload your files to your cloud account',
      image: SvgPicture.asset("assets/intro_images/upload_file_to_cloud.svg",
          semanticsLabel: 'Share file Logo'),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
        titlePadding: EdgeInsets.only(top: 70),
        imagePadding: EdgeInsets.only(top: 100, right: 50, left: 50),
      ),
    ),
    PageViewModel(
      title: 'Download Files from cloud',
      body: 'Download your files from your cloud account',
      image: SvgPicture.asset(
          "assets/intro_images/download_file_from_cloud.svg",
          semanticsLabel: 'Share file Logo'),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
        titlePadding: EdgeInsets.only(top: 70),
        imagePadding: EdgeInsets.only(top: 100, right: 50, left: 50),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IntroductionScreen(
        pages: pages,
        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: Colors.blue,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
        showDoneButton: true,
        done: const Text('Done', style: TextStyle(fontSize: 20.0)),
        showSkipButton: true,
        skip: const Text('Skip', style: TextStyle(fontSize: 20.0)),
        showNextButton: true,
        next: const Icon(
          Icons.arrow_forward,
          size: 25.0,
        ),
        onDone: () => onDone(context),
        animationDuration: 200,
        isBottomSafeArea: true,
        curve: Curves.bounceOut,
      ),
    );
  }
}

void onDone(context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('INTRODUCTION', false);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
  );
}
