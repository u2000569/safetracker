import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safetracker/utils/constants/enums.dart';
import 'package:safetracker/utils/formatters/formatter.dart';

class UserModel {
  // Keep those values final which you do not want to update
  final String? id;
  String firstName;
  String lastName;
  final String email;
  String phoneNumber;
  String profilePicture;
  final AppRole role;
  String roles;

  // List<AddressModel>? addresses;

  // Constructor
  UserModel({
    this.id,
    this.firstName = '',
    this.lastName = '',
    required this.email,
    this.phoneNumber = '',
    this.profilePicture = '',
    this.role = AppRole.user,
    this.roles = '',
  }); 

  /// Helper function to get the full name.
  String get fullName => '$firstName $lastName';

  /// Helper function to format phone number.
  String get formattedPhoneNo => SFormatter.formatPhoneNumber(phoneNumber);

  /// Static function to split full name into first and last name.
  static List<String> nameParts(fullName) => fullName.split(" ");

  /// Static function to generate a username from the full name.
  static String generateUsername(fullName) {
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseUsername = "$firstName$lastName"; // Combine first and last name
    String usernameWithPrefix = "cwt_$camelCaseUsername"; // Add "cwt_" prefix
    return usernameWithPrefix;
  }

  /// Static function to create an empty user model.
  static UserModel empty() => UserModel( email: '', role: AppRole.user, firstName: '', lastName: '', phoneNumber: '', profilePicture: '' ,roles: '');

  /// Convert model to JSON structure for storing in Firestore.
  Map<String, dynamic> toJson() {
    return{
    'FirstName': firstName,
    'LastName': lastName,
    'Email': email,
    'PhoneNumber': phoneNumber,
    'ProfilePicture': profilePicture,
    'Role': roles
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) return UserModel.empty();
    AppRole userRole;
    switch (data['Role']) {
      case 'parent':
        userRole = AppRole.parent;
        break;
      case 'teacher':
        userRole = AppRole.teacher;
        break;
      default:
        userRole = AppRole.admin;
    }
    return UserModel(
      id: data['Id'] ?? '',
      firstName: data['FirstName'] ?? '',
      lastName: data['LastName'] ?? '',
      email: data['Email'] ?? '',
      phoneNumber: data['PhoneNumber'] ?? '',
      profilePicture: data['ProfilePicture'] ?? '',
      roles: data['Role'] ?? '',
      role: userRole
      // createdAt: data['CreatedAt']?.toDate() ?? DateTime.now(),
      // updatedAt: data['UpdatedAt']?.toDate() ?? DateTime.now(),
    );
  }

  /// factory method to create a user model from a Firebase document snapshot
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    if(document.data() != null) {
     final data = document.data()!;
     return UserModel(
        id: document.id,
        firstName: data.containsKey('FirstName') ? data['FirstName'] ?? '' : '',
        lastName: data.containsKey('LastName') ? data['LastName'] ?? '' : '',
        email: data.containsKey('Email') ? data['Email'] ?? '' : '',
        phoneNumber: data.containsKey('PhoneNumber') ? data['PhoneNumber'] ?? '' : '',
        profilePicture: data.containsKey('ProfilePicture') ? data['ProfilePicture'] ?? '' : '',
        roles: data.containsKey('Role') ? data['Role'] ?? '' : '',
     ); 
    } else {
      return empty();
    }
  }
}