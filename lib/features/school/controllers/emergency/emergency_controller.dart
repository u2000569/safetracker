import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:safetracker/data/abstract/base_data_table_controller.dart';
import 'package:safetracker/utils/logging/logger.dart';

import '../../../../data/repositories/emergency/emergency_repository.dart';
import '../../../../utils/popups/loader.dart';
import '../../models/emergency_model.dart';

class EmergencyController extends SBaseController<EmergencyModel> {
  static EmergencyController get instance => Get.find();

  Rx<EmergencyModel> emergency = EmergencyModel.empty().obs;
  final imageUploading = false.obs;
  final emergencyImageUrl = ''.obs;

  RxBool isLoading = true.obs;
  RxList<EmergencyModel> allEmergencies = <EmergencyModel>[].obs;
  final _emergencyRepository = Get.put(EmergencyRepository());

  // variables for report
  final typeEmergency = ''.obs;
  final detailEmergency = TextEditingController();
  final locationEmergency = TextEditingController();
  
  @override
  void onInit(){
    super.onInit();
    fetchItems();
    fetchData();
  }

  /// --------------------- Create a New Emergency Data ---------------------
  Future<void> createEmergency(String userId, typeEmergenci) async{
    try{
      // loading
      isLoading.value = true;
      // check if the emergency type is empty
      SLoggerHelper.debug('Create Emergency: $userId and $typeEmergenci');
      SLoggerHelper.debug('Details: ${detailEmergency.text.trim()}');
      if(typeEmergenci.isEmpty){
        throw 'Please select an emergency type';
      }
      if (detailEmergency.text.trim().isEmpty) {
      throw 'Please provide emergency details';
    }

      // Map Emergency Data to Emergency Model
      final newEmergency = EmergencyModel(
        reportId: userId ,
        locationEmergency: locationEmergency.text.trim(),
        typeEmergency: typeEmergenci,
        details: detailEmergency.text.trim(),
        timestamp: DateTime.now(),
      );

      SLoggerHelper.info('Doc: ${newEmergency.toJson()}');
      // Add to Firestore
      final reportId = await _emergencyRepository.addEmergency(newEmergency);
      newEmergency.reportId = reportId;

      // Update the list of emergencies
      // EmergencyController.instance.addItemToLists(newEmergency);
      SLoaders.successSnackBar(title: 'Suceess', message: 'Emergency reported successfully');

      isLoading.value = false; 
    } catch(e){
      isLoading.value = false;
      SLoggerHelper.error('Error creating emergency: $e');
      SLoaders.errorSnackBar(title: 'Oh Snap' , message: e.toString());
    }
  }
  
  @override
  Future<List<EmergencyModel>> fetchItems() async{
    sortAscending.value = false;
    return await _emergencyRepository.getAllEmergency();
  }

  /// --------------------- Sort Type Emergencies ---------------------
  /// Sorts the list of emergencies by type
  void sortTypeEmergencies(String type) {
    allEmergencies.value = allEmergencies.where((e) => e.typeEmergency == type).toList();
  }

  @override
  bool containsSearchQuery(EmergencyModel item, String query) {
    return item.reportId.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<void> deleteItem(EmergencyModel item) async{
    await _emergencyRepository.deleteEmergency(item.reportId);
  }
  
}