import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    // Android
    return const FirebaseOptions(
      appId: '1:571334026473:android:0e2fc6dd06205c4990fc78',
      apiKey: 'AIzaSyAzrPSwdhmPuRtxm7_lBOdcamLWvY7npa0',
      projectId: 'greenapp-8ee51',
      messagingSenderId: '571334026473',
    );
  }
}
