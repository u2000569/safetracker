import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:safetracker/common/widgets/appbar/appbar.dart';
import 'package:safetracker/utils/constants/sizes.dart';

import '../../../../common/widgets/layouts/grid_layout.dart';
import '../../../../common/widgets/student_cards/student_card_vertical.dart';
import '../../../../data/repositories/student/student_repository.dart';
import '../../controllers/all_student_controller.dart';
import '../../models/student_model.dart';

class AllStudents extends StatelessWidget {
  AllStudents({super.key, required this.title, this.query, this.futureMethod});

  final String title;

  final Query? query;

  final Future<List<StudentModel>>? futureMethod;
  final studentRepository = Get.put(StudentRepository());

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(AllStudentController());
    return Scaffold(
      appBar: SAppBar(title: Text(title), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SSizes.defaultSpace),
          child: FutureBuilder<List<StudentModel>>(
            future: futureMethod ?? controller.fetchStudentByQuery(query),
            builder: (_, snaphot){
              if (snaphot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if(snaphot.hasError) {
                return Center(child: Text('Error: ${snaphot.error}'));
              } else if(!snaphot.hasData || snaphot.data!.isEmpty) {
                return const Center(child: Text('No student found'));
              } else{
                final students = snaphot.data!;
                return SSortableStudentList(students: students);
              }
              // check the state of the futurebuilder snapshot
              // const loader = SVerticalStudentShimmer();
              // final widget = SCloudHelperFunctions.checkMultiRecordState(snaphot: snaphot, loader: loader);

              // return widget;
              // if(widget != null) return widget;

              //Student found
              // final students = snaphot.data!;
              // return SSortableStudentList(students: students);
            },
          ),
        ),
      ),
    );
  }
}

class SSortableStudentList extends StatelessWidget {
  const SSortableStudentList({
    super.key, 
    required this.students
  });

  final List<StudentModel> students;

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(AllStudentController());

    controller.assignStudents(students);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Obx(
              () => Expanded(
                child: DropdownButtonFormField(
                  isExpanded: true,
                  decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
                  value: controller.selectedSortOption.value,
                  onChanged: (value) {
                    //Sort students based on selected option
                    controller.sortStudents(value!);
                  },
                  items: ['name', 'Grade'].map((option){
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                )
              )
            ),
            )
            
          ],
        ),
        const SizedBox(height: SSizes.spaceBtwSections),

        // Student List grid
        Obx(
          () => SGridLayout(
            itemBuilder: (_, index) => SStudentCardVertical(student: controller.students[index], isNetworkImage: true),
            itemCount: controller.students.length,
          )
        )
      ],
    );
  }
}