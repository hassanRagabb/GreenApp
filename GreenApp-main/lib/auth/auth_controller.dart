import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green/manage_profile.dart';
import '../Customer_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import '../Customer_signup2.dart';
import '../login_page.dart';

//what is GetxController?
//GetxController is a class that will be used to store the data of the user

//AuthController is a class that will be used to store the data of the user
class AuthController extends GetxController {
  static AuthController instance = Get
      .find(); //this line means that we can access the AuthController class from anywhere in our app
  late Rx<User?>
      _user; //we used Rx because we want to update the user data in realtime(if the user data changes in the firebase)
  FirebaseAuth auth = FirebaseAuth
      .instance; //we used FirebaseAuth to handle the authentication and access alot of properties of firebase auth

  User? get user => _user.value;
  @override
  void onReady() {
    //onReady is a function that will be called when the AuthController class is ready
    super.onReady();
    _user = Rx<User?>(
        auth.currentUser); //we initialized the user with the current user
    _user.bindStream(auth
        .userChanges()); //if the user logged in or logged or.. the _user will be updated or notfied
    ever(_user,
        _initialScreen); //ever is a function that will be called when the _user changes
    //whenver _user changes like when the user logged in or logged out the _initialScreen function will be called
    //so _intialScreen will be a listener for _user
  }

  _initialScreen(User? user) {
    //this function will be called when the app starts
    if (user == null) {
      //if the user is null we will navigate to the login page, null means that the user is not logged in
      print("login page");
      Get.offAll(() =>
          LoginPage()); //we used Get.offAll to navigate to the login page and remove all the previous pages from the stack
    } else {
      //if the user is not null we will navigate to the welcome page
      //Get.offAll(() => WelcomePage(email: user.email!));
    }
  }

  void register(
      String email,
      String password,
      String firstname,
      String lastname,
      String phone,
      String gardenSize,
      String budget,
      String category) async {
    //check if all the fields are not empty including firstname, lastname and phone
    if (email.isEmpty ||
        password.isEmpty ||
        firstname.isEmpty ||
        lastname.isEmpty ||
        phone.isEmpty ||
        gardenSize.isEmpty ||
        budget.isEmpty ||
        category.isEmpty) {
      Get.snackbar(
        "About User ",
        "User message",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          "Account Creation falied, Please fill all the fields",
          style: TextStyle(color: Colors.white),
        ),
        messageText: const Text(
          "Account Creation falied, Please fill all the fields",
          style: TextStyle(color: Colors.white),
        ),
      );
      return;
    }

    try {
      //we used async and await because we want to wait for the user to be created
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      //add user details to firestore
      User? user = auth.currentUser;
      if (user != null) {
        // User is not null, add user details to firestore
        await addUserDetails(
          user.uid, // Pass the user's uid as the userId
          firstname,
          lastname,
          email,
          phone,
          gardenSize,
          budget,
          category,
        );
      }
      Navigator.push(
        Get.context!,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      Get.snackbar("About User ", "User message",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text(
            "Account Creation falied",
            style: TextStyle(color: Colors.white),
          ),
          messageText: Text(
            e.toString(),
            style: const TextStyle(color: Colors.white),
          ));
    }
  }

  // Future addUserDetails(
  //     String firstName,
  //     String lastName,
  //     String email,
  //     String phoneNumber,
  //     String gardenSize,
  //     String budget,
  //     String category) async {
  //   await FirebaseFirestore.instance.collection('users').add({
  //     'first_name': firstName,
  //     'last_name': lastName,
  //     'email': email,
  //     'phone_number': phoneNumber,
  //     'garden_size': gardenSize,
  //     'budget': budget,
  //     'category': category,
  //   });
  // }
  Future<void> addUserDetails(
    String userId,
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
    String gardenSize,
    String budget,
    String category,
  ) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'garden_size': gardenSize,
      'budget': budget,
      'category': category,
    });
  }

  Future<bool> login(
      BuildContext context, String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return true; // Authentication successful
    } catch (e) {
      // Show error message using GetX's snackbar
      Get.snackbar("About Login", "Login message",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text(
            "Login falied",
            style: TextStyle(color: Colors.white),
          ),
          messageText: Text(
            e.toString(),
            style: const TextStyle(color: Colors.white),
          ));
      return false; // Authentication failed
    }
  }

  // Update user details in Firestore
  Future<void> updateUserDetails(
    String userId,
    String firstName,
    String lastName,
    String phoneNumber,
    String gardenSize,
    String budget,
    String category,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phoneNumber,
        'garden_size': gardenSize,
        'budget': budget,
        'category': category,
      });
    } catch (e) {
      Get.snackbar(
        "Update Failed",
        e.toString(),
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          "Update Failed",
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
  }

  void logOut() async {
    await auth.signOut();
  }

  //By using async and await, the register method waits for the user to be
  //created before moving on to the next line of code. This helps to ensure
  //that the user creation process is completed before any other operations
  //are performed, such as navigating to a different screen or updating the UI
}
