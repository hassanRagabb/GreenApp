import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth/user_auth_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController =
      TextEditingController(); //to get the text from the textfield
  final passwordController =
      TextEditingController(); //to get the text from the textfield
  final confirmPasswordController = TextEditingController();
  final firstNameController =
      TextEditingController(); //to get the text from the textfield
  final lastNameController =
      TextEditingController(); //to get the text from the textfield
  final phoneController =
      TextEditingController(); //to get the text from the textfield
  final _dropdownController =
      TextEditingController(); //to get the text from the textfield
  final _dropdownController2 =
      TextEditingController(); //to get the text from the textfield
  //to get the text from the textfield
  final budgetController =
      TextEditingController(); //to get the text from the textfield
  final _dropdownController3 =
      TextEditingController(); //to get the text from the textfield

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    _dropdownController.dispose();
    _dropdownController2.dispose();
    _dropdownController3.dispose();
    budgetController.dispose();
    super.dispose();
  }

  String dropdownValue = 'Small     < 30 m2';
  String dropdownValue2 = 'Coffee';
  String dropdownValue3 = ' ';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? selectedImage;
  @override
  Widget build(BuildContext context) {
    List images = [
      'img/g.png',
      'img/t.png',
      'img/f.png',
    ];
    List<String> items = ['Item 1', 'Item 2', 'Item 3'];
    String selectedItem;

    void onChanged(String value) {
      setState(() {
        selectedItem = value;
      });
    }

    bool isValidEmail(String email) {
      // Regular expression pattern for email validation
      const pattern =
          r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$';

      final regExp = RegExp(pattern);

      return regExp.hasMatch(email);
    }

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Customer Sign Up',
          style: TextStyle(color: Color(0xff296e48), fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          //to make the validation of the textfields
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () async {
                  final pickedImage =
                      await ImagePicker().getImage(source: ImageSource.gallery);
                  if (pickedImage != null) {
                    setState(() {
                      selectedImage = File(pickedImage.path);
                    });
                  }
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  child: selectedImage != null
                      ? ClipOval(
                          child: Image.file(
                            selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(
                          Icons.camera_alt,
                          size: 50,
                          color: Colors.grey,
                        ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Add your profile picture (optional)',
                  style: TextStyle(color: Color.fromARGB(255, 77, 77, 77))),
              const SizedBox(
                height: 25,
              ),
              Container(
                //to add decoration to the textfield
                margin: const EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    //to add shadow to the textfield
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 7,
                      //to make the shadow bigger
                      blurRadius: 10,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller:
                      emailController, //to get the text from the textfield
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 159, 159, 159)),
                    //email icon
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.green[700],
                    ),
                    focusedBorder: OutlineInputBorder(
                      //to change the border color when the textfield is focused
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      //to change the border color when the textfield is not focused
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!isValidEmail(value)) {
                      return 'Invalid email';
                    }
                    return null; // Return null to indicate validation passed
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                //to add decoration to the textfield
                margin: const EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    //to add shadow to the textfield
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 7,
                      //to make the shadow bigger
                      blurRadius: 10,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller:
                      passwordController, //to get the text from the textfield
                  obscureText: true, //to hide the password
                  decoration: InputDecoration(
                    hintText: 'Password',
                    //to change the color of the hint text
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 159, 159, 159)),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.green[700],
                    ),
                    focusedBorder: OutlineInputBorder(
                      //to change the border color when the textfield is focused
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      //to change the border color when the textfield is not focused
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                // Confirm password field
                margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 7,
                      blurRadius: 10,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 159, 159, 159)),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.green[700],
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                //to add decoration to the textfield
                margin: const EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    //to add shadow to the textfield
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 7,
                      //to make the shadow bigger
                      blurRadius: 10,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller:
                      firstNameController, //to get the text from the textfield
                  decoration: InputDecoration(
                    hintText: 'first name',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 159, 159, 159)),
                    //email icon
                    prefixIcon: Icon(
                      Icons.person_pin_outlined,
                      color: Colors.green[700],
                    ),
                    focusedBorder: OutlineInputBorder(
                      //to change the border color when the textfield is focused
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      //to change the border color when the textfield is not focused
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                //to add decoration to the textfield
                margin: const EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    //to add shadow to the textfield
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 7,
                      //to make the shadow bigger
                      blurRadius: 10,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller:
                      lastNameController, //to get the text from the textfield
                  decoration: InputDecoration(
                    hintText: 'last name',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 159, 159, 159)),
                    //email icon
                    prefixIcon: Icon(
                      Icons.person_pin_sharp,
                      color: Colors.green[700],
                    ),
                    focusedBorder: OutlineInputBorder(
                      //to change the border color when the textfield is focused
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      //to change the border color when the textfield is not focused
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                //to add decoration to the textfield
                margin: const EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    //to add shadow to the textfield
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 7,
                      //to make the shadow bigger
                      blurRadius: 10,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller:
                      phoneController, //to get the text from the textfield
                  obscureText: false, //to hide the password
                  decoration: InputDecoration(
                    hintText: 'phone number',
                    //to change the color of the hint text
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 159, 159, 159)),
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Colors.green[700],
                    ),
                    focusedBorder: OutlineInputBorder(
                      //to change the border color when the textfield is focused
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      //to change the border color when the textfield is not focused
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    if (value.length != 11 || !value.startsWith('0')) {
                      return 'Invalid phone number';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(right: 170),
                child: const Text(
                  'Choose your City:',
                  style: TextStyle(
                    color: Color.fromARGB(255, 99, 101, 98),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: 450,
                // Set the width of the dropdown button
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[300]!,
                  ),

                  //change the background of the container
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    //to add shadow to the textfield
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 7,
                      //to make the shadow bigger
                      blurRadius: 10,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: DropdownButton<String>(
                  value: dropdownValue3,
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue3 = value!;
                      _dropdownController3.text = value;
                    });
                  },
                  items: <String>[
                    ' ',
                    'Abu Simbel',
                    'Alexandria',
                    'Aswan',
                    'Asyut',
                    'Banha',
                    'Beni Suef',
                    'Cairo',
                    'Damanhur',
                    'Damietta',
                    'El Mahalla El Kubra',
                    'El Mansoura',
                    'El Minya',
                    'Faiyum',
                    'Giza',
                    'Ismaïlia',
                    'Kafr El Sheikh',
                    'New Cairo',
                    'Port Said',
                    'Qena',
                    'Tanta',
                    'Zagazig'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20), // Adjust the right padding here
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                  icon: const Icon(Icons.arrow_drop_down), // Set the icon
                  iconSize: 30, // Set the size of the icon
                  elevation: 16,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 30, 142, 24),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  dropdownColor: Colors.white,
                  isExpanded: true, // Set isExpanded to true
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 110),
                child: Text(
                  'Help us to know you better',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(right: 170),
                child: const Text(
                  'Size of your garden:',
                  style: TextStyle(
                    color: Color.fromARGB(255, 99, 101, 98),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: 300, // Set the width of the dropdown button
                child: DropdownButton<String>(
                  value: dropdownValue,
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                      _dropdownController.text = value;
                    });
                  },
                  items: <String>[
                    'Small     < 30 m2',
                    'Medium      30 - 60 m2',
                    'Large      > 60 m2'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  icon: const Icon(Icons.arrow_drop_down), // Set the icon
                  iconSize: 30, // Set the size of the icon
                  elevation: 16,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 30, 142, 24),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  underline: Container(
                    height: 2,
                    color: Colors.grey[300],
                  ),
                  dropdownColor: Colors.white,
                  isExpanded: true, // Set isExpanded to true
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(right: 185),
                child: const Text(
                  'Expected Budget:',
                  style: TextStyle(
                    color: Color.fromARGB(255, 99, 101, 98),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                //to add decoration to the textfield
                margin: const EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    //to add shadow to the textfield
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 7,
                      //to make the shadow bigger
                      blurRadius: 10,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: TextFormField(
                  //to get the text from the textfield
                  controller: budgetController,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    hintText: '  ex: 2500',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 159, 159, 159)),
                    focusedBorder: OutlineInputBorder(
                      //to change the border color when the textfield is focused
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      //to change the border color when the textfield is not focused
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your budget';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Text(
                  'in which space mainly do you want these plants?',
                  style: TextStyle(
                    color: Color.fromARGB(255, 99, 101, 98),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: 300, // Set the width of the dropdown button
                child: DropdownButton<String>(
                  value: dropdownValue2,
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue2 = value!;
                      _dropdownController2.text = value;
                    });
                  },
                  items: <String>[
                    'Coffee',
                    'Home',
                    'Club',
                    'Office',
                    'landscape',
                    'Other'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  icon: const Icon(Icons.arrow_drop_down), // Set the icon
                  iconSize: 30, // Set the size of the icon
                  elevation: 16,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 30, 142, 24),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  underline: Container(
                    height: 2,
                    color: Colors.grey[300],
                  ),
                  dropdownColor: Colors.white,
                  isExpanded: true, // Set isExpanded to true
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        UserAuthController.instance.register(
                            // to register the user
                            emailController.text.trim(),
                            passwordController.text.trim(),
                            firstNameController.text.trim(),
                            lastNameController.text.trim(),
                            phoneController.text.trim(),
                            _dropdownController.text.trim(),
                            int.parse(budgetController.text.trim()),
                            _dropdownController2.text.trim(),
                            _dropdownController3.text.trim(),
                            false,
                            selectedImage);
                      }
                    },
                    child: Container(
                      //to add decoration to the button
                      width: w * 0.5,
                      height: h * 0.08,
                      margin: const EdgeInsets.only(top: 40),
                      //or use the sizedbox widget for space as we used above
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: const DecorationImage(
                          image: AssetImage('img/green-rectangle.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: const Center(
                        //the child is the text that we want to add on top of the image
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.back();
                        Get.back(); //to go back to the previous page
                      },
                    text: 'Already have an account?',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[500],
                    )),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Sign up with one of the following options',
                style: TextStyle(color: Colors.grey[500]),
              ),
              Wrap(
                //we used wrap because we want to add the images in a row
                //instead of using a row widget
                children: List<Widget>.generate(3, (index) {
                  //we used list.generate because we want to add the images in a loop
                  return Padding(
                    //to add padding to the images to make them look better
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      //to add the circle around the image as a border
                      radius: 30,
                      backgroundColor: Colors.grey[500],
                      child: CircleAvatar(
                        //to add the image inside the circle
                        radius: 25,
                        backgroundImage: AssetImage(images[index]),
                      ),
                    ),
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  //void setState(Null Function() param0) {}
}
