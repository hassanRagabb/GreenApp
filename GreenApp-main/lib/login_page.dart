// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:Green/auth/user_auth_controller.dart';
// import 'package:Green/auth/seller_auth_controller.dart';
// import 'package:Green/auth/gardner_auth_controller.dart';
// import 'package:Green/welcome_page.dart';
// import 'Gardner/GardnerHomePage.dart';
// import 'Seller/SellerHomePage.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   var emailController = TextEditingController();
//   var passwordController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   String selectedOption = 'User';
//   List<String> options = [
//     'User',
//     'Seller',
//     'Gardner',
//   ];
//   Future<void> loginSeller(String email, String password) async {
//     // Authenticate expert login
//     SellerAuthController sellerAuthController = SellerAuthController();
//     bool isLoggedIn = await sellerAuthController.loginSeller(
//       context, // Pass context here
//       email,
//       password,
//     );

//     // Navigate to home page only if authentication was successful
//     if (isLoggedIn) {
//       // ignore: use_build_context_synchronously
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const SellerHomePage()),
//       );
//     } else {
//       // Show login error
//     }
//   }

//   Future<void> loginGardner(String email, String password) async {
//     // Authenticate expert login
//     GardnerAuthController gardnerAuthController = GardnerAuthController();
//     bool isLoggedIn = await gardnerAuthController.loginGardner(
//       context, // Pass context here
//       email,
//       password,
//     );

//     // Navigate to home page only if authentication was successful
//     if (isLoggedIn) {
//       // ignore: use_build_context_synchronously
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const GardenerHomePage()),
//       );
//     } else {
//       // Show login error
//     }
//   }

//   void performLogin() async {
//     String email = emailController.text.trim();
//     String password = passwordController.text.trim();

//     if (selectedOption == 'User') {
//       UserAuthController userAuthController = UserAuthController();
//       await userAuthController.loginUser(
//         context, // Pass context here
//         email,
//         password,
//       );
//     } else if (selectedOption == 'Seller') {
//       print("Seller login from main");
//     } else if (selectedOption == 'Gardner') {
//       loginGardner(email, password);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;
//     double h = MediaQuery.of(context).size.height;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(left: 20, right: 20),
//                 width: w,
//                 child: Center(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 60, top: 125),
//                         child: Row(
//                           children: [
//                             const Text(
//                               'Green',
//                               style: TextStyle(
//                                 fontFamily: 'Times New Roman',
//                                 fontSize: 70,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xff296e48),
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 2,
//                             ),
//                             Image.asset(
//                               'img/green-icon2.png',
//                               width: 50,
//                               height: 50,
//                             ),
//                           ],
//                         ),
//                       ),
//                       Text(
//                         'Think Clean, Think Green',
//                         style: TextStyle(
//                           fontFamily: "times new roman",
//                           fontSize: 15,
//                           color: Colors.grey.shade700,
//                         ),
//                       ),
//                       const SizedBox(height: 100),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(30),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.2),
//                               spreadRadius: 5,
//                               blurRadius: 10,
//                               offset: const Offset(1, 4),
//                             ),
//                           ],
//                         ),
//                         child: TextFormField(
//                           controller: emailController,
//                           decoration: InputDecoration(
//                             hintText: 'Email',
//                             prefixIcon: const Icon(
//                               Icons.email,
//                               color: Color(0xff296e48),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: const BorderSide(
//                                 color: Colors.white,
//                                 width: 1.0,
//                               ),
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: const BorderSide(
//                                 color: Colors.white,
//                                 width: 1.0,
//                               ),
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Please enter your email';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(30),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.2),
//                               spreadRadius: 5,
//                               blurRadius: 10,
//                               offset: const Offset(1, 4),
//                             ),
//                           ],
//                         ),
//                         child: TextFormField(
//                           controller: passwordController,
//                           obscureText: true,
//                           decoration: InputDecoration(
//                             hintText: 'Password',
//                             prefixIcon: const Icon(
//                               Icons.lock,
//                               color: Color(0xff296e48),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: const BorderSide(
//                                 color: Colors.white,
//                                 width: 1.0,
//                               ),
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: const BorderSide(
//                                 color: Colors.white,
//                                 width: 1.0,
//                               ),
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Please enter your password';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Login as:',
//                             style: TextStyle(
//                               color: Colors.grey,
//                               fontSize: 15,
//                             ),
//                           ),
//                           const SizedBox(width: 20),
//                           DropdownButton<String>(
//                             value: selectedOption,
//                             icon: const Icon(Icons.arrow_drop_down),
//                             iconSize: 40,
//                             elevation: 16,
//                             borderRadius: BorderRadius.circular(10),
//                             style: const TextStyle(
//                               color: Colors.black,
//                               fontSize: 15,
//                             ),
//                             underline: Container(
//                               height: 2,
//                               color: Colors.transparent,
//                             ),
//                             onChanged: (String? newValue) {
//                               setState(() {
//                                 selectedOption = newValue!;
//                               });
//                             },
//                             items: options.map<DropdownMenuItem<String>>(
//                               (String value) {
//                                 return DropdownMenuItem<String>(
//                                   value: value,
//                                   child: Text(value),
//                                 );
//                               },
//                             ).toList(),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         //we created a row to put the forgot password text to the right
//                         //by putting an empty container in the left
//                         children: [
//                           Expanded(child: Container()),
//                           const Padding(
//                             padding: EdgeInsets.only(right: 230),
//                             child: Text(
//                               'Forgot Password?',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 15,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       Column(
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               if (_formKey.currentState!.validate()) {
//                                 performLogin();
//                               }
//                             },
//                             child: Container(
//                               width: w * 0.5,
//                               height: h * 0.08,
//                               margin: const EdgeInsets.only(top: 43),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(30),
//                                 image: const DecorationImage(
//                                   image: AssetImage('img/green-rectangle.png'),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               child: const Center(
//                                 child: Text(
//                                   'Sign In',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 30,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 27),
//                       RichText(
//                         text: TextSpan(
//                           text: 'Don\'t have an account?',
//                           style:
//                               TextStyle(color: Colors.grey[500], fontSize: 16),
//                           children: [
//                             TextSpan(
//                               text: ' Create Account',
//                               style: const TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               recognizer: TapGestureRecognizer()
//                                 ..onTap = () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => const WelcomePage(),
//                                     ),
//                                   );
//                                 },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:Green/auth/user_auth_controller.dart';
import 'package:Green/auth/seller_auth_controller.dart';
import 'package:Green/auth/gardner_auth_controller.dart';
import 'package:Green/welcome_page.dart';
import 'Gardner/GardnerHomePage.dart';
import 'Seller/SellerHomePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String selectedOption = 'User';
  List<String> options = [
    'User',
    'Seller',
    'Gardner',
  ];
  Future<void> loginSeller(String email, String password) async {
    // Authenticate expert login
    SellerAuthController sellerAuthController = SellerAuthController();
    bool isLoggedIn = await sellerAuthController.loginSeller(
      context, // Pass context here
      email,
      password,
    );

    // Navigate to home page only if authentication was successful
    if (isLoggedIn) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SellerHomePage()),
      );
    } else {
      // Show login error
    }
  }

  Future<void> loginGardner(String email, String password) async {
    // Authenticate expert login
    GardnerAuthController gardnerAuthController = GardnerAuthController();
    bool isLoggedIn = await gardnerAuthController.loginGardner(
      context, // Pass context here
      email,
      password,
    );

    // Navigate to home page only if authentication was successful
    if (isLoggedIn) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GardenerHomePage()),
      );
    } else {
      // Show login error
    }
  }

  void performLogin() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (selectedOption == 'User') {
      UserAuthController userAuthController = UserAuthController();
      await userAuthController.loginUser(
        context, // Pass context here
        email,
        password,
      );
    } else if (selectedOption == 'Seller') {
      print("Seller login from main");
    } else if (selectedOption == 'Gardner') {
      loginGardner(email, password);
    }
  }

  void resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Password reset email sent successfully
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Password Reset Email Sent'),
            content: const Text(
                'Please check your email for password reset instructions.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Error occurred while sending password reset email
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Password Reset Failed'),
            content: const Text('Failed to send password reset email.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                width: w,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 60, top: 125),
                        child: Row(
                          children: [
                            const Text(
                              'Green',
                              style: TextStyle(
                                fontFamily: 'Times New Roman',
                                fontSize: 70,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff296e48),
                              ),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Image.asset(
                              'img/green-icon2.png',
                              width: 50,
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Think Clean, Think Green',
                        style: TextStyle(
                          fontFamily: "times new roman",
                          fontSize: 15,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 100),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: const Offset(1, 4),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.green[700],
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: const Offset(1, 4),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.green[700],
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Login as:',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 20),
                          DropdownButton<String>(
                            value: selectedOption,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 40,
                            elevation: 16,
                            borderRadius: BorderRadius.circular(10),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                            underline: Container(
                              height: 2,
                              color: Colors.transparent,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedOption = newValue!;
                              });
                            },
                            items: options.map<DropdownMenuItem<String>>(
                              (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                          ),
                        ],
                      ),
                      Row(
                        //we created a row to put the forgot password text to the right
                        //by putting an empty container in the left
                        children: [
                          Expanded(child: Container()),
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Forgot Password'),
                                      content: TextFormField(
                                        controller: TextEditingController(),
                                        decoration: const InputDecoration(
                                          labelText:
                                              'Enter your email to reset password',
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Reset Password'),
                                          onPressed: () {
                                            String email =
                                                emailController.text.trim();
                                            resetPassword(email);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                performLogin();
                              }
                            },
                            child: Container(
                              width: w * 0.5,
                              height: h * 0.08,
                              margin: const EdgeInsets.only(top: 43),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                image: const DecorationImage(
                                  image: AssetImage('img/green-rectangle.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Sign In',
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
                      const SizedBox(height: 27),
                      RichText(
                        text: TextSpan(
                          text: 'Don\'t have an account?',
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 16),
                          children: [
                            TextSpan(
                              text: ' Create Account',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const WelcomePage(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
