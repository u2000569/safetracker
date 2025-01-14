import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:safetracker/features/school/controllers/emergency/emergency_controller.dart';
import 'package:safetracker/utils/constants/sizes.dart';
import 'package:safetracker/utils/logging/logger.dart';

import '../../../../personalization/controllers/user_controller.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmergencyController());
    final userId = Get.find<UserController>().user.value.id;
    
    // final GFBottomSheetController _botcontroller = GFBottomSheetController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Alert'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: emergencyItems.length,
                itemBuilder: (context, index) {
                  final item = emergencyItems[index];
                  final isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                      print('${item['label']} selected');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.red : Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item['icon'] as IconData,
                            size: 40.0,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            item['label'] as String,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // TextFormField(
            //   controller: controller.detailEmergency,
            // ),
            // const SizedBox(height: SSizes.spaceBtwSections),
            ElevatedButton(
              onPressed: () {
                if(selectedIndex == null){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select an emergency first!'),
                    ),
                  );
                  return;
                }

                final selectedType = emergencyItems[selectedIndex!]['label'] as String;
                SLoggerHelper.info('Report User ID: $userId');
                SLoggerHelper.info('Selected Emergency: $selectedType');

                if(selectedType.isNotEmpty){
                  // controller.createEmergency(
                  //   userId!, 
                  //   selectedType
                  // );
                  showModalBottomSheet(
                    context: context, 
                    builder: (BuildContext context){
                      return SizedBox(
                        height: 400,
                        child: Column(
                          
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Report $selectedType', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            /********Location Controller*********/
                            // const SizedBox(height: SSizes.spaceBtwItems,),
                            // TextField(
                            //   controller: _locationController,
                            //   decoration: const InputDecoration(
                            //     hintText: 'Enter location',
                            //     border: OutlineInputBorder(),
                            //     suffixIcon: Icon(Icons.location_pin),
                            //   ),
                            // ),
                            const SizedBox(height: SSizes.spaceBtwItems,),
                            TextField(
                              
                              controller: controller.detailEmergency,
                              decoration: const InputDecoration(
                                hintText: 'Enter details',
                                border: OutlineInputBorder(),
                              ),
                            ),

                            // Upload Picture
                            // const SizedBox(height: SSizes.spaceBtwItems,),
                            // GestureDetector(
                            //   onTap: () {
                                
                            //   },
                            //   child: Container(
                            //     height: 30,
                            //     width: double.infinity,
                            //     decoration: BoxDecoration(
                            //       border: Border.all(color: Colors.grey.shade300),
                            //       borderRadius: BorderRadius.circular(10.0),
                            //       color: Colors.grey,
                            //     ),
                            //   ),
                            // ),
                            const SizedBox(height: SSizes.spaceBtwItems,),
                              ElevatedButton(
                              onPressed: () {
                                controller.createEmergency(
                                  userId!, 
                                  selectedType,
                                );
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                                textStyle: const TextStyle(fontSize: 18.0, color: Colors.white),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: const Text('Send Report'),
                            ),
                          ], 
                        ),
                      );
                    }
                  );
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select type emergency first!'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                side: const BorderSide(color: Colors.white),
                padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 18.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  
                ),
              ),
              child: const Text('Report Emergency'),
            ),
          ],
        ),
      ),
    );
  }
  bool _isLoadingLocation = false;
  final TextEditingController _locationController = TextEditingController();
  Future<void> _fetchLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // Check location permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied.';
      }

      // Fetch location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Reverse geocode to get address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final Placemark place = placemarks.first;
      final address =
          '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';

      setState(() {
        _locationController.text = address;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching location: $e')),
      );
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

}

// List of Emergency Items
final List<Map<String, dynamic>> emergencyItems = [
  {'icon': Icons.car_crash, 'label': 'Accident'},
  {'icon': Icons.electric_bolt, 'label': 'Power Outage'},
  {'icon': Icons.local_police, 'label': 'Police Alert'},
  {'icon': Icons.fire_extinguisher, 'label': 'Fire'},
  {'icon': Icons.medical_services, 'label': 'Medical'},
  {'icon': Icons.house, 'label': 'Structure Collapse'},
];

// fetch Location

