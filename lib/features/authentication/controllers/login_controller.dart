import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:safetracker/data/repositories/authentication/auth_repository.dart';
import 'package:safetracker/features/personalization/models/user_model.dart';
import 'package:safetracker/utils/constants/enums.dart';
import 'package:safetracker/utils/logging/logger.dart';
import 'package:safetracker/utils/popups/loader.dart';
import '../../../data/repositories/parent/parent_repository.dart';
import '../../../data/repositories/teacher/teacher_repository.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../personalization/controllers/user_controller.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  /// Variables
  final hidePassword = true.obs;

  final rememberMe = false.obs;

  final selectedRole = ''.obs;

  final localStorage = GetStorage();

  final email = TextEditingController();

  final password = TextEditingController();

  
  final loginFormKey = GlobalKey<FormState>();

  final userController = Get.put(UserController());
  final teacherRepository = Get.put(TeacherRepository());
  final parentRepository = Get.put(ParentRepository());

  

  @override
  void onInit() {
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
    super.onInit();
  }

  /// -- Email and Password SignIn
  Future<void> emailAndPasswordSignIn() async {
    try {
      // Start Loading
      SFullScreenLoader.openLoadingDialog('Logging you in...', SImages.docerAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
       print('Internet connectivity checked: $isConnected');
      if (!isConnected) {
        SFullScreenLoader.stopLoading();
        SLoaders.customToast(message: 'No Internet Connection');
        return;
      }

      // Form Validation
      if (!loginFormKey.currentState!.validate()) {
        SFullScreenLoader.stopLoading();
        return;
      }

      SLoggerHelper.debug('Email: ${email.text.trim()}');
      SLoggerHelper.debug('Password: ${password.text.trim()}');
      SLoggerHelper.debug('Role: ${selectedRole.value}');

      // Save Data if Remember Me is selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      // Login user using EMail & Password Authentication
      await AuthenticationRepository.instance.loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      // Assign user data to RxUser of UserController to use in app
      // await userController.fetchUserDetails();
      SLoggerHelper.info('User Details: ${userController.user.value}');
      
      // await fetchUserInformation();

      // selectedRole.value = user.role.name;
      SLoggerHelper.debug('User Role: ${selectedRole.value}');

      if(selectedRole.value == 'teacher'){
        final teacherData = await teacherRepository.fetchTeacherDetails();
        SLoggerHelper.info('Role : ${teacherData.roles}');
            if (teacherData.roles == 'teacher') {
            SLoggerHelper.info('Teacher Logged in');
            // Login OneSignal External ID
            OneSignal.login(teacherData.id!);
            SLoggerHelper.info('OneSignal External ID: ${teacherData.id}');
            AuthenticationRepository.instance.screenRedirect();
          } else {
            SLoggerHelper.warning('Teacher role not found or incorrect');
            SLoaders.errorSnackBar(title: 'Unauthorized', message: 'You are not authorized to access this app as a teacher');
            await AuthenticationRepository.instance.logout();
          }
        
      }else if(selectedRole.value == 'parent'){
        final parentData = await parentRepository.fetchParentDetails();
        SLoggerHelper.info('Role : ${parentData.role}');
        if (parentData.roles == 'parent') {
          SLoggerHelper.info('Parent Logged in');
          // Login OneSignal External ID
          OneSignal.login(parentData.id!);
          SLoggerHelper.info('OneSignal External ID: ${parentData.id}');
          AuthenticationRepository.instance.screenRedirect();
        } else {
          SLoggerHelper.warning('Parent role not found or incorrect');
          SLoaders.errorSnackBar(title: 'Unauthorized', message: 'You are not authorized to access this app as a parent');
          await AuthenticationRepository.instance.logout();
        }


      }else{
        SLoggerHelper.warning('Not Authorized');
        SLoaders.errorSnackBar(title: 'Not Authorized', message: 'You are not authorized to access this app');
        AuthenticationRepository.instance.logout();
      }
      
      
    } catch (e) {
      SFullScreenLoader.stopLoading();
      SLoaders.errorSnackBar(title: 'Oh Snap cant login', message: e.toString());

    }
  }

  Future<UserModel> fetchUserInformation() async{
    // fetch user details and assign to UserController
    final controller = UserController.instance;
    UserModel user;
    if(controller.user.value.id == null || controller.user.value.id!.isEmpty){
      user  = await UserController.instance.fetchUserDetails();
    } else{
      user = controller.user.value;
    }
    return user;
  }



}
