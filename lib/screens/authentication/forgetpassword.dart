import 'package:flutter/material.dart';
import 'package:safetracker/components/backButton.dart';
import 'package:safetracker/services/auth_services.dart';
import 'package:safetracker/components/buildText.dart';
import 'package:safetracker/components/buildTextBox.dart';
import 'package:safetracker/components/constants.dart';
import 'package:google_fonts/google_fonts.dart';


class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  final AuthServices _authServices = AuthServices();
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repasswordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/women.png'),
            alignment: Alignment.center,
            fit: BoxFit.cover
            ),
        ),
        child: Stack(
          children: [
            CustomButton.backButton(context, 30 , 12.5),
            Container(
              margin: const EdgeInsets.only(top: 200),
              padding: const EdgeInsets.only(left: 40, bottom: 5, right: 40),
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: buildText.labelText("Recovery Email"),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: buildText.heading3Text(
                        "A verification email will be sent to change your password."),
                  ),
                  buildTextBox.authenticateTextBox(
                      emailController,
                      'Enter your recovery email',
                      false,
                      false,
                      'Please enter some text'),
                      Padding(padding: const EdgeInsets.only(top: 30),
                      child: GestureDetector(
                        onTap: () async{
                          dynamic results = await _authServices.resetPassword(
                            email: emailController.text);
                            if (results[0] == 1) {
                            // login fail
                            var snackBar = const SnackBar(
                              content:
                                  Text("Reset password fail. Please try again"),
                              backgroundColor: kPurpleLight,
                            );

                            // Find the ScaffoldMessenger in the widget tree
                            // and use it to show a SnackBar.
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }else {
                            //login fail
                            var snackBar = const SnackBar(
                              content: Text(
                                  "A change password email has been sent to you account."),
                              backgroundColor: kPurpleLight,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Navigator.pushReplacementNamed(
                                context, '/auth/signIn');
                          }
                        },
                        child: Stack(children: <Widget>[
                          Center(
                            child: Container(
                              alignment: Alignment.center,
                              width: 200,
                              decoration: const BoxDecoration(
                                 borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                        boxShadow: [
                                          BoxShadow(
                                          color: kButtonShadow,
                                          offset: Offset(6, 6),
                                          blurRadius: 6,
                                          ),
                                        ]
                              ),
                              // child: Image.asset(
                              //   'assets/images/women.png'
                              // ),
                            ),
                          ),
                          Container(
                            height: 40,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              'Send email',
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: kTextLight,
                              ),
                            )
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
