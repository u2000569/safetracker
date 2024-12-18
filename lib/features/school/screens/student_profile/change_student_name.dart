import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:safetracker/utils/constants/sizes.dart';
import 'package:safetracker/utils/validators/validation.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../personalization/controllers/update_student_name_controller.dart';

class ChangeStudentName extends StatelessWidget {
  const ChangeStudentName({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateStudentNameController());
    return Scaffold(
      /// custom appbar
      appBar: SAppBar(
        showBackArrow: true,
        title: Text('Change Name', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(SSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // heading
            Text(
              'Use Full Student Name for easy verification. This name will appear on several pages.',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: SSizes.spaceBtwSections),

            // text field and button
            Form(
              key: controller.updateStudentNameFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.fullName,
                    validator: (value) => SValidator.validateEmptyText('Full Name Student', value),
                    expands: false,
                    decoration: const InputDecoration(labelText: 'Full Name Student', prefixIcon: Icon(Iconsax.user)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SSizes.spaceBtwSections),

            // save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () => controller.updateStudentName(), 
              child: const Text('Save')),
            ),
          ],
        ),
      ),
    );
  }
}