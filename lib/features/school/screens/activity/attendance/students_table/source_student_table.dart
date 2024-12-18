
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/s_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../controllers/student/student_controller.dart';

class StudentRows extends DataTableSource {
  final controller = StudentController.instance;

  @override
  DataRow? getRow(int index){
    final student = controller.filteredItems[index];
    return DataRow2(
      selected: controller.selectedRows[index],
      // onTap: () => Get.toNamed(SRoutes.editStudent, arguments: student),
      onSelectChanged: (value) => controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(
          Row(
            children: [
              // SRoundedImage(
              //   width: 50,
              //   height: 50,
              //   padding: const EdgeInsets.all(SSizes.xs),
              //   imageUrl: student.thumbnail,
              //   borderRadius: SSizes.borderRadiusMd,
              //   backgroundColor: SColors.primaryBackground,
              // ),
              const SizedBox(width: SSizes.spaceBtwItems),
              Flexible(child: Text(student.name, style: Theme.of(Get.context!).textTheme.bodyLarge!.apply(color: SColors.primary),)),
            ],
          )
        ),
        // DataCell(
        //   Row(
        //     children: [
        //       Flexible(
        //         child: Text(student.id, style: Theme.of(Get.context!).textTheme.bodyLarge!.apply(color: SColors.textPrimary),)
        //       )
        //     ],
        //   )
        //   ),
        DataCell(
          Row(
            children: [
              // SRoundedImage(
              //   width: 35,
              //   height: 35,
              //   padding: const EdgeInsets.all(SSizes.xs),
              //   borderRadius: SSizes.borderRadiusMd,
              //   backgroundColor: SColors.primaryBackground,
              //   imageUrl: student.grade?.thumbnail ?? '',
              // ),
              const SizedBox(width: SSizes.spaceBtwItems),
              Flexible(
                child: Text(
                  // student.grade != null ? student.grade!.name : '',
                  student.grade?.name ?? 'N/A',
                  style: Theme.of(Get.context!).textTheme.bodyLarge!.apply(color: SColors.primary),
                )
              ),
            ],
          )
        ),
        DataCell(SRoundedContainer(
            radius: SSizes.cardRadiusSm,
            padding: const EdgeInsets.symmetric(vertical: SSizes.sm, horizontal: SSizes.md),
            backgroundColor: SHelperFunctions.getStudentStatusColor(student.status).withOpacity(0.1),
            child: Text(
              student.status.name.capitalize.toString(),
              style: TextStyle(color: SHelperFunctions.getStudentStatusColor(student.status)),
            ),
          )
        ),
        // DataCell(Text(student.formattedAttendanceDate)),
        
      ]
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredItems.length;

  @override
  int get selectedRowCount => controller.selectedRows.where((selected) => selected).length;
}