import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safetracker/data/repositories/authentication/auth_repository.dart';
import 'package:safetracker/data/repositories/parent/parent_repository.dart';
import 'package:safetracker/data/repositories/teacher/teacher_repository.dart';
import 'package:safetracker/features/school/controllers/student/student_controller.dart';
import 'package:safetracker/utils/constants/sizes.dart';
import 'package:safetracker/utils/logging/logger.dart';
import 'package:safetracker/utils/popups/full_screen_loader.dart';

import '../../../common/widgets/loaders/circular_loader.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/popups/loader.dart';
import '../models/user_model.dart';
import '../screens/profile/re_authenticate_user_login_form.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  Rx<UserModel> user = UserModel.empty().obs;
  final imageUploading = false.obs;
  final loading = false.obs;
  final profileImageUrl = ''.obs;
  final hidePassword = false.obs;

  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  
  final formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();

  final selectedrole = ''.obs;

  final userRepository = Get.put(UserRepository());
  final teacherRepository = Get.put(TeacherRepository());
  final parentRepository = Get.put(ParentRepository());

  // init user data when home screen appears
  @override 
  void onInit() {
    SLoggerHelper.debug('UserController onInit called');
    fetchUserDetails().then((_) {
      if(user.value.email.isNotEmpty){
        StudentController.instance.fetchStudentForParent(user.value.email);
        SLoggerHelper.info('Trigger student fetch when user data is available');
      }
    });
    UserRepository().saveOneSignalId();
    super.onInit();
    
  }

  /// Fetch user record
  Future<UserModel> fetchUserDetails() async {
    try {
      
      loading.value = true;
      
      final userRole = await userRepository.fetchUserRole();
      SLoggerHelper.debug('User Role: $userRole');

      if(user.value.id == null || user.value.id!.isEmpty){
        if (userRole.roles == 'teacher') {
          final userDetails = await teacherRepository.fetchTeacherDetails();
          user.value = userDetails;
        }else if(userRole.roles == 'parent'){
          final userDetails = await parentRepository.fetchParentDetails();
          user.value = userDetails;
        } else{
          SLoggerHelper.error('Unknown Role : ${user.value.roles}');
          throw 'Unknown Role';
        }
      }
      

      // fetch data
      SLoggerHelper.debug('User Data: ${user.value.toJson()}');

      firstNameController.text = user.value.firstName;
      lastNameController.text = user.value.lastName;
      phoneController.text = user.value.phoneNumber;
      selectedrole.value = user.value.role.toString();
  

      loading.value = true;
      return user.value;

    } catch (e) {
      SLoggerHelper.error('Error fetching user details: $e');
      return UserModel.empty();
    } finally {
      loading.value = false;
    }
  }

  /// Save user Record
  Future<void> saveUserRecord({UserModel? user, UserCredential? userCredentials}) async{
    try {
      // update Rx user
      await fetchUserDetails();

      // if no record
      if (this.user().id!.isEmpty) {
        if(userCredentials != null){
          // Convert name to first name and last name
          final nameParts = UserModel.nameParts(userCredentials.user!.displayName ?? '');
          // final customUsername = UserModel.generateUsername(userCredentials.user!.displayName ?? '');

          // Map data
          final newUser = UserModel(
            id: userCredentials.user!.uid,
            firstName: nameParts[0],
            lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : "",
            email: userCredentials.user!.email ?? '',
            phoneNumber: userCredentials.user!.phoneNumber ?? '',
            profilePicture: '',
          );

          // Save user data
          await userRepository.saveUserRecord(newUser);

          // assign new user to RxUser so that we can use it through out the app.
          this.user(newUser);
        } else if(user != null){
          // Save Model when user registers using Email and Password
          await userRepository.saveUserRecord(user);

          // assign new user to RxUser so that we can use it through out the app.
          this.user(user);
          }
      } 
    } catch (e) {
        SLoaders.warningSnackBar(
        title: 'Data not saved',
        message: 'Something went wrong while saving your information. You can re-save your data in your Profile.',
        );
      }
  }

  /// Upload Profile Picture
  uploadUserProfilePicture() async{
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80, maxHeight: 512, maxWidth: 512);
      if(image != null){
        imageUploading.value = true;
        final uploadedImage = await userRepository.uploadImage('Users/Images/Profile/', image);
        profileImageUrl.value = uploadedImage;
        Map<String, dynamic> newImage = {'ProfilePicture': uploadedImage};
        await userRepository.updateSingleField(newImage);
        user.value.profilePicture = uploadedImage;
        user.refresh();

        imageUploading.value = false;
        SLoaders.successSnackBar(title: 'Congratulations', message: 'Your profile picture has been updated successfully.');
      } 
    } catch (e) {
      imageUploading.value = false;
      SLoaders.errorSnackBar(title: 'OhSnap', message: 'Cannot upload picture. Something went wrong: $e');
    }
  }

  /// Delete Account
  void deleteAccountWarningPopup(){
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(SSizes.md),
      title: 'Delete Account',
      middleText: 'Are you sure you want to delete your account?',
      confirm: ElevatedButton(
        onPressed: () async => deleteUserAccount(), 
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
        child: const Padding(padding: EdgeInsets.symmetric(horizontal: SSizes.lg), child: Text('Delete')),
      ),
      cancel: OutlinedButton(
        onPressed: () => Navigator.of(Get.overlayContext!).pop(), 
        child: const Text('Cancel')),
    );
  }

  void deleteUserAccount() async{
    try {
      SFullScreenLoader.openLoadingDialog('Processing', SImages.docerAnimation);

      /// First re-authenciate user
      final auth = AuthenticationRepository.instance;
      final provider = auth.firebaseUser!.providerData.map((e) => e.providerId).first;
      if(provider.isNotEmpty){
        // Re verify auth email
        provider == 'password';
        SFullScreenLoader.stopLoading();
        Get.to(() => const ReAuthLoginForm());
      }
    } catch (e) {
      SFullScreenLoader.stopLoading();
      SLoaders.warningSnackBar(title: 'Oh snap!', message: e.toString());
    }
  }

  /// Re-authenticate user
  /// This is called when user wants to delete account
  // Future<void> reAuthenticateEmailAndPasswordUser() async{
  //   try {
  //     SFullScreenLoader.openLoadingDialog('Processing', SImages.docerAnimation);

  //     // Check Internet
  //     final isConnected = await NetworkManager.instance.isConnected();
  //     if(!isConnected){
  //       SFullScreenLoader.stopLoading();
  //       return;
  //     }

  //     if(!reAuthFormKey.currentState!.validate()){
  //       SFullScreenLoader.stopLoading();
  //       return;
  //     }

  //     await AuthenticationRepository.instance.reAuthenticateWithEmailAndPassword(verifyEmail.text.trim(), verifyPassword.text.trim());
  //     await AuthenticationRepository.instance.deleteAccount();
  //     SFullScreenLoader.stopLoading();

  //     Get.offAll(() => const LoginScreen());

  //   } catch (e) {
  //     SFullScreenLoader.stopLoading();
  //     SLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
      
  //   }
  // }

  /// Logout Loader Function
  logout() {
    try {
      Get.defaultDialog(
        contentPadding: const EdgeInsets.all(SSizes.md),
        title: 'Logout',
        middleText: 'Are you sure you want to Logout?',
        confirm: ElevatedButton(
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: SSizes.lg),
            child: Text('Confirm'),
          ),
          onPressed: () async {
            onClose();

            /// On Confirmation show any loader until user Logged Out.
            Get.defaultDialog(
              title: '',
              barrierDismissible: false,
              backgroundColor: Colors.transparent,
              content: const SCircularLoader(),
            );
            await AuthenticationRepository.instance.logout();
          },
        ),
        cancel: OutlinedButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        ),
      );
    } catch (e) {
      SLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}