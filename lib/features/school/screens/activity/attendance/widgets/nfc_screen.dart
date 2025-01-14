import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:safetracker/utils/constants/image_strings.dart';

import '../../../../../personalization/controllers/nfc_controller.dart';


class NFCscreen extends StatelessWidget {
  final String action; // "check in" or "check out"
  // final StudentModel student;
  final NfcController nfcController = Get.put(NfcController());
  late final Future<LottieComposition> _composition;
  
  NFCscreen({
    required this.action,
    // required this.student,
    super.key
  }){

    // Preload the Lottie composition when the widget is instantiated
    _composition = AssetLottie(SImages.tapNFC).load();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Automatically start scanning when the screen is displayed
      nfcController.scanCard(action);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('${action.capitalizeFirst} Attendance Student'),
      ),
      
      body: Obx(() {
        if (nfcController.isScanning.value) {
          return FutureBuilder<LottieComposition>(
            future: _composition, 
            builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show a loading spinner while the animation is loading
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Handle errors
                return Center(child: Text('Error loading animation: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                // Play the Lottie animation
                return Center(
                  child: SizedBox(
                    width: 350,
                    height: 350,
                    child: Lottie(composition: snapshot.data!),
                  )
                );
              } else{
                return const CircularProgressIndicator();
              }
            }
          );
        } else {
          return const Center(child: Text('Scan an NFC card to continue.'));
        }
      }),
    );
  }
}
