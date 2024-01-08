import 'package:flutter/material.dart';
import 'Customer/Customer_signup.dart';

import 'Gardner/gardner_signup.dart';
import 'Seller/seller_signup.dart';
import 'login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.arrow_back,
                  size: 35,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Image(
              image: AssetImage('img/back4.png'),
              height: 250,
              width: 400,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.center, // Aligns the text to the end
              child: const Text(
                'Choose Account type',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff296e48),
                ),
              ),
            ),
            const SizedBox(
              height: 140,
            ),
            Container(
              margin: const EdgeInsets.only(left: 30, right: 30),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xff296e48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(400, 50),
                ),
                child: const Text('Customer', style: TextStyle(fontSize: 19)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.only(left: 30, right: 30),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GardnerSignUpPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xff296e48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(400, 50),
                ),
                child: const Text('Gardener', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // Container(
            //   margin: const EdgeInsets.only(left: 30, right: 30),
            //   child: ElevatedButton(
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const SellerSignUpPage()),
            //       );
            //     },
            //     style: ElevatedButton.styleFrom(
            //       foregroundColor: Colors.white,
            //       backgroundColor: const Color(0xff296e48),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(30),
            //       ),
            //       minimumSize: const Size(400, 50),
            //     ),
            //     child: const Text('Seller', style: TextStyle(fontSize: 20)),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
