import 'package:file_converter/utils/colors.dart';
import 'package:flutter/material.dart';

class RegistrationHeader extends StatelessWidget {
  const RegistrationHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: kSpaceM),
          Text(
            "Welcome !",
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: kBlack, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: kSpaceS),
          Text(
            "Register to the App so that you can enjoy latest features",
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: kBlack.withOpacity(0.5)),
          )
        ],
      ),
    );
  }
}
