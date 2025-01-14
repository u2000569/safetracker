import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:safetracker/common/widgets/appbar/appbar.dart';
import 'package:safetracker/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:safetracker/common/widgets/texts/section_heading.dart';
import 'package:safetracker/features/personalization/controllers/user_controller.dart';
import 'package:safetracker/features/personalization/screens/profile/profile.dart';
import 'package:safetracker/home_menu.dart';
import 'package:safetracker/utils/constants/colors.dart';
import 'package:safetracker/utils/constants/sizes.dart';

import '../../../../common/widgets/list_tiles/settings_menu_tile.dart';
import '../../../../common/widgets/list_tiles/user_profile_tile.dart';
import '../address/address.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    
    return PopScope(
      canPop: false,
      // Intercept the back button press and redirect to the home screen
      onPopInvoked: (value) async => Get.offAll(const HomeMenu()),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              SPrimaryHeaderContainer(
                child: Column(
                  children: [
                    //Appbar
                    SAppBar(title: Text('Account', style: Theme.of(context).textTheme.headlineMedium!.apply(color: SColors.white))),

                    /// User Profile Card
                    SUserProfileTile(
                      onPressed: () => Get.to(() => const ProfileScreen()),
                      // scaffoldKey: GlobalKey<ScaffoldState>(),
                    ),
                    const SizedBox(height: SSizes.spaceBtwSections,),
                  ],
                )
              ),

              /// -- Profile Body
              Padding(
                padding: const EdgeInsets.all(SSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Account Settings
                    const SSectionHeading(title: 'Account Settings' , showActionButton: false,),
                    const SizedBox(height: SSizes.spaceBtwItems),
                    // SSettingsMenuTile(
                    //   icon: Iconsax.safe_home,
                    //   title: 'My Addresses',
                    //   subTitle: 'Set the address',
                    //   onTap: () => Get.to(() => const UserAddressScreen()),
                    // ),
                    // SSettingsMenuTile(icon: Iconsax.notification, title: 'Notifications', subTitle: 'Set the notification', onTap: (){},),

                    // App Settings
                    // const SizedBox(height: SSizes.spaceBtwSections),
                    // const SSectionHeading(title: 'App Settings', showActionButton: false),
                    // const SizedBox(height: SSizes.spaceBtwItems),

                    // SSettingsMenuTile(
                    //   icon: Iconsax.document_upload,
                    //   title: 'Load Data',
                    //   subTitle: 'Upload Data to your Cloud Firebase',
                    //   onTap: (){},
                    // ),

                    /// Logout Button
                    const SizedBox(height: SSizes.spaceBtwSections),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(onPressed: () => controller.logout(),child: const Text('Logout'),),
                    ),
                    const SizedBox(height: SSizes.spaceBtwSections * 2.5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}