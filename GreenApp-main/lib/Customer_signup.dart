import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'auth/auth_controller.dart';

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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    _dropdownController.dispose();
    _dropdownController2.dispose();
    budgetController.dispose();
    super.dispose();
  }

  String dropdownValue = 'Small     < 30 m2';
  String dropdownValue2 = 'Coffee';

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

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            /*Container(
              /*width: w,
              height: h * 0.4,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('img/signup.png'),
                  fit: BoxFit.cover,
                ),
              ),*/
              child: Column(
                children: [
                  SizedBox(
                    height: h * 0.18,
                  ),
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('img/profile.png'),
                    backgroundColor: Colors.white70,
                  )
                ],
              ),
            ),*/
            const Padding(
              padding: EdgeInsets.only(top: 80, right: 100),
              child: Text(
                'Customer Sign Up',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: 300,
              child: Divider(
                color: Colors.grey[300],
                thickness: 4,
              ),
            ),
            const SizedBox(
              height: 30,
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
              child: TextField(
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
              child: TextField(
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
              child: TextField(
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
              child: TextField(
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
              child: TextField(
                controller:
                    phoneController, //to get the text from the textfield
                obscureText: true, //to hide the password
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
              child: TextField(
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
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: const Text(
                'What category does your garden belong to?',
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
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                AuthController.instance.register(
                  // to register the user
                  emailController.text.trim(),
                  passwordController.text.trim(),
                  firstNameController.text.trim(),
                  lastNameController.text.trim(),
                  phoneController.text.trim(),
                  _dropdownController.text.trim(),
                  budgetController.text.trim(),
                  _dropdownController2.text.trim(),
                );
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
            const SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
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
    );
  }

  //void setState(Null Function() param0) {}
}
