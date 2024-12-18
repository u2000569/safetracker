import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:safetracker/api/one_signal_service.dart';
import 'package:safetracker/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:safetracker/common/widgets/layouts/grid_layout.dart';
import 'package:safetracker/common/widgets/shimmers/vertical_student_shimmer.dart';
import 'package:safetracker/common/widgets/student_cards/student_card_vertical.dart';
import 'package:safetracker/common/widgets/student_cards/student_info_card.dart';
import 'package:safetracker/common/widgets/texts/s_student_name_text.dart';
import 'package:safetracker/data/repositories/student/student_repository.dart';
import 'package:safetracker/data/repositories/user/user_repository.dart';
import 'package:safetracker/features/school/controllers/student/student_controller.dart';
import 'package:safetracker/features/school/models/student_model.dart';
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
    final _db = FirebaseFirestore.instance;

    // Ensure user details are fetched when the app bar is loaded
    if (userController.user.value.id == null || userController.user.value.id!.isEmpty) {
      // Ensure we fetch user details only if not already done
      userController.fetchUserDetails();
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
             const SPrimaryHeaderContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -- Appbar
                  SHomeAppBar(),
                  SizedBox(height: SSizes.spaceBtwSections),

                  // -- Search Bar
                  // SSearchContainer(text: 'Search in class', showBorder: false),
                ],
              ),
            ),

            // Body
            Obx(() {
                final parentEmail = userController.user.value.email;
                if(parentEmail == null || parentEmail.isEmpty){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return StreamBuilder<QuerySnapshot>(
                  stream: _db
                      .collection('Students')
                      .where('Parent.Email', isEqualTo: parentEmail)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError){
                      // handle error
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
                            )
                          ],
                        ),
                      );
                    }else if(!snapshot.hasData || (snapshot.data as QuerySnapshot).docs.isEmpty){
                      return const Center(child: Text('No Student found for this parent'));
                    }
                
                    final studentData = (snapshot.data as QuerySnapshot).docs.map((doc){
                      return StudentModel.fromSnapshot(doc);
                    }).toList();
                    return Container(
                      padding: const EdgeInsets.all(SSizes.defaultSpace),
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Home'),
                          const SizedBox(height: SSizes.spaceBtwItems),
                          ...studentData.map((student){
                            return _buildStudentInfoCard(context, student);
                          }),
                    
                          _buildActivityCard(
                            context,
                            icon: Icons.check_circle,
                            title: 'Arrived',
                            onSlideComplete: () async {
                              // final user = UserRepository();
                    
                              // final targetUserId = await user.fetchOneSignalId();
                    
                              // Get.to(AttendanceScreen());
                              await OneSignalService.sendNotification(
                                title: 'Parent Arrival Notification', 
                                body: 'The parent has arrived to pick up their child.', 
                                userId: 'Lb5Ipb6CccbrbfvfWwpQioemPnO2', 
                                targetUserId: "9cea6484-4936-42a3-b9fd-d24fc2881555",
                              );
                            },
                          ),
                          const SizedBox(height: SSizes.spaceBtwItems),
                    
                          SizedBox(height: SDeviceUtils.getBottomNavigationBarHeight() + SSizes.defaultSpace),
                          
                        ],
                      )
                    );
                  }
                );
              }
            ),
          ]
        )
      ),
    );
  }
}

// Widget to display student information
  Widget _buildStudentInfoCard(BuildContext context, StudentModel student) {
    SLoggerHelper.info('Student Card ${student.name}');

    return GestureDetector(
      onTap: (){
        // Navigate to student details
        Get.to(() => StudentProfileScreen(studentId: student));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0),
        child: StudentInfoCard(studentInfo: student),
      ),
    );
  }


Widget _buildActivityCard(BuildContext context,
{
  required IconData icon,
  required String title,
  required VoidCallback onSlideComplete,
}){
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

          // Slide to complete
          SlideAction(
            stretchThumb: true,
            trackBuilder: (context, state){
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: SColors.white,
                  boxShadow: const[
                    BoxShadow(
                      color: SColors.darkGrey,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    "Slide to Annouce Arrival",
                    // "Thumb fraction: ${state.thumbFractionalPosition.toStringAsPrecision(2)}",
                  ),
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
                    ? const CupertinoActivityIndicator(
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
              );
            }, 
            action: onSlideComplete
            
            )
        ],
      ),
    )
  );
}