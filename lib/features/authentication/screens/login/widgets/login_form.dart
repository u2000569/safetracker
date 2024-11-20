import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../controllers/login_controller.dart';
import '../../password_configuration/forget_password.dart';

class SLoginForm extends StatelessWidget {
  const SLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: SSizes.spaceBtwSections),
        child: Column(
          children: [
            /// Email
            TextFormField(
              controller: controller.email,
              validator: SValidator.validateEmail,
              decoration: const InputDecoration(prefixIcon: Icon(Iconsax.direct_right), labelText: STexts.email),
            ),
            const SizedBox(height: SSizes.spaceBtwInputFields),

            /// Password
            Obx(
              () => TextFormField(
                obscureText: controller.hidePassword.value,
                controller: controller.password,
                validator: (value) => SValidator.validateEmptyText('Password', value),
                decoration: InputDecoration(
                  labelText: STexts.password,
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                    icon: const Icon(Iconsax.eye_slash),
                  ),
                ),
              ),
            ),
            const SizedBox(height: SSizes.spaceBtwInputFields / 2),

            /// Role Selection
            DropdownButtonFormField<String>(
              value: controller.selectedRole.value.isEmpty ? null : controller.selectedRole.value,
              onChanged: (value) {
                if (value != null) {
                  controller.selectedRole.value = value;
                }
              },
              items: ['parent', 'teacher'].map((role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role.capitalizeFirst!), // Display role with capitalized first letter
                );
              }).toList(),
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.user),
                labelText: 'Select Role',
              ),
              validator: (value) => value == null ? 'Please select a role' : null,
            ),
            const SizedBox(height: SSizes.spaceBtwInputFields / 2),

            /// Remember Me & Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Remember Me
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => Checkbox(value: controller.rememberMe.value, onChanged: (value) => controller.rememberMe.value = value!)),
                    const Text(STexts.rememberMe),
                  ],
                ),

                /// Forget Password
                TextButton(onPressed: () => Get.to(() => const ForgetPasswordScreen()), child: const Text(STexts.forgetPassword)),
              ],
            ),
            const SizedBox(height: SSizes.spaceBtwSections),

            /// Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () => controller.emailAndPasswordSignIn(), child: const Text(STexts.signIn)),
            ),
            const SizedBox(height: SSizes.spaceBtwItems),

            
          ],
        ),
      ),
    );
  }
}
