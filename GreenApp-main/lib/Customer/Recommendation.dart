import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecommendationPage extends StatelessWidget {
  final String userId;

  RecommendationPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommended Plants'),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
        future:
            FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder: (context, userSnapshot) {
          if (userSnapshot.hasError) {
            return Text('Error loading user data');
          }

          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final userData = userSnapshot.data!.data();

          final int userBudget = userData?['budget'] ?? 0;
          final String userCategory = userData?['category'] ?? '';
          final String userSize = userData?['size'] ?? '';

          return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance.collection('users').get(),
            builder: (context, usersSnapshot) {
              if (usersSnapshot.hasError) {
                return Text('Error loading user data');
              }

              if (usersSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final List<DocumentSnapshot<Map<String, dynamic>>> userDocs =
                  usersSnapshot.data!.docs;
              final List<String> similarUserIds = [];

              // Find similar users based on preferences
              for (final userDoc in userDocs) {
                if (userDoc.id == userId) {
                  continue; // Skip the new user's own data
                }

                final userData = userDoc.data();

                final String category = userData?['category'] ?? '';
                final String size = userData?['size'] ?? '';
                final int budget;
                if (userData != null && userData.containsKey('budget')) {
                  final dynamic budgetValue = userData['budget'];
                  if (budgetValue is int) {
                    budget = budgetValue;
                  } else if (budgetValue is String) {
                    budget = int.tryParse(budgetValue) ?? 0;
                  } else {
                    budget = 0;
                  }
                } else {
                  budget = 0;
                }

                // Compare the preferences of the new user with old users
                final double budgetDifference =
                    (userBudget - budget).abs() / userBudget;

                final String budgetStr = userData?['budget'] ?? '';

                if (budget != 0 &&
                    (budget - userBudget).abs() / userBudget <= 0.2 &&
                    category == userCategory &&
                    size == userSize) {
                  similarUserIds.add(userDoc.id);
                  print('Matched user ID: ${userDoc.id}');
                }
              }

              return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance.collection('plants').get(),
                builder: (context, plantsSnapshot) {
                  if (plantsSnapshot.hasError) {
                    return Text('Error loading plant data');
                  }

                  if (plantsSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final List<DocumentSnapshot<Map<String, dynamic>>> plantDocs =
                      plantsSnapshot.data!.docs;
                  final List<DocumentSnapshot<Map<String, dynamic>>>
                      recommendedPlants = [];

                  // Retrieve plants purchased by similar users
                  for (final userId in similarUserIds) {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .collection('ownedPlants')
                        .get()
                        .then((plantsPurchasedSnapshot) {
                      final List<DocumentSnapshot<Map<String, dynamic>>>
                          plantsPurchasedDocs = plantsPurchasedSnapshot.docs;

                      recommendedPlants.addAll(plantsPurchasedDocs);
                    });
                  }

                  if (recommendedPlants.isEmpty) {
                    return Center(
                      child: Text('No recommended plants found.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: recommendedPlants.length,
                    itemBuilder: (context, index) {
                      final plant = recommendedPlants[index].data();
                      final String plantName = plant?['name'] ?? '';
                      final String plantDescription =
                          plant?['description'] ?? '';
                      final String plantImageUrl = plant?['imageUrl'] ?? '';

                      return ListTile(
                        leading: Image.network(
                          plantImageUrl,
                          width: 50,
                          height: 50,
                        ),
                        title: Text(plantName),
                        subtitle: Text(plantDescription),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
