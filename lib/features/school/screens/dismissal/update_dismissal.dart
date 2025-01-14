// ignore_for_file: unused_field, unnecessary_null_comparison

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safetracker/utils/validators/validation.dart';

import '../../../../utils/logging/logger.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../controllers/dismissalController/dismissal_controller.dart';
import '../../controllers/student/student_controller.dart';

class UpdateDismissal extends StatefulWidget {
  const UpdateDismissal({super.key});

  @override
  State<UpdateDismissal> createState() => _UpdateDismissalState();
}

class _UpdateDismissalState extends State<UpdateDismissal> {
  String? _name, _phoneNumber;

  DateTime _selectedDate = DateTime.now();

  XFile? _imageFile;

  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  final dismissalController = Get.put(DismissalController());

  final studentController = Get.put(StudentController());

  final userController = Get.put(UserController());

  Future<void> _pickImage() async {
    try {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    final studentDocId = studentController.studentParent.value!.docId;
    final dismissalId = userController.user.value.id;
    SLoggerHelper.info('Authorize image picked: ${pickedFile!.path}');
    SLoggerHelper.info('Student Doc ID: $studentDocId and Dismissal ID: $dismissalId');

    if(pickedFile == null){
      SLoggerHelper.warning('No Image Selected');
      return;
    }
    setState(() {
      _imageFile = pickedFile;
    });
    dismissalController.uploadAuthorizedPicture(studentDocId, dismissalId ?? '', _imageFile!.path);
    } catch (e) {
      SLoggerHelper.error('Error picking image: $e');
    }
  }

  Future<void> _updateForm() async {
    if (dismissalController.dismissalFormKey.currentState!.validate()) {
      // Validate if the image is uploaded
      if (_imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please upload an image.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      dismissalController.dismissalFormKey.currentState!.save();

      setState(() {
        _isLoading = true; // Show loading indicator
        SLoggerHelper.info('Loading state set to true.');
      });

      try {
        // Upload the image to Firebase Storage
        final studentDocId = studentController.studentParent.value!.docId;
        final dismissalId = userController.user.value.id;

        if (studentDocId == null || dismissalId == null) {
        throw Exception('StudentDocId or DismissalId is null. Cannot proceed.');
        }

        // Update the dismissal request
        dismissalController.updateRequestDismissal(studentController.studentParent.value!.docId);

        SLoggerHelper.info('Student Doc ID: $studentDocId and Dismissal ID: $dismissalId');

        await dismissalController.uploadAuthorizedPicture(
          studentDocId,
          dismissalId ,
          _imageFile!.path,
        );

        SLoggerHelper.info('Form submitted successfully. Navigating back...');
        Get.back();
        

      } catch (e) {
        // Handle errors during upload
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting the form: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false; // Hide loading indicator
          SLoggerHelper.info('Loading state reset to false.');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = dismissalController.dismissalFormKey;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dismissal Form'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 150,
                      width: 150,
                      color: Colors.grey[200],
                      child: _imageFile == null
                          ? const Center(child: Text('Upload Picture'))
                          : Image.file(File(_imageFile!.path)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    onSaved: (value) => _name = value,
                    controller: dismissalController.authorizeName,
                    validator: (value) => SValidator.validateEmptyText('Authorize Name', value),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                    controller: dismissalController.authorizePhone,
                    onSaved: (value) => _phoneNumber = value,
                    validator: SValidator.validatePhoneNumber,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _updateForm,
                    child: const Text('Update Form Dismissal'),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}