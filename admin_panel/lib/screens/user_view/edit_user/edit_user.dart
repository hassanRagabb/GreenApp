// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:admin_panel/constants/constants.dart';
import 'package:admin_panel/helpers/firebase_storage_helper/firebase_storage_helper.dart';
import 'package:admin_panel/models/user_model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../provider/app_provider.dart';

class EditUser extends StatefulWidget {
  final UserModel userModel;
  final int index;
  const EditUser({super.key, required this.userModel, required this.index});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  File? profilePhotoURL;
  void takePicture() async {
    XFile? value = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 40);
    if (value != null) {
      setState(() {
        profilePhotoURL = File(value.path);
      });
    }
  }

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        children: [
          const SizedBox(
            height: 60.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Constants.primaryColor.withOpacity(.15),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Constants.primaryColor,
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Edit User',
                  style: TextStyle(
                    color: Color(0xff296e48),
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          profilePhotoURL == ""
              ? CupertinoButton(
                  onPressed: () {
                    takePicture();
                  },
                  child: const CircleAvatar(
                      backgroundColor: Color(0xff296e48),
                      radius: 55,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      )),
                )
              : CupertinoButton(
                  onPressed: () {
                    takePicture();
                  },
                  child: CircleAvatar(
                    backgroundImage: FileImage(profilePhotoURL!),
                    radius: 55,
                  ),
                ),
          const SizedBox(
            height: 12.0,
          ),
          TextFormField(
            controller: firstName,
            decoration: InputDecoration(
              hintText: widget.userModel.firstName,
              filled: true,
              fillColor: const Color(0xFFE5ECE8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xff296e48),
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          TextFormField(
            controller: lastName,
            decoration: InputDecoration(
              hintText: widget.userModel.lastName,
              filled: true,
              fillColor: const Color(0xFFE5ECE8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xff296e48),
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          Container(
            decoration: BoxDecoration(
              color: Constants.primaryColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 1),
                  blurRadius: 5,
                  color: Constants.primaryColor.withOpacity(.3),
                ),
              ],
            ),
            child: TextButton(
              onPressed: () async {
                if (profilePhotoURL == null &&
                    firstName.text.isEmpty &&
                    lastName.text.isEmpty) {
                  Navigator.of(context).pop();
                } else if (profilePhotoURL != null) {
                  String imageUrl = await FirebaseStorageHelper.instance
                      .uploadUserImage(
                          widget.userModel.userId, profilePhotoURL!);
                  UserModel userModel = widget.userModel.copyWith(
                    profilePhotoURL: imageUrl,
                    firstName: firstName.text.isEmpty ? null : firstName.text,
                    lastName: lastName.text.isEmpty ? null : lastName.text,
                  );
                  appProvider.updateUserList(widget.index, userModel);
                  showMessage("Update Successfully");
                } else {
                  UserModel userModel = widget.userModel.copyWith(
                    firstName: firstName.text.isEmpty ? null : firstName.text,
                    lastName: lastName.text.isEmpty ? null : lastName.text,
                  );
                  appProvider.updateUserList(widget.index, userModel);
                  showMessage("Update Successfully");
                }

                // appProvider.updateUserInfoFirebase(context, userModel, image);
              },
              child: const Center(
                child: Text(
                  'Update',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
