import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:safetracker/api/one_signal_service.dart';
import 'package:safetracker/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:safetracker/common/widgets/student_cards/student_info_card.dart';
import 'package:safetracker/features/school/controllers/dismissalController/dismissal_controller.dart';
import 'package:safetracker/features/school/controllers/notificationController/notification_controller.dart';
import 'package:safetracker/features/school/controllers/student/student_controller.dart';
import 'package:safetracker/features/school/models/student_model.dart';
import 'package:safetracker/features/school/screens/dismissal/dismissal_screen.dart';
import 'package:safetracker/features/school/screens/home/widgets/quick_buttons.dart';
import 'package:safetracker/utils/constants/sizes.dart';
import 'package:safetracker/utils/device/device_utility.dart';
import 'package:safetracker/utils/logging/logger.dart';
import 'package:slide_action/slide_action.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../student_profile/student_profile.dart';
import 'widgets/home_appbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StudentController());
    final userController = Get.put(UserController());
    final dismissalController = Get.put(DismissalController());
    // final notificationController = Get.put(NotificationController());
    final _db = FirebaseFirestore.instance;

    if (userController.user.value.id == null || userController.user.value.id!.isEmpty) {
      userController.fetchUserDetails();
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SPrimaryHeaderContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SHomeAppBar(),
                  SizedBox(height: SSizes.spaceBtwSections),
                ],
              ),
            ),

            Obx(() {
              final parentEmail = userController.user.value.email;
              final parentName = userController.user.value.fullName;
              final studentName = controller.studentParent.value?.name ?? '';
              // final studentDocId = controller.studentParent.value?.docId ?? '';

              if (parentEmail.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              return StreamBuilder<QuerySnapshot>(
                stream: _db.collection('Students').where('Parent.Email', isEqualTo: parentEmail).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, color: SColors.error, size: 48),
                          const SizedBox(height: SSizes.buttonHeight),
                          Text(
                            'An error occurred: ${snapshot.error}',
                            style: const TextStyle(fontSize: 16, color: SColors.error),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || (snapshot.data as QuerySnapshot).docs.isEmpty) {
                    return const Center(child: Text('No Student found for this parent'));
                  }

                  final studentData = (snapshot.data as QuerySnapshot).docs.map((doc) {
                    return StudentModel.fromSnapshot(doc);
                  }).toList();

                  return Container(
                    padding: const EdgeInsets.all(SSizes.defaultSpace),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Home', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

                        // Student Card
                        const SizedBox(height: SSizes.spaceBtwItems),
                        ...studentData.map((student) => _buildStudentInfoCard(context, student)),

                        const Divider(thickness: 1, height: 40),
                        const SizedBox(height: SSizes.spaceBtwItems),

                        // Quick Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            QuickActionButton(
                              icon: Iconsax.add_circle, 
                              label: 'Dismissal', 
                              onPressed: (){
                                Get.to(const DismissalScreen());
                              }
                            )
                          ],
                        ),
                        const SizedBox(height: SSizes.spaceBtwItems),

                        _buildActivityCard(
                          context,
                          icon: Icons.check_circle,
                          title: 'Arrived',
                          onSlideComplete: () async {
                            try {
                              SLoggerHelper.info('Mr/Mrs $parentName has arrived to pick up $studentName');
                              await OneSignalService.teacherNotification(
                                title: "Arrived",
                                body: 'Mr/Mrs $parentName has arrived to pick up $studentName',
                                userRoleTag: "teacher",
                              );

                              /*------------------- Send Alert Dismissal -------------------*/
                              // Option 1
                            // SLoggerHelper.info('Retrive student Doc ID: $studentDocId');
                            // dismissalController.alertDismissal(studentDocId);

                            // Option 2
                            final studentDocIds = studentData.map((student) => student.docId).toList();
                            SLoggerHelper.info('Retrive student Doc IDs: $studentDocIds');
                            dismissalController.listAlertDismissal(studentDocIds);

                            // save to firestore
                            NotificationController().procesSendNotification();
                            } catch (e) {
                              SLoggerHelper.error('Error sending notification: $e');
                            }
                            // DismissalController().createDismissal(studentName);
                          },
                        ),
                        const SizedBox(height: SSizes.spaceBtwItems),

                        SizedBox(height: SDeviceUtils.getBottomNavigationBarHeight() + SSizes.defaultSpace),
                      ],
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentInfoCard(BuildContext context, StudentModel student) {
    return GestureDetector(
      onTap: () {
        Get.to(() => StudentProfileScreen(studentId: student));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0),
        child: StudentInfoCard(studentInfo: student),
      ),
    );
  }

  Widget _buildActivityCard(BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onSlideComplete,
  }) {
    final dark = SHelperFunctions.isDarkMode(context);
    return Card(
      color: dark ? Colors.black : Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SSizes.borderRadiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(SSizes.defaultSpace),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, size: 32, color: dark ? SColors.white : SColors.black),
                const SizedBox(width: SSizes.buttonWidth),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium!.apply(color: dark ? SColors.white : SColors.black),
                ),
              ],
            ),
            const SizedBox(height: SSizes.spaceBtwItems),
            SlideAction(
              stretchThumb: true,
              trackBuilder: (context, state) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: SColors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: SColors.darkGrey,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text("Slide to Announce Arrival"),
                  ),
                );
              },
              thumbBuilder: (context, state) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: state.isPerformingAction ? SColors.darkGrey : SColors.buttonPrimary,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: state.isPerformingAction
                      ? const CupertinoActivityIndicator(color: Colors.white)
                      : const Icon(Icons.chevron_right, color: Colors.white),
                );
              },
              action: onSlideComplete,
            ),
          ],
        ),
      ),
    );
  }
}
