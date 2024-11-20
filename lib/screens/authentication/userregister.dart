import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:safetracker/screens/authentication/usersignin.dart';
import 'package:safetracker/services/auth_services.dart';
import '../../components/button.dart';
import '../../components/my_textfield.dart';

class UserRegister extends StatefulWidget {
  const UserRegister({super.key});

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {

  final AuthServices _authServices = AuthServices();
  final _formKey = GlobalKey<FormState>();
  final Logger _logger = Logger();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  String selectedRole = '';

  void signUserUp() async{
    dynamic results = await _authServices.signUpWithEmailAndPassword(
      emailController.text, 
      passwordController.text,
      nameController.text,
      phoneNumberController.text,
      selectedRole
    );
    if (results[0] == 1) {
      _logger.i("Failed to SignUp: ${results[1]}");
      var snackBar = SnackBar(
        content: Text(results[1]),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      Navigator.pushReplacementNamed(context, "/login");
      _logger.i("Register Complete");
    }
  }

  // String email = "", password = "", name = "", phone = "",selectedRole ="";
  // TextEditingController nameController = TextEditingController();
  // TextEditingController passwordController = TextEditingController();
  // TextEditingController emailController = TextEditingController();
  // TextEditingController phoneNumberController = TextEditingController();


  // registration() async {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() {
  //       email = emailController.text;
  //       name = nameController.text;
  //       password = passwordController.text;
  //       phone = phoneNumberController.text;
  //     });
  //     try {
  //       UserCredential userCredential = await FirebaseAuth.instance
  //           .createUserWithEmailAndPassword(email: email, password: password);

  //       await DatabaseService(uid: userCredential.user?.uid).updateUserData(
  //         name, phone, email, selectedRole);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text("Register Success")));
  //       Navigator.push(context,
  //           MaterialPageRoute(builder: (context) => UserSignIn()));
  //     } on FirebaseAuthException catch (e) {
  //       if (e.code == 'weak-password') {
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //             backgroundColor: Colors.orangeAccent,
  //             content: const Text(
  //               "Password Provided is too Weak",
  //               style: TextStyle(fontSize: 18.0),
  //             )));
  //       } else if (e.code == "email-already-in-use") {
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //             backgroundColor: Colors.orangeAccent,
  //             content: const Text(
  //               "Account Already exists",
  //               style: TextStyle(fontSize: 18.0),
  //             )));
  //       }
  //     }
  //   }
  // }

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
                const Text(
                  'Register Account',
                  style: TextStyle(
                  color: Color.fromRGBO(9, 31, 91, 1),
                  fontSize: 24,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Create your account',
                  style: TextStyle(
                  color: Color.fromRGBO(9, 31, 91, 1),
                  fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      MyTextField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                      ),
                      const SizedBox(height: 25),
                      MyTextField(
                        controller: phoneNumberController,
                        hintText: 'Phone Number',
                        obscureText: false,
                      ),
                      const SizedBox(height: 25),
                      MyTextField(
                        controller: nameController,
                        hintText: 'Name',
                        obscureText: false,
                      ),
                      const SizedBox(height: 25),
                      MyTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: true,
                      ),
                      const SizedBox(height: 25.0,),
                      DropdownButtonFormField(
                        padding:const EdgeInsets.symmetric(horizontal: 25.0),
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                          focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        fillColor: Colors.white, 
                        filled: true,
                        hintText: 'Role'
                        ) ,
                        items: ['Teacher','Parent']
                        .map((role) => DropdownMenuItem(
                          value: role,
                          child: Text(role),
                          ))
                          .toList(), 
                          onChanged: (value){
                            setState(() {
                              selectedRole = value!;
                            });
                          })
                    ],
                  ),
                ),
              
                const SizedBox(height: 15),
                Button(
                  text: 'Register',
                  onTap: () {
                    _logger.i("attempt to register");
                    signUserUp();
                  },
                ),
               const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                      GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context)=> const UserSignIn()));
                      },
                      child:const Text(
                        ' Sign In',
                        style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                      ],
                    ),
                    

                    const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
