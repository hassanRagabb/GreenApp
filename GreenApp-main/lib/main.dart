import 'package:Green/Green_Store/provider/app_provider.dart';
//import 'package:Green/auth/user_auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:Green/login_page.dart';
import 'package:provider/provider.dart';

import 'auth/user_auth_controller.dart';
//import 'auth/user_auth_controller.dart';
//import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(  options: FirebaseOptions(
        apiKey: "AIzaSyAzrPSwdhmPuRtxm7_lBOdcamLWvY7npa0",
        appId: "com.example.green",
        messagingSenderId: "571334026473",
        projectId: "greenapp-8ee51",
      //ClientId "270047746471-el3p28r8dtqqfk2icti552oci7hp3g41.apps.googleusercontent.com",  android:resource="@style/NormalTheme"<meta-data
              // android:name="io.flutter.embedding.android.NormalTheme"
              // android:value="270047746471-el3p28r8dtqqfk2icti552oci7hp3g41.apps.googleusercontent.com"
              // />
    ),).then((value) => Get.put(()=>UserAuthController()));
  // Stripe.publishableKey =
  //     "pk_test_51MWx8OAVMyklfe3CsjEzA1CiiY0XBTlHYbZ8jQlGtVFIwQi4aNeGv8J1HUw4rgSavMTLzTwgn0XRlwoTVRFXyu2h00mRUeWmAf";

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Green',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: Colors.green,
        ),
        home: const LoginPage(),
      ),
    );
  }
}
