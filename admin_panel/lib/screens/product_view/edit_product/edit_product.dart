// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:admin_panel/helpers/firebase_storage_helper/firebase_storage_helper.dart';
import 'package:admin_panel/models/product_model/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';
import '../../../provider/app_provider.dart';

class EditProduct extends StatefulWidget {
  final ProductModel productModel;
  final int index;
  const EditProduct(
      {super.key, required this.productModel, required this.index});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  File? image;
  void takePicture() async {
    XFile? value = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 40);
    if (value != null) {
      setState(() {
        image = File(value.path);
      });
    }
  }

  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();

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
                  'Edit Product',
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
          image == null
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
                    backgroundImage: FileImage(image!),
                    radius: 55,
                  ),
                ),
          const SizedBox(
            height: 12.0,
          ),
          TextFormField(
            controller: name,
            decoration: InputDecoration(
              hintText: widget.productModel.name,
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
            controller: description,
            maxLines: 9,
            decoration: InputDecoration(
              hintText: widget.productModel.description,
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
          const SizedBox(height: 12.0),
          TextFormField(
            controller: price,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "\$${widget.productModel.price.toString()}",
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
                if (image == null &&
                    name.text.isEmpty &&
                    description.text.isEmpty &&
                    price.text.isEmpty) {
                  Navigator.of(context).pop();
                } else if (image != null) {
                  String imageUrl = await FirebaseStorageHelper.instance
                      .uploadUserImage(widget.productModel.id, image!);
                  ProductModel productModel = widget.productModel.copyWith(
                    description:
                        description.text.isEmpty ? null : description.text,
                    image: imageUrl,
                    name: name.text.isEmpty ? null : name.text,
                    price: price.text.isEmpty ? null : price.text,
                  );

                  appProvider.updateProductList(widget.index, productModel);
                  showMessage("Updated Successfully");
                } else {
                  ProductModel productModel = widget.productModel.copyWith(
                    description:
                        description.text.isEmpty ? null : description.text,
                    name: name.text.isEmpty ? null : name.text,
                    price: price.text.isEmpty ? null : price.text,
                  );

                  appProvider.updateProductList(widget.index, productModel);
                  showMessage("Updated Successfully");
                }

                // appProvider.updateUserInfoFirebase(context, userModel, image);
              },
              child: const Center(
                child: Text(
                  'Update',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
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
