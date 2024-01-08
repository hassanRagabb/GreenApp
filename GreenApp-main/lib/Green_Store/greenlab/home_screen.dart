// import 'package:Green/Green_Store/screens/bottom_bar/bottom_bar.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:lottie/lottie.dart';
// import 'package:Green/Green_Store/greenlab/leaf_scan.dart';
// import 'package:Green/Green_Store/constants/constants.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   Color backgroundColor = const Color(0xffe9edf1);
//   Color secondaryColor = const Color(0xffe1e6ec);
//   Color accentColor = const Color(0xff2d5765);

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//       // statusBarColor: backgroundColor,
//       systemNavigationBarColor: backgroundColor,
//     ));

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const BottomBar()),
//                       );
//                     },
//                     child: Container(
//                       height: 40,
//                       width: 40,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(25),
//                         color: Constants.primaryColor.withOpacity(.15),
//                       ),
//                       child: Icon(
//                         Icons.close,
//                         color: Constants.primaryColor,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       SvgPicture.asset(
//                         'lib/Green_Store/greenlab/assets/app_icon.svg',
//                         width: 30,
//                         height: 30,
//                       ),
//                       Text(
//                         "GreenLab",
//                         style: TextStyle(
//                           fontSize: 23,
//                           fontWeight: FontWeight.w500,
//                           color: Constants.primaryColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   child: SvgPicture.asset(
//                     'lib/Green_Store/greenlab/assets/tensorflow-icontext.svg',
//                     width: 50,
//                     height: 50,
//                   ),
//                 )
//               ],
//             ),
//             LottieBuilder.asset(
//               'lib/Green_Store/greenlab/assets/45869-farmers.json',
//               width: 200,
//               height: 200,
//             ),
//             GridView.count(
//               padding: const EdgeInsets.all(20),
//               shrinkWrap: true,
//               crossAxisCount: 3,
//               crossAxisSpacing: 20,
//               mainAxisSpacing: 10,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             const LeafScan(modelName: 'Apple'),
//                       ),
//                     );
//                   },
//                   child: Neumorphic(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SvgPicture.asset(
//                           'lib/Green_Store/greenlab/assets/apple-svgrepo-com.svg',
//                           width: 50,
//                           height: 50,
//                         ),
//                         Container(
//                           margin: const EdgeInsets.only(top: 10),
//                           child: const Text(
//                             'Apple',
//                             style: TextStyle(
//                               fontSize: 10,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             const LeafScan(modelName: 'BellPepper'),
//                       ),
//                     );
//                   },
//                   child: Neumorphic(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SvgPicture.asset(
//                           'lib/Green_Store/greenlab/assets/bell-pepper-svgrepo-com.svg',
//                           width: 50,
//                           height: 50,
//                         ),
//                         Container(
//                           margin: const EdgeInsets.only(top: 10),
//                           child: const Text(
//                             'Bell Pepper',
//                             style: TextStyle(
//                               fontSize: 10,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             const LeafScan(modelName: 'Cherry'),
//                       ),
//                     );
//                   },
//                   child: Neumorphic(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SvgPicture.asset(
//                           'lib/Green_Store/greenlab/assets/cherry-svgrepo-com(1).svg',
//                           width: 50,
//                           height: 50,
//                         ),
//                         Container(
//                           margin: const EdgeInsets.only(top: 10),
//                           child: const Text(
//                             'Cherry',
//                             style: TextStyle(
//                               fontSize: 10,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const LeafScan(modelName: 'Corn'),
//                       ),
//                     );
//                   },
//                   child: Neumorphic(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SvgPicture.asset(
//                           'lib/Green_Store/greenlab/assets/corn-svgrepo-com.svg',
//                           width: 50,
//                           height: 50,
//                         ),
//                         Container(
//                           margin: const EdgeInsets.only(top: 10),
//                           child: const Text(
//                             'Corn',
//                             style: TextStyle(
//                               fontSize: 10,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             const LeafScan(modelName: 'Grape'),
//                       ),
//                     );
//                   },
//                   child: Neumorphic(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SvgPicture.asset(
//                           'lib/Green_Store/greenlab/assets/grapes-grape-svgrepo-com.svg',
//                           width: 50,
//                           height: 50,
//                         ),
//                         Container(
//                           margin: const EdgeInsets.only(top: 10),
//                           child: const Text(
//                             'Grape',
//                             style: TextStyle(
//                               fontSize: 10,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             const LeafScan(modelName: 'Peach'),
//                       ),
//                     );
//                   },
//                   child: Neumorphic(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SvgPicture.asset(
//                           'lib/Green_Store/greenlab/assets/peach-svgrepo-com.svg',
//                           width: 50,
//                           height: 50,
//                         ),
//                         Container(
//                           margin: const EdgeInsets.only(top: 10),
//                           child: const Text(
//                             'Peach',
//                             style: TextStyle(
//                               fontSize: 10,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             const LeafScan(modelName: 'Potato'),
//                       ),
//                     );
//                   },
//                   child: Neumorphic(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SvgPicture.asset(
//                           'lib/Green_Store/greenlab/assets/potato-svgrepo-com.svg',
//                           width: 50,
//                           height: 50,
//                         ),
//                         Container(
//                           margin: const EdgeInsets.only(top: 10),
//                           child: const Text(
//                             'Potato',
//                             style: TextStyle(
//                               fontSize: 10,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const LeafScan(modelName: 'Rice'),
//                       ),
//                     );
//                   },
//                   child: Neumorphic(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SvgPicture.asset(
//                           'lib/Green_Store/greenlab/assets/sheaf-of-rice-svgrepo-com(1).svg',
//                           width: 50,
//                           height: 50,
//                         ),
//                         Container(
//                           margin: const EdgeInsets.only(top: 10),
//                           child: const Text(
//                             'Rice',
//                             style: TextStyle(
//                               fontSize: 10,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             const LeafScan(modelName: 'Tomato'),
//                       ),
//                     );
//                   },
//                   child: Neumorphic(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SvgPicture.asset(
//                           'lib/Green_Store/greenlab/assets/tomato-svgrepo-com.svg',
//                           width: 50,
//                           height: 50,
//                         ),
//                         Container(
//                           margin: const EdgeInsets.only(top: 10),
//                           child: const Text(
//                             'Tomato',
//                             style: TextStyle(
//                               fontSize: 10,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             const LeafScan(modelName: 'Flowers'),
//                       ),
//                     );
//                   },
//                   child: Neumorphic(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SvgPicture.asset(
//                           'lib/Green_Store/greenlab/assets/flowers-svgrepo-com (2).svg',
//                           width: 50,
//                           height: 50,
//                         ),
//                         Container(
//                           margin: const EdgeInsets.only(top: 10),
//                           child: const Text(
//                             'Flowers',
//                             style: TextStyle(
//                               fontSize: 10,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
