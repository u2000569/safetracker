import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../../../features/personalization/controllers/user_controller.dart';
import '../../../utils/constants/image_strings.dart';
import '../images/s_circular_image.dart';

class SUserProfileTile extends StatelessWidget {
  const SUserProfileTile({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;
  

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    
    return Obx(() {
      // Check if the profile is loading or if the user data is still empty
      // if (controller.loading.value || controller.user.value.id == null) {
      //   return const Center(child: CircularProgressIndicator());
      // }
      final isNetworkImage = controller.user.value.profilePicture.isNotEmpty;
      final image = isNetworkImage ? controller.user.value.profilePicture : SImages.user;
      print('Full Name: ${controller.user.value.id}');
      print('Email: ${controller.user.value.email}');
      return ListTile(
        leading: SCircularImage(padding: 0, image: image, width: 50, height: 50, isNetworkImage: isNetworkImage),
        // title: const Text('Full Name'),
        
        title: Text(controller.user.value.fullName, style: Theme.of(context).textTheme.headlineSmall!.apply(color: SColors.white)),
        subtitle: Text(controller.user.value.email, style: Theme.of(context).textTheme.bodyMedium!.apply(color: SColors.white)),
        trailing: IconButton(onPressed: onPressed, icon: const Icon(Iconsax.edit, color: SColors.white)),
      );
      
    });
  }
}
