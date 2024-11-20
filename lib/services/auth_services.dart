import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import '../model/newuser.dart';
import 'database_services.dart';
import 'userpreference_services.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  //Register New User
  Future signUpWithEmailAndPassword(
    String email,
    String password,
    String name, 
    String phoneNumber, 
    String role)async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
      User user = result.user!;

      await UserPreference.init();
      // add uid to SharedPreferences for easy access
      await UserPreference.setValue("uniqueId", user.uid);
      _logger.i('Register Success');
      
      //initialize user Database on successful registration
     DatabaseService(uid: user.uid)
      ..updateUserData(
        name,
        phoneNumber,
        email,
        role)
       ..buildStudentData()
       ..buildUserLog();
      //  return [0, 'Logged in successfully'];  
    }on FirebaseAuthException catch (e){
      if (e.code == 'email-already-in-use') {
        _logger.i("The account already exists for that email.");
        return [1, 'The account already exists for that email.'];
      } else if (e.code == 'weak-password') {
        _logger.i("The password provided is too weak");
        return [1, 'The password provided is too weak'];
      } else {
        _logger.i("fail register");
        return [1, e.code];
      }
    } catch (e) {
      return [1, e.toString()];
    }
  }

  //Sign In User
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(), password: password);
      User user = result.user!;

      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await _firestore.collection('Users').doc(user.uid).get();
      if (userDoc.exists && userDoc['status'] == 'approved') {
        // Initialize SharedPreferences before setting values
        await UserPreference.init();
        // Add uid to SharedPreferences for easy access
        await UserPreference.setValue("uniqueId", user.uid);
        _logger.i('Login Success in auth service');
        return [0, 'Logged in successfully'];
      } else {
        await _auth.signOut();
        _logger.i('Account not approved');
        return [1, 'Your account is not approved yet.'];
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _logger.i('No user found');
        return [1, 'No user found for that email'];
      } else if (e.code == 'wrong-password') {
        _logger.i('Wrong password');
        return [1, 'Wrong password'];
      } else {
        return [1, e.code];
      }
    } catch (e) {
      return [1, e.toString()];
    }
  }
  //change password
  void changePassword(String password) async {
  User user = FirebaseAuth.instance.currentUser!;
  user.updatePassword(password).then((_) {
    _logger.i("Successfully Change Password");
  }).catchError((error) {
    _logger.i("Password can't be changed " + error.toString());
  });
  }

  //signout method
  void signout() async{
    _logger.i('signout');
    await _auth.signOut();
  }

  //reset passwrod
  Future resetPassword({required String email}) async {
  List<dynamic> status = [];
  await _auth
      .sendPasswordResetEmail(email: email)
      .then((value) => status = [0, "Reset Successfully"])
      .catchError((e) => status = [1, "Reset Unsuccessfully"]);

  return status;
  }

  // Converts a Firebase user to NewUserData by fetching the data from Firestore.
  Future<NewUserData?> _newUserDataFromFirebaseUser(User? user) async {
    if (user == null) {
      _logger.i("No User Detect");
      return null;
    }
    var snap = await DatabaseService(uid: user.uid).getNewUserDataSnapshot(user);
    if (snap == null || snap.data() == null) {
      _logger.i("Empty Data");
      return null;
    }
    _logger.i('returning NewUserData');
    return NewUserData.fromMap(snap.data() as Map<String, dynamic>);
  }

  //A stream that listens to authentication state changes and converts Firebase user to NewUserData.
  Stream<NewUserData?> get newUserData {
    _logger.i("listen stream to authentication state changes");
    return _auth.authStateChanges().asyncMap(_newUserDataFromFirebaseUser).handleError((error) {
      _logger.e("Error in authStateChanges stream: $error");
      return null;
    });
  }
}
