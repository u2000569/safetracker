import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safetracker/common/widgets/images/s_circular_image.dart';
import 'package:safetracker/common/widgets/shimmers/shimmer.dart';
import 'package:safetracker/data/repositories/authentication/auth_repository.dart';
import 'package:safetracker/features/school/controllers/dismissalController/dismissal_controller.dart';
import 'package:safetracker/features/school/controllers/student/student_controller.dart';
import 'package:safetracker/features/school/screens/dismissal/update_dismissal.dart';
import 'package:safetracker/features/school/screens/dismissal/create_dismissal.dart';
import 'package:safetracker/utils/constants/colors.dart';
import 'package:safetracker/utils/constants/image_strings.dart';
import 'package:safetracker/utils/constants/sizes.dart';
import 'package:safetracker/utils/logging/logger.dart';
import '../../../personalization/controllers/user_controller.dart';

class DismissalScreen extends StatefulWidget {
  // final DismissalModel dismissalData;

  const DismissalScreen({
    super.key, 
    // required this.dismissalData
    });

  @override
  _DismissalScreenState createState() => _DismissalScreenState();
}

class _DismissalScreenState extends State<DismissalScreen> {
  final dismissalController = Get.put(DismissalController());
  final studentController = Get.put(StudentController());
  final userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dismissal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {

          // Show loading indicator while data is being fetched
        if (dismissalController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
          // Fetch student details
          
          // final studentId = studentController.studentParent.value!.docId;
          // final dismissalId = AuthenticationRepository.instance.getUserId;
          // dismissalController.fetchStudentDismissal(studentId, dismissalId);
          // SLoggerHelper.info('Fetching student dismissal for $studentId and $dismissalId');
          // dismissalController.fetchStudentDismissal(studentId, dismissalId ?? '');
          // Check if dismissal request exists
          final dismissalInfo = dismissalController.dismissal.value;
          SLoggerHelper.info('Dismissal Document: ${dismissalInfo.toJson()}');
          SLoggerHelper.info('Dismissal Info: ${dismissalInfo.authorizedPickupName}');
          if(dismissalInfo.authorizedPickupName.isEmpty){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(SImages.user,height: 100),
                  const SizedBox(height: 8),
                  const Text('No Dismissal Request'),
                  const SizedBox(height: SSizes.spaceBtwSections),
                  ElevatedButton(
                    onPressed: () => _createDismissalForm(context),
                    
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                      side: const BorderSide(width: 1,color: SColors.white)
                    ),
                    child: const Text('Request Dismissal'),
                  ),
                ],
              ),
            );
          }
      
          return ListView(
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Authorized Person',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: SSizes.spaceBtwItems),
                      Obx(() {
                        final networkImage = dismissalInfo.authorizedPickupImage;
                        final image = networkImage.isNotEmpty ? networkImage : SImages.user;
                        return dismissalController.imageUploading.value
                            ? const SShimmerEffect(width: 100, height: 100, radius: 80)
                            : SCircularImage(image: image, width: 100, height: 100, isNetworkImage: networkImage.isNotEmpty);
                      }),
                      const SizedBox(height: SSizes.spaceBtwItems),
                      Text('Name: ${dismissalInfo.authorizedPickupName}'),
                      Text('Phone Number: ${dismissalInfo.authorizedPickupPhone}'),
                      const SizedBox(height: SSizes.spaceBtwItems),
                      
                      
                    ],
                  ),
                ),
              ),
              const SizedBox(height: SSizes.spaceBtwSections),
              ElevatedButton(
                onPressed: () => _showDismissalForm(context),
                child: const Text('Update Dismissal'),
              )
            ],
          );
          // Show authorized person details
        }),
      ),
    );
  }

  // Show the form for a new dismissal request
  void _showDismissalForm(BuildContext context) {
    Get.to(() => const UpdateDismissal());
  }
  void _createDismissalForm(BuildContext context) {
    Get.to(() => const CreateDismissalRequest());
  }
}
