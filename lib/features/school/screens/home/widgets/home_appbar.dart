import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safetracker/common/widgets/appbar/appbar.dart';
import 'package:safetracker/common/widgets/shimmers/shimmer.dart';
// import 'package:safetracker/data/repositories/authentication/auth_repository.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../personalization/controllers/settings_controller.dart';
import '../../../../personalization/controllers/user_controller.dart';
import '../../../../personalization/screens/profile/profile.dart';

class SHomeAppBar extends StatelessWidget {
  const SHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Just to create instance and fetch values
    // from the inherited widget
    Get.put(SettingsController());
    final userController = Get.put(UserController());

    // Ensure user details are fetched when the app bar is loaded
    if (userController.user.value.id == null || userController.user.value.id!.isEmpty) {
      // Ensure we fetch user details only if not already done
      userController.fetchUserDetails();
    }
    
    return SAppBar(
      title: GestureDetector(
        onTap: () =>  Get.to(() => const ProfileScreen()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(STexts.homeAppbarTitle, style: Theme.of(context).textTheme.labelMedium!.apply(color: SColors.grey)),
            Obx(
              () {
                // Check if user Profile is still loading
                if(userController.loading.value) {
                  // Display shimmer effect
                  return const SShimmerEffect(width: 80, height: 15);
                } else {
                  // Check if there any record found
                  if(userController.user.value.id!.isEmpty) {
                    // Display a message when no data is found
                    return Text(
                      'Your Name',
                      style: Theme.of(context).textTheme.headlineSmall!.apply(color: SColors.white),
                    );
                  }else {
                    // Display the user name
                    return Text(
                      userController.user.value.fullName,
                      style: Theme.of(context).textTheme.headlineSmall!.apply(color: SColors.white),
                    );
                  }
                }
              }
            ),
          ],
        ),
      ),
      //actions: const [SNotificationIcon()],
    );
  }
}