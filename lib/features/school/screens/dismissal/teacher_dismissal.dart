import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:safetracker/utils/logging/logger.dart';

import '../../controllers/dismissalController/dismissal_controller.dart';
import 'detail_dismissal.dart';

class TeacherDismissal extends StatefulWidget {
  const TeacherDismissal({super.key});

  @override
  State<TeacherDismissal> createState() => _TeacherDismissalState();
}

class _TeacherDismissalState extends State<TeacherDismissal> {
  final dismissalController = Get.put(DismissalController());
  final TabController _tabController = TabController(length: 3, vsync: ScrollableState());

  @override
  void initState(){
    super.initState();
    //fetch data for the first tab (default)
    dismissalController.fetchDismissals('parent');
    _tabController.addListener((_onTabChange));
  }

  void _onTabChange(){
    if (_tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 0:
          dismissalController.fetchDismissals('parent');
          break;
        case 1:
          dismissalController.fetchDismissals('authorizedPerson');
          break;
        case 2:
          dismissalController.fetchDismissals('walking');
          break;
      }
    }
  }

   @override
  void dispose() {
    _tabController.removeListener(_onTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, 
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dismissal Requests'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Parent Pickup'),
              Tab(text: 'Authorized Pickup'),
              Tab(text: 'Cycling / Walking')
            ]
          ),
        ),
        body: Obx(() {
          // Loading
          if(dismissalController.studentsWithDismissals.isEmpty){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Display list of dismissals
          return ListView.builder(
            itemCount: dismissalController.studentsWithDismissals.length,
            itemBuilder: (context, index){
              final student = dismissalController.studentsWithDismissals[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(student['name']),
                  subtitle: Text('Grade: ${student['grade']}'),
                  trailing: IconButton(
                    icon: const Icon(Iconsax.info_circle),
                    onPressed: (){
                      // navigate to student dismissal details
                      if(mounted){
                        Get.to(() => StudentDismissalDetailScreen(
                          studentId: student['id'],
                          dismissalRequests: [student],
                        ));
                      }
                    },
                  ),
                ),
              );
            }
          );
        }),
        
        
        // TabBarView(
        //   children: [
        //     _buildStreamBuilder('parent'),
        //     _buildStreamBuilder('authorized'),
        //     _buildStreamBuilder('walking')
        //   ],
        // ),
      )
    );
  }
}

Widget _buildStreamBuilder(String category){
  final dismissalController = Get.put(DismissalController());
  return StreamBuilder<List<Map<String, dynamic>>>(
    stream: dismissalController.streamDismissal(category), 
    builder: ((context, snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting){
        SLoggerHelper.info('Waiting for data');
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if(!snapshot.hasData || snapshot.data!.isEmpty){
        return const Center(
          child: Text(
            'No Dismissal Request',
            style: TextStyle(fontSize: 16),
          ),
        );
      }

      final students = snapshot.data!;
      return ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index){
          final student = students[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(student['name']),
              // subtitle: Text('Class: ${student['authorizedPickupName']}'),
              subtitle: Text('Grade: ${student['grade']}'),
              trailing: IconButton(
                icon: const Icon(Iconsax.info_circle),
                onPressed: (){
                },
              ),
            ),
          );
        }
      );

    })
    );
}
