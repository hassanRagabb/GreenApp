import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlantPage extends StatefulWidget {
  const PlantPage({Key? key}) : super(key: key);

  @override
  _PlantPageState createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String currentUserId;
  late String currentUserEmail;
  List<Map<String, dynamic>>? plants = [];
  List<Map<String, dynamic>>? filteredPlants = [];
  Set<String> ownedPlantIds = {};

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchPlants();
    getCurrentUserEmail();
    fetchOwnedPlantIds();
  }

  void getCurrentUserEmail() {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        currentUserEmail = user.email ?? "";
      });
    }
  }

  Widget buildPlantImage(String imageUrl) {
    return SizedBox(
      width: 100, // Set the desired width for the image
      height: 100, // Set the desired height for the image
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future<void> fetchPlants() async {
    try {
      setState(() {
        isLoading = true;
      });

      final QuerySnapshot snapshot = await _firestore
          .collection('plants')
          .where('Verified', isEqualTo: true)
          .get();
      final List<Map<String, dynamic>> fetchedPlants = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      setState(() {
        plants = fetchedPlants;
        filteredPlants = plants;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching plants: $e');
    }
  }

  Future<void> fetchOwnedPlantIds() async {
    final userRef = _firestore.collection('users').doc(currentUserEmail);

    try {
      final DocumentSnapshot snapshot = await userRef.get();
      final data = snapshot.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('ownedPlants')) {
        setState(() {
          ownedPlantIds = Set.from(data['ownedPlants'] ?? []);
        });
      }
    } catch (e) {
      print('Error fetching ownedPlantIds: $e');
    }
  }

  void filterPlants(String query) {
    setState(() {
      filteredPlants = plants
          ?.where((plant) =>
              plant['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> updateOwnedPlantIds(String plantId, bool isChecked) async {
    setState(() {
      if (isChecked) {
        ownedPlantIds.add(plantId);
      } else {
        ownedPlantIds.remove(plantId);
      }
    });

    final userRef = _firestore.collection('users').doc(currentUserEmail);

    try {
      await userRef.update({'ownedPlants': ownedPlantIds.toList()});
      print('Successfully updated ownedPlants field.');
    } catch (e) {
      print('Error updating ownedPlants field: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Plants',
          style: TextStyle(color: Colors.green, fontSize: 25),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterPlants,
              decoration: InputDecoration(
                fillColor: Colors.green,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                prefixIcon: const Icon(
                  Icons.search, // Set the search icon
                  color: Colors.white, // Set the icon color
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: filteredPlants?.length ?? 0,
                    itemBuilder: (context, index) {
                      final plant = filteredPlants?[index];
                      final plantId = plant?['id'];

                      return Card(
                        child: ListTile(
                          leading: buildPlantImage(plant?['imageUrl'] ?? ''),
                          title: Text(plant?['name'] ?? ''),
                          subtitle: Text(
                            plant?['description']?.substring(0, 171) ?? '',
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => Stack(
                                children: [
                                  // Background overlay
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  // Dialog content
                                  AlertDialog(
                                    backgroundColor: Colors.transparent,
                                    contentPadding: EdgeInsets.zero,
                                    content: Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            plant?['name'] as String,
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 10.0),
                                          Center(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                plant?['imageUrl'] as String,
                                                width: 300.0,
                                                height: 200.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            plant?['description'] as String,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: TextButton.styleFrom(
                                          side: const BorderSide(
                                              color: Colors.green),
                                        ),
                                        child: const Text(
                                          'Close',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                    ],
                                    elevation: 0,
                                  ),
                                ],
                              ),
                            );
                          },
                          trailing: Checkbox(
                            value: ownedPlantIds.contains(plantId),
                            onChanged: (isChecked) {
                              if (isChecked != null) {
                                updateOwnedPlantIds(plantId!, isChecked);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
