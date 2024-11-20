import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:safetracker/screens/authentication/userregister.dart';
import 'package:safetracker/screens/wrapper.dart';
import '../../components/button.dart';
import '../../components/my_textfield.dart';
import '../../services/auth_services.dart';

class UserSignIn extends StatefulWidget {
  const UserSignIn({super.key});

  @override
  State<UserSignIn> createState() => _UserSignInState();
}

class _UserSignInState extends State<UserSignIn> {
  final AuthServices _auth = AuthServices();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final Logger _logger = Logger();

  void signUserIn() async {
    dynamic results = await _auth.signInWithEmailAndPassword(
      emailController.text,
      passwordController.text
    );
    if (results[0] == 1) {
      _logger.i("Failed to login: ${results[1]}");
      var snackBar = SnackBar(
        content: Text(results[1]),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      Navigator.pushReplacementNamed(context, '/wrapper');
      _logger.i("Success login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(237, 240, 245, 1),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(height: 50),
                const Text(
                  'Sign In',
                  style: TextStyle(
                    color: Color.fromRGBO(9, 31, 91, 1),
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Please sign in to continue',
                  style: TextStyle(
                    color: Color.fromRGBO(9, 31, 91, 0.5),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                //username
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 25),
                //password
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10,),
                GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, "/auth/forgetPassword");
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 25),
                    alignment: Alignment.topLeft,
                    child: const Text("Forget Password?",
                    style: TextStyle(color: Colors.blue),
                    textAlign: TextAlign.start,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    ),
                  ),
                ),
                //signin button
                const SizedBox(height: 25),
                Button(
                  text: 'Sign In',
                  onTap: signUserIn,
                ),
                const SizedBox(height: 20,),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const UserRegister()));
                  },
                  child: const Text('Don\'t have an account? Register'),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}
