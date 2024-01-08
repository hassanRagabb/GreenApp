// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:admin_panel/models/category_model/category_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';
import '../../../provider/app_provider.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({
    super.key,
  });

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
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
  TextEditingController size = TextEditingController();
  TextEditingController temperature = TextEditingController();
  TextEditingController humidity = TextEditingController();
  TextEditingController rating = TextEditingController();
  TextEditingController color = TextEditingController();
  CategoryModel? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 50.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
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
                    'Add Product',
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
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
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
                            ),
                          ),
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
                  const SizedBox(height: 12.0),
                  TextFormField(
                    controller: name,
                    decoration: InputDecoration(
                      hintText: "Product Name",
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
                  const SizedBox(height: 24.0),
                  TextFormField(
                    controller: description,
                    maxLines: 9,
                    decoration: InputDecoration(
                      hintText: "Product description",
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
                  const SizedBox(height: 24.0),
                  TextFormField(
                    controller: price,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Product Price \$ ",
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
                  const SizedBox(height: 24.0),
                  TextFormField(
                    controller: size,
                    decoration: InputDecoration(
                      hintText: "Size",
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
                  const SizedBox(height: 24.0),
                  TextFormField(
                    controller: color,
                    decoration: InputDecoration(
                      hintText: "Color",
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
                  const SizedBox(height: 24.0),
                  TextFormField(
                    controller: temperature,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Temperature °C",
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
                  const SizedBox(height: 24.0),
                  TextFormField(
                    controller: humidity,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Humidity",
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
                  const SizedBox(height: 24.0),
                  TextFormField(
                    controller: rating,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Rating",
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
                  const SizedBox(height: 24.0),
                  Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: const Color(0xFFE5ECE8),
                      inputDecorationTheme: InputDecorationTheme(
                        filled: true,
                        fillColor: const Color(0xFFE5ECE8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      hint: const Text(
                        'Please Select Category',
                      ),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      items: appProvider.getCategories.map((CategoryModel val) {
                        return DropdownMenuItem(
                          value: val,
                          child: Text(
                            val.name,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24.0),
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
                        if (image == null ||
                            _selectedCategory == null ||
                            name.text.isEmpty ||
                            description.text.isEmpty ||
                            price.text.isEmpty) {
                          showMessage("Please fill all the information");
                        } else {
                          appProvider.addProduct(
                            image!,
                            name.text,
                            _selectedCategory!.id,
                            price.text,
                            description.text,
                            size.text,
                            temperature.text,
                            humidity.text,
                            rating.text,
                            color.text,
                          );
                          showMessage("Added Successfully");
                        }

                        // appProvider.updateUserInfoFirebase(context, userModel, image);
                      },
                      child: const Center(
                        child: Text(
                          'Add',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
