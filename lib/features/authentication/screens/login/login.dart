import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/styles/spacing_styles.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import 'widgets/login_form.dart';
import 'widgets/login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: SSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              ///  Header
               SLoginHeader(),

              /// Form
               SLoginForm(),

              /// Divider
              // SFormDivider(dividerText: STexts.orSignInWith.capitalize!),
              // const SizedBox(height: SSizes.spaceBtwSections),

              /// Footer
              // const SSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
