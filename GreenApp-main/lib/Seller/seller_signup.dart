import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth/Seller_auth_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SellerSignUpPage extends StatefulWidget {
  const SellerSignUpPage({super.key});

  @override
  State<SellerSignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SellerSignUpPage> {
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

  final ImagePicker _imagePicker = ImagePicker();
  File? selectedIDImage;
  File? selectedImage;
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

    Get.lazyPut(() => SellerAuthController());
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 80, right: 150),
              child: Text(
                'Seller Sign Up',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text(
                  '       ID Image:',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 120, // Specify the desired width
                  height: 40, // Specify the desired height
                  child: ElevatedButton.icon(
                    onPressed: _selectImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Select Image'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                    ),
                  ),
                ),
                if (selectedIDImage != null)
                  SizedBox(
                    width: 80, // Specify the desired width
                    height: 40,
                    child: Image.file(selectedIDImage!, fit: BoxFit.cover),
                  ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                final SellerAuthController sellerAuthController =
                    Get.put(SellerAuthController());
                sellerAuthController.register(
                  // to register the user
                  emailController.text.trim(),
                  passwordController.text.trim(),
                  firstNameController.text.trim(),
                  lastNameController.text.trim(),
                  phoneController.text.trim(),
                  selectedImage,
                  selectedIDImage,
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
    );
  }

  Future<void> _selectImage() async {
    final pickedImage =
        await _imagePicker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        selectedIDImage = File(pickedImage.path);
      });
    }
  }
  //void setState(Null Function() param0) {}
}
