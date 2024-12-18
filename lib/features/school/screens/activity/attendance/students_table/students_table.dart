import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safetracker/features/school/controllers/student/student_controller.dart';

import '../../../../../../common/widgets/data_table/paginated_data_table.dart';
import 'source_student_table.dart';

class StudentsTable extends StatelessWidget {
  const StudentsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StudentController());
    return Obx(
      (){
        // table
        return SPaginatedDataTable(
          minWidth: 100,
          sortAscending: controller.sortAscending.value,
          sortColumnIndex: controller.sortColumnIndex.value,
          columns: [
            DataColumn2(
              label: const Text('Student'),
              onSort: (columnIndex, ascending) => controller.sortByName(columnIndex, ascending),
            ),
            // const DataColumn2(label: Text('Student ID')),
            const DataColumn2(label: Text('Grade')),
            const DataColumn2(label: Text('Status')),
          ],
          source: StudentRows(),
        );
      }
    );
  }
}