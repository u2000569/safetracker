import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../personalization/controllers/nfc_controller.dart';


class NFCscreen extends StatelessWidget {
  final String action; // "check in" or "check out"
  final NfcController nfcController = Get.put(NfcController());

  NFCscreen({required this.action, super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Automatically start scanning when the screen is displayed
      nfcController.scanCard(action);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('${action.capitalizeFirst} NFC'),
      ),
      body: Obx(() {
        if (nfcController.isScanning.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Center(child: Text('Scan an NFC card to continue.'));
        }
      }),
    );
  }
}
