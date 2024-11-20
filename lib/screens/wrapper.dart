import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safetracker/components/bot_navigation.dart';
import 'package:safetracker/screens/authentication/usersignin.dart';
import '../model/newuser.dart';


class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    //final User? user = FirebaseAuth.instance.currentUser;
    final user = Provider.of<NewUserData?>(context);
    if (user == null) {
      return const UserSignIn();
    } else {
      // Fetch the role and pass it to the BottomNav widget
      return BottomNav(role: user.role ?? '');
    }
  }
}
