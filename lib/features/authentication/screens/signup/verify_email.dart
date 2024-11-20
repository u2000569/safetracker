import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safetracker/common/widgets/appbar/appbar.dart';
import 'package:safetracker/data/repositories/authentication/auth_repository.dart';
import 'package:safetracker/utils/constants/image_strings.dart';
import 'package:safetracker/utils/constants/sizes.dart';
import 'package:safetracker/utils/constants/text_strings.dart';
import 'package:safetracker/utils/helpers/helper_functions.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(VerifyEmailController());
      
    return Scaffold(
      /// Appbar close icon will first Logout the user & then redirect back to Login Screen()
      /// Reason: We will store the data when user enters the Register Button on Previous screen.
      /// Whenever the user opens the app, we will check if email is verified or not.
      /// If not verified we will always show this Verification screen.
      appBar: SAppBar(
        actions: [IconButton(onPressed: () => AuthenticationRepository.instance.logout(), icon: const Icon(CupertinoIcons.clear))],

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SSizes.defaultSpace),
          child: Column(
            children: [
              // Image
              Image(
                image: const AssetImage(SImages.deliveredEmailIllustration),
                width: SHelperFunctions.screenWidth() *0.6,
              ),
              const SizedBox(height: SSizes.spaceBtwSections),

              // Title, Email and Subtitle
              Text(STexts.confirmEmail, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center ,),
              const SizedBox(height: SSizes.spaceBtwItems),
              Text(email ?? '', style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center ,),
              const SizedBox(height: SSizes.spaceBtwItems),
              Text(STexts.confirmEmailSubTitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
              const SizedBox(height: SSizes.spaceBtwSections,)
            ],
          ),
        ),
      ),
    );
  }
}