import 'package:flutter/material.dart';

class SignUp2 extends StatefulWidget {
  const SignUp2({super.key});

  @override
  State<SignUp2> createState() => _SignUp2State();
}

class _SignUp2State extends State<SignUp2> {
  String dropdownValue = 'Small';

  final sizeController = TextEditingController();

  @override
  void dispose() {
    sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 60, right: 110),
              child: Text(
                'Customer Sign Up',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Container(
            //   width: 300,
            //   margin: const EdgeInsets.only(right: 34),
            //   child: Divider(
            //     color: Colors.grey[300],
            //     thickness: 4,
            //   ),
            // ),
            const SizedBox(
              height: 40,
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: const Text(
                'Lets recommend you items you may like',
                style: TextStyle(
                  color: Color.fromARGB(255, 116, 107, 107),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.only(right: 150),
              child: const Text(
                'Size of your garden:',
                style: TextStyle(
                  color: Color.fromARGB(255, 54, 77, 43),
                  fontSize: 25,
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
                  });
                },
                items: <String>['Small', 'Medium', 'Large']
                    .map<DropdownMenuItem<String>>((String value) {
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
              height: 700,
            ),
            Container(
              margin: const EdgeInsets.only(right: 160),
              child: const Text(
                'Size in meter square(optional)',
                style: TextStyle(
                  color: Color.fromARGB(255, 246, 97, 97),
                  fontSize: 15,
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
                controller: sizeController, //to get the text from the textfield

                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                  hintText: '  ex: 100 meter square',
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
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
