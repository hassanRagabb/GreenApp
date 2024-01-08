import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import '../login_page.dart';

class SellerAuthController extends GetxController {
  static SellerAuthController get to => Get.find();
  late Rx<User?> _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxBool isSeller = false.obs;

  User? get user => _user.value;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(_auth.currentUser);
    _user.bindStream(_auth.userChanges());
    ever(_user, _initialScreen);
  }

  void _initialScreen(User? user) {
    if (user == null) {
      print("login page");
      Get.offAll(() => const LoginPage());
    } else {
      // Check if the user is a Seller
      checkSeller(user.email ?? '');
    }
  }

  Future<void> register(
    String email,
    String password,
    String firstName,
    String lastName,
    String phone,
    File? profileImageFile,
    File? idImageFile,
  ) async {
    if (email.isEmpty ||
        password.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty ||
        phone.isEmpty) {
      Get.snackbar(
        "Account Creation Failed",
        "Please fill all the fields",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          "Account Creation Failed",
          style: TextStyle(color: Colors.white),
        ),
        messageText: const Text(
          "Please fill all the fields",
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

      // Upload the ID photo and get the photo URL
      String idPhotoURL = '';
      if (idImageFile != null) {
        idPhotoURL = await uploadIDPhotoAndGetURL(idImageFile);
      }

      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user != null) {
        await addSellerDetails(
          user.uid,
          firstName,
          lastName,
          email,
          phone,
          profilePhotoURL,
          idPhotoURL,
        );

        FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'profilePhotoURL': profilePhotoURL,
          'idPhotoURL': idPhotoURL,
        });
      }

      Navigator.push(
        Get.context!,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
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

  Future<void> addSellerDetails(
      String userId,
      String firstName,
      String lastName,
      String email,
      String phoneNumber,
      String photoURL,
      String idPhotoURL) async {
    try {
      DocumentReference sellerRef =
          FirebaseFirestore.instance.collection('Sellers').doc(email);

      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await sellerRef.get() as DocumentSnapshot<Map<String, dynamic>>;
      if (snapshot.exists) {
        print('Document $email already exists!');
        return;
      }

      await sellerRef.set({
        'userId': userId,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone_number': phoneNumber,
        'profilePhotoURL': photoURL,
        'idPhotoURL': idPhotoURL,
      });
    } catch (e) {
      print('Error adding Seller details: $e');
    }
  }

  Future<bool> loginSeller(
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
      if (user != null) {
        final bool isSeller = await checkSeller(email);
        if (!isSeller) {
          throw Exception("No Seller with these credentials was found!");
        }
      }
      // If checkSeller doesn't throw an exception, the login is successful
      return true;
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Login Failed"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: const Text("No Seller with these credentials was found!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.green, // Set the color to green
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

  Future<bool> checkSeller(String? email) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection("Sellers").doc(email).get();

    return snapshot.exists;
  }

  Future<void> updateSellerDetails(
    String userId,
    String firstName,
    String lastName,
    String phoneNumber,
  ) async {
    try {
      String documentName = userId;
      DocumentReference SellerRef =
          FirebaseFirestore.instance.collection('Sellers').doc(documentName);

      await SellerRef.update({
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phoneNumber,
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
    await _auth.signOut();
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

  Future<String> uploadIDPhotoAndGetURL(File imageFile) async {
    try {
      // Generate a unique filename for the image
      String fileName = path.basename(imageFile.path);

      // Create a reference to the location where the file will be uploaded
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('id_photos')
          .child(fileName);

      // Upload the file to Firebase Storage
      await ref.putFile(imageFile);

      // Retrieve the download URL for the uploaded file
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading ID photo: $e');
      rethrow;
    }
  }
}
