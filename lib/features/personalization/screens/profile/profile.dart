import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:safetracker/common/widgets/appbar/appbar.dart';
import 'package:safetracker/utils/constants/image_strings.dart';
import 'package:safetracker/utils/constants/sizes.dart';

import '../../../../common/widgets/images/s_circular_image.dart';
import '../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../controllers/user_controller.dart';
import 'change_name.dart';
import 'widgets/profile_menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: SAppBar(
        showBackArrow: true,
        title: Text('Profile', style: Theme.of(context).textTheme.headlineSmall,),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Obx(
                      () {
                        final networkImage = controller.user.value.profilePicture;
                        final image = networkImage.isNotEmpty ? networkImage : SImages.user;
                        return controller.imageUploading.value
                            ? const SShimmerEffect(width: 80, height: 80, radius: 80)
                            : SCircularImage(image: image, width: 80, height: 80, isNetworkImage: networkImage.isNotEmpty);
                      }
                    ),
                    TextButton(
                      onPressed: controller.imageUploading.value ? () {} : () => controller.uploadUserProfilePicture(), 
                      child: const Text('Change Profile Picture'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SSizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: SSizes.spaceBtwItems),
              const SSectionHeading(title: 'Profile Information', showActionButton: false),
              const SizedBox(height: SSizes.spaceBtwItems),
              SProfileMenu(onPressed: () => Get.to(() => const ChangeName()), title: 'Name', value: controller.user.value.fullName,),
              const SizedBox(height: SSizes.spaceBtwItems),

              const Divider(),
              const SizedBox(height: SSizes.spaceBtwItems),
              const SSectionHeading(title: 'Personal Information', showActionButton: false),
              const SizedBox(height: SSizes.spaceBtwItems),
              SProfileMenu(onPressed: () {}, title: 'Email', value: controller.user.value.email),
              SProfileMenu(onPressed: (){}, title: 'Phone Number', value: controller.user.value.phoneNumber),
              // SProfileMenu(onPressed: (){}, title: 'Date of Birth', value: controller.user.value.dateOfBirth),

              const Divider(),
              const SizedBox(height: SSizes.spaceBtwItems),
              Center(
                child: TextButton(
                  onPressed: () => controller.deleteAccountWarningPopup(),
                  child: const Text('Close Account', style: TextStyle(color: Colors.red)),
                ),
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}