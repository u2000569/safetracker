import 'package:get/get.dart';
import 'package:safetracker/data/repositories/student/student_repository.dart';
import 'package:safetracker/features/personalization/controllers/settings_controller.dart';
import 'package:safetracker/features/personalization/controllers/user_controller.dart';
import 'package:safetracker/home_menu.dart';
import 'package:safetracker/utils/helpers/network_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    /// Core
    Get.put(NetworkManager());
    Get.put(() => UserController());
    // Get.put(StudentRepository());
    print('GeneralBindings called');
    // Get.put(AppScreenController(), permanent: true);
    // Get.put(ImageController());
    
    //other
    Get.lazyPut(() => SettingsController(), fenix: true); // Add your bindings here
     
  }
}