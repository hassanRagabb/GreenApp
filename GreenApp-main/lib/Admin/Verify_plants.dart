import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminPlantPage extends StatefulWidget {
  const AdminPlantPage({Key? key}) : super(key: key);

  @override
  _PlantPageState createState() => _PlantPageState();
}

class _PlantPageState extends State<AdminPlantPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> plants = [];
  List<Map<String, dynamic>> filteredPlants = [];
  Set<String> ownedPlantIds = {};

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchPlants();
    initializeOwnedPlantIds();
  }

  Future<void> initializeOwnedPlantIds() async {
    final String? userId = await getCurrentUserId();
    if (userId != null) {
      final userPlantsRef =
          _firestore.collection('users').doc(userId).collection('User plants');
      final QuerySnapshot snapshot = await userPlantsRef.get();
      final List<String> ownedIds = snapshot.docs.map((doc) => doc.id).toList();
      setState(() {
        ownedPlantIds = Set.from(ownedIds);
      });
    }
  }

  Future<void> fetchPlants() async {
    try {
      setState(() {
        isLoading = true;
      });

      final QuerySnapshot snapshot = await _firestore
          .collection('plants')
          .where('Verified', isEqualTo: false)
          .get();
      final List<Map<String, dynamic>> fetchedPlants = snapshot.docs.map((doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Include the document ID
        return data;
      }).toList();
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

  void changeVerifiedStatus(String plantId, bool newStatus) async {
    try {
      await _firestore
          .collection('plants')
          .doc(plantId)
          .update({'Verified': newStatus});
      fetchPlants(); // Fetch updated plants after the change
    } catch (e) {
      print('Error changing verified status: $e');
    }
  }

  void deletePlant(String plantId) async {
    try {
      await _firestore.collection('plants').doc(plantId).delete();
      fetchPlants(); // Fetch updated plants after the deletion
    } catch (e) {
      print('Error deleting plant: $e');
    }
  }

  void filterPlants(String query) {
    setState(() {
      filteredPlants = plants.where((plant) {
        final bool isNameMatch =
            plant['name'].toLowerCase().contains(query.toLowerCase());
        final bool isVerified = plant['Verified'] == false;
        return isNameMatch && isVerified;
      }).toList();
    });
  }

  Future<String?> getCurrentUserId() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    }
    return null;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify Plants',
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
                    itemCount: filteredPlants.length,
                    itemBuilder: (context, index) {
                      final plant = filteredPlants[index];
                      final plantId = plant['id'];

                      return Card(
                        child: ListTile(
                          leading: buildPlantImage(plant['imageUrl'] ?? ''),
                          title: Text(plant['name'] ?? ''),
                          subtitle: Text(
                            plant['description']?.substring(0, 171) ?? '',
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.verified),
                                onPressed: () =>
                                    changeVerifiedStatus(plantId, true),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => deletePlant(plantId),
                              ),
                            ],
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
