// ignore_for_file: unused_field, unnecessary_null_comparison

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safetracker/utils/validators/validation.dart';

import '../../../../utils/logging/logger.dart';
import '../../../../utils/popups/loader.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../controllers/dismissalController/dismissal_controller.dart';
import '../../controllers/student/student_controller.dart';

class CreateDismissalRequest extends StatefulWidget {
  const CreateDismissalRequest({super.key});

  @override
  State<CreateDismissalRequest> createState() => _CreateDismissalRequestState();
}

class _CreateDismissalRequestState extends State<CreateDismissalRequest> {
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
    // final studentDocId = studentController.studentParent.value!.docId;
    // final dismissalId = userController.user.value.id;
    SLoggerHelper.info('Authorize image picked: ${pickedFile!.path}');

    if(pickedFile == null){
      SLoggerHelper.warning('No Image Selected');
      return;
    }
    setState(() {
      _imageFile = pickedFile;
    });
    
    } catch (e) {
      SLoggerHelper.error('Error picking image: $e');
    }
  }

  Future<void> _submitForm() async {
  SLoggerHelper.info('Starting form submission...');
  
  if (dismissalController.dismissalFormKey.currentState!.validate()) {
    // Validate if the image is uploaded
    if (_imageFile == null) {
      SLoggerHelper.warning('No image uploaded.');
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
      // Log the start of the upload
      final studentDocId = studentController.studentParent.value?.docId;
      final dismissalId = userController.user.value.id;

      if (studentDocId == null || dismissalId == null) {
        throw Exception('StudentDocId or DismissalId is null. Cannot proceed.');
      }

      SLoggerHelper.info('Student Doc ID: $studentDocId and Dismissal ID: $dismissalId');

      // Create the dismissal request
      SLoggerHelper.info('Creating dismissal request...');
      dismissalController.createRequestDismissal(studentDocId);
      SLoggerHelper.info('Dismissal request created successfully.');

      // Upload the authorized picture
      SLoggerHelper.info('Uploading image...');
      await dismissalController.uploadAuthorizedPicture(
        studentDocId,
        dismissalId,
        _imageFile!.path,
      );
      SLoggerHelper.info('Image uploaded successfully.');

      // Navigate back to the previous screen
      Get.back();
      SLoggerHelper.info('Form submitted successfully. Navigated back.');
    } catch (e, stackTrace) {
      // Log the error
      SLoggerHelper.error('Error during form submission: $e');
      SLoggerHelper.error('Stack trace: $stackTrace');

      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting the form: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Reset loading state
      setState(() {
        _isLoading = false;
        SLoggerHelper.info('Loading state reset to false.');
      });
    }
  } else {
    SLoggerHelper.warning('Form validation failed.');
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
                          ? const Center(child: Text('Upload Picture Here'))
                          : Image.file(File(_imageFile!.path)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    onSaved: (value) => _name = value,
                    controller: dismissalController.authorizeName,
                    validator: (value) => value!.isEmpty ? 'Please enter authorize name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                    controller: dismissalController.authorizePhone,
                    // onSaved: (value) => _phoneNumber = value,
                    validator: SValidator.validatePhoneNumber,
                  ),
                  const SizedBox(height: 16),
                  /*-----------------Date Picker-----------------*/
                  // ListTile(
                  //   title: Text("Date: ${_selectedDate.toLocal()}".split(' ')[0]),
                  //   trailing: const Icon(Icons.calendar_today),
                  //   onTap: () async {
                  //     DateTime? pickedDate = await showDatePicker(
                  //       context: context,
                  //       initialDate: _selectedDate,
                  //       firstDate: DateTime(2000),
                  //       lastDate: DateTime(2101),
                  //     );
                  //     if (pickedDate != null && pickedDate != _selectedDate) {
                  //       setState(() {
                  //         _selectedDate = pickedDate;
                  //       });
                  //     }
                  //   },
                  // ),
                  // const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    child: const Text('Create Dismissal Request'),
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

// fucntion to create a dismissal request
// if (_formKey.currentState!.validate()) {
//                     if(_imageFile == null){
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Please upload authorized picture'),
//                           backgroundColor: Colors.redAccent,
//                         ),
//                       );
//                       return;
//                     }
//                     _formKey.currentState!.save();
//                     // Handle form submission
//                     final studentDocId = studentController.studentParent.value!.docId;
//                     final dismissalId = userController.user.value.id;
//                     SLoggerHelper.info('Student Doc ID: $studentDocId and Dismissal ID: $dismissalId');
//                     // Upload the image to Firebase Storage
//                     dismissalController.uploadAuthorizedPicture(studentDocId, dismissalId ?? '', _imageFile!.path);

//                     // Create the dismissal request
//                     dismissalController.createRequestDismissal(studentController.studentParent.value!.docId);

//                   }