import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import '../Admin/admin_home_page.dart';
import '../Customer/home_page.dart';
import '../login_page.dart';
import '../Customer/Recommendation.dart';
//what is GetxController?
//GetxController is a class that will be used to store the data of the user

//AuthController is a class that will be used to store the data of the user
class UserAuthController extends GetxController {
  static UserAuthController instance = Get.find();

  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _user.value;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
  }

  void register(
    String email,
    String password,
    String firstname,
    String lastname,
    String phone,
    String gardenSize,
    int? budget,
    String category,
    String City,
    bool isAdmin,
    File? profileImageFile,
  ) async {
    if (email.isEmpty ||
        password.isEmpty ||
        firstname.isEmpty ||
        lastname.isEmpty ||
        phone.isEmpty ||
        gardenSize.isEmpty ||
        budget == null ||
        category.isEmpty ||
        City.isEmpty) {
      Get.snackbar(
        "About User",
        "User message",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          "Account Creation failed",
          style: TextStyle(color: Colors.white),
        ),
        messageText: const Text(
          "Please fill in all the fields!",
          style: TextStyle(color: Colors.white),
        ),
      );
      return;
    }

    try {
      // Upload the profile photo and get the photo URL
      String profilePhotoURL = '';
      if (profileImageFile != null) {
        profilePhotoURL = await uploadProfilePhotoAndGetURL(profileImageFile);
      }

      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = auth.currentUser;
      if (user != null) {
        await addUserDetails(
          user.uid,
          firstname,
          lastname,
          email,
          phone,
          gardenSize,
          budget,
          category,
          City,
          profilePhotoURL,
          isAdmin,
        );
      }
      Get.to(() => const LoginPage());
      //Get.to(() => RecommendationPage(userId: user!.uid,));
    } catch (e) {
      Get.snackbar(
        "About User",
        "User message",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          "Account Creation failed",
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
  }

  Future<bool> checkUser(String? email) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection("users").doc(email).get();

    return snapshot.exists;
  }

  Future<bool> checkAdminStatus(String? email) async {
    try {
      if (email == null) {
        print('User email is null');
        return false;
      }

      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: email)
              .get();
      print('isAdmin inside the function: $email');
      if (snapshot.docs.isNotEmpty) {
        final Map<String, dynamic> userData = snapshot.docs.first.data();
        final bool isAdmin = userData['isAdmin'] as bool? ?? false;
        return isAdmin;
      } else {}
    } catch (e, stackTrace) {
      print('Error checking admin status: $e\n$stackTrace');
    }

    return false;
  }

  Future<void> addUserDetails(
    String userId,
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
    String gardenSize,
    int budget,
    String category,
    String City,
    String profilePhotoURL,
    bool isAdmin,
  ) async {
    String documentName = email;
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(documentName);

    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await userRef.get() as DocumentSnapshot<Map<String, dynamic>>;
    if (snapshot.exists) {
      print('Document $documentName already exists!');
      return;
    }

    await userRef.set({
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'garden_size': gardenSize,
      'budget': budget,
      'isAdmin': false,
      'category': category,
      'City': City,
      'profile_photo_url': profilePhotoURL,
    });
  }

  Future<bool> loginUser(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = _auth.currentUser;
      if (await checkUser(email)) {
        final bool isAdmin =
            await checkAdminStatus(user!.email); // Check admin status
        print('isAdmin = $isAdmin');
        if (isAdmin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminHomePage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
        return true;
      } else {
        // Code to handle when checkUser returns false
        // Nothing will execute here if checkUser is false
        return false;
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Login Failed"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: const Text("No User with these credentials was found!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          );
        },
      );
      return false;
    }
  }

  Future<void> updateUserDetails(
    String userId,
    String firstName,
    String lastName,
    String phoneNumber,
    String gardenSize,
    int budget,
    String category,
    bool isAdmin,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phoneNumber,
        'garden_size': gardenSize,
        'budget': budget,
        'category': category,
        'isAdmin': false,
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

  Future<String> uploadProfilePhotoAndGetURL(File imageFile) async {
    try {
      // Generate a unique filename for the image
      String fileName = path.basename(imageFile.path);

      // Create a reference to the location where the file will be uploaded
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile_photos')
          .child(fileName);

      // Upload the file to Firebase Storage
      await ref.putFile(imageFile);

      // Retrieve the download URL for the uploaded file
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading profile photo: $e');
      rethrow;
    }
  }

  void logOut() async {
    await auth.signOut();
  }
}
