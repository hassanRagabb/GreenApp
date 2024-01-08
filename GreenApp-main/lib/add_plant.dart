// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class AddPlantPage extends StatefulWidget {
//   const AddPlantPage({super.key});

//   @override
//   _AddPlantPageState createState() => _AddPlantPageState();
// }

// class _AddPlantPageState extends State<AddPlantPage> {
//   String? name;
//   String? color;
//   String? size;
//   String? humidity;
//   String? temperature;
//   String? fragrance;
//   String? location;
//   String? season;
//   String? waterNeeds;
//   String? description;
//   String? tip;
//   int? wateringFrequency;
//   bool? verified;
//   File? image;
//   int maxLength = 999;
//   final List<String> locations = ['Indoor', 'Outdoor', 'Garden'];
//   final List<String> colors = [
//     'Aqua',
//     'Black',
//     'Blue',
//     'Fuchsia',
//     'Gray',
//     'Green',
//     'Lime',
//     'Maroon',
//     'Navy',
//     'Olive',
//     'Purple',
//     'Red',
//     'Silver',
//     'Teal',
//     'White',
//     'Yellow'
//   ];
//   final List<String> sizes = ['Small', 'Medium', 'Large'];
//   final List<String> humidities = ['Low', 'Medium', 'High'];
//   final List<String> temperatures = ['Low', 'Medium', 'High'];
//   final List<String> fragrances = ['Yes', 'No'];
//   final List<String> seasons = [
//     'Summer',
//     'Winter',
//     'Spring',
//     'Fall',
//     'All Year'
//   ];
//   final List<String> waterNeedsOptions = ['Low', 'Medium', 'High'];

//   final ImagePicker _imagePicker = ImagePicker();

//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _tipController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Add Plant',
//           style: TextStyle(color: Colors.green, fontSize: 25),
//         ),
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(color: Colors.green),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               if (image != null)
//                 SizedBox(
//                   height: 200,
//                   width: double.infinity,
//                   child: Image.file(image!, fit: BoxFit.cover),
//                 ),
//               ElevatedButton.icon(
//                 onPressed: _selectImage,
//                 icon: const Icon(Icons.image),
//                 label: const Text('Select Image'),
//                 style: ButtonStyle(
//                   backgroundColor:
//                       MaterialStateProperty.all<Color>(Colors.green),
//                 ),
//               ),
//               const SizedBox(height: 10.0),
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: 'Name',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.green,
//                     ),
//                   ),
//                 ),
//                 onChanged: (value) {
//                   setState(() {
//                     name = value;
//                   });
//                 },
//               ),
//               const SizedBox(height: 10.0),
//               DropdownButtonFormField<String>(
//                 value: color,
//                 items: colors.map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     color = value;
//                   });
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Color',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.green,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10.0),
//               DropdownButtonFormField<String>(
//                 value: size,
//                 items: sizes.map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     size = value;
//                   });
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Size',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.green,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10.0),
//               DropdownButtonFormField<String>(
//                 value: humidity,
//                 items: humidities.map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     humidity = value;
//                   });
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Humidity',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.green,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10.0),
//               DropdownButtonFormField<String>(
//                 value: temperature,
//                 items: temperatures.map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     temperature = value;
//                   });
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Temperature',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.green,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10.0),
//               DropdownButtonFormField<String>(
//                 value: fragrance,
//                 items: fragrances.map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     fragrance = value;
//                   });
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Fragrance',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.green,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10.0),
//               DropdownButtonFormField<String>(
//                 value: location,
//                 items: locations.map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     location = value;
//                   });
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Location',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.green,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10.0),
//               DropdownButtonFormField<String>(
//                 value: season,
//                 items: seasons.map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     season = value;
//                   });
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Season',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.green,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10.0),
//               DropdownButtonFormField<String>(
//                 value: waterNeeds,
//                 items: waterNeedsOptions.map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     waterNeeds = value;
//                     if (value == 'Low') {
//                       wateringFrequency = 14;
//                     } else if (value == 'Medium') {
//                       wateringFrequency = 7;
//                     } else if (value == 'High') {
//                       wateringFrequency = 3;
//                     }
//                   });
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Water Needs',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.green,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10.0),
//               if (waterNeeds ==
//                   null) // Display the "Watering frequency" field only if "Water needs" is selected
//                 const SizedBox(height: 10.0),
//               TextFormField(
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   labelText: 'Watering Frequency',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.green,
//                     ),
//                   ),
//                 ),
//                 onChanged: (value) {
//                   setState(() {
//                     wateringFrequency = int.tryParse(value);
//                   });
//                 },
//               ),
//               const SizedBox(
//                   height:
//                       10.0), // Maximum character limit for the TextFormField
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: InputDecoration(
//                   counterText:
//                       '${_descriptionController.text.length} / $maxLength',
//                   labelText: 'Description',
//                   border: const OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                   ),
//                   focusedBorder: const OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.green,
//                     ),
//                   ),
//                 ),
//                 maxLength: maxLength,
//                 maxLines: 6, // Set maxLines to 6 times the original size3
//                 onChanged: (value) {
//                   setState(() {
//                     description = value;
//                   });
//                 },
//               ),
//               const SizedBox(height: 10.0),
//               TextFormField(
//                 controller: _tipController,
//                 decoration: const InputDecoration(
//                   labelText: 'Tip about the Plant',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.green,
//                     ),
//                   ),
//                 ),
//                 maxLines: 4, // Set maxLines to 6 times the original size
//                 onChanged: (value) {
//                   setState(() {
//                     tip = value;
//                   });
//                 },
//               ),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _submitForm,
//                   style: ButtonStyle(
//                     backgroundColor:
//                         MaterialStateProperty.all<Color>(Colors.green),
//                   ),
//                   child: const Text('Save'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _selectImage() async {
//     final pickedImage =
//         await _imagePicker.getImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       setState(() {
//         image = File(pickedImage.path);
//       });
//     }
//   }

//   Future<void> _submitForm() async {
//     if (name == null || name!.isEmpty) {
//       _showErrorDialog('Please enter a name');
//       return;
//     }
//     if (image == null) {
//       _showErrorDialog('Please select an image');
//       return;
//     }

//     if (color == null) {
//       _showErrorDialog('Please select a color');
//       return;
//     }

//     if (size == null) {
//       _showErrorDialog('Please select a size');
//       return;
//     }

//     if (humidity == null) {
//       _showErrorDialog('Please select a humidity level');
//       return;
//     }

//     if (temperature == null) {
//       _showErrorDialog('Please select a temperature');
//       return;
//     }

//     if (fragrance == null) {
//       _showErrorDialog('Please select a fragrance');
//       return;
//     }

//     if (location == null) {
//       _showErrorDialog('Please select a location');
//       return;
//     }

//     if (season == null) {
//       _showErrorDialog('Please select a season');
//       return;
//     }

//     if (waterNeeds == null) {
//       _showErrorDialog('Please select water needs');
//       return;
//     }

//     if (description == null) {
//       _showErrorDialog('Please enter a description');
//       return;
//     }

//     if ((description?.length ?? 0) < 150) {
//       _showErrorDialog('Description should be at least 150 characters');
//       return;
//     }

//     if (wateringFrequency == null && waterNeeds != null) {
//       // Deduct the watering frequency based on the water needs field
//       if (waterNeeds == 'Low') {
//         wateringFrequency = 14;
//       } else if (waterNeeds == 'Medium') {
//         wateringFrequency = 7;
//       } else if (waterNeeds == 'High') {
//         wateringFrequency = 3;
//       }
//     }

//     // Check if a plant with the same name already exists
//     final plantsSnapshot = await FirebaseFirestore.instance
//         .collection('plants')
//         .where('name', isEqualTo: name)
//         .get();

//     if (plantsSnapshot.docs.isNotEmpty) {
//       _showErrorDialog('A plant with the same name already exists');
//       return;
//     }

//     final plantName =
//         name?.toLowerCase(); // Add a null check using the null-aware operator

//     if (plantName != null) {
//       final imageName = '${DateTime.now()}.png';
//       final imageRef =
//           FirebaseStorage.instance.ref().child('images/$imageName');
//       final uploadTask = imageRef.putFile(image!);
//       final imageUrl = await (await uploadTask).ref.getDownloadURL();

//       final plantId = FirebaseFirestore.instance.collection('plants').doc().id;

//       final plantData = {
//         'id': plantId,
//         'name': name,
//         'color': color,
//         'size': size,
//         'humidity': humidity,
//         'temperature': temperature,
//         'fragrance': fragrance,
//         'location': location,
//         'season': season,
//         'waterNeeds': waterNeeds,
//         'wateringFrequency': wateringFrequency,
//         'description': description,
//         'tip': tip,
//         'imageUrl': imageUrl,
//         'Verified': false,
//       };

//       await FirebaseFirestore.instance
//           .collection('plants')
//           .doc(plantId) // Use plantId as the document ID
//           .set(plantData);
//     }

//     // Reset the form
//     setState(() {
//       name = null;
//       color = null;
//       size = null;
//       humidity = null;
//       temperature = null;
//       fragrance = null;
//       location = null;
//       season = null;
//       waterNeeds = null;
//       wateringFrequency = null;
//       description = null;
//       tip = null;
//       image = null;
//       _descriptionController.clear();
//       _tipController.clear();
//     });

//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         backgroundColor: Colors.white, // Set dialog background color
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.0), // Set dialog border radius
//         ),
//         child: Container(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 'Success 🎉',
//                 style: TextStyle(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10.0),
//               const Text(
//                 'Plant added successfully!',
//                 style: TextStyle(fontSize: 16.0),
//               ),
//               const SizedBox(height: 20.0),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                 ),
//                 child: const Padding(
//                   padding:
//                       EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
//                   child: Text(
//                     'OK',
//                     style: TextStyle(fontSize: 16.0),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         backgroundColor: Colors.white, // Set dialog background color
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.0), // Set dialog border radius
//         ),
//         child: Container(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 'Error',
//                 style: TextStyle(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10.0),
//               Text(
//                 message,
//                 style: const TextStyle(fontSize: 16.0),
//               ),
//               const SizedBox(height: 20.0),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                 ),
//                 child: const Padding(
//                   padding:
//                       EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
//                   child: Text(
//                     'OK',
//                     style: TextStyle(fontSize: 16.0),
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
