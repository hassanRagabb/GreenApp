import 'dart:async';
import 'package:Green/Customer/acceptedGardenerProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'gardenerProfile.dart';
import 'home_page.dart';

class Gardener {
  final String id;
  final String firstName;
  final String lastName;
  double rating;
  final String profilePhotoUrl;
  final String city;
  String? requestId; // New field to store the request ID
  int totalRatings;
  List<Review> reviews;

  Gardener({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.rating,
    required this.profilePhotoUrl,
    required this.city,
    this.requestId,
    required this.totalRatings,
    this.reviews = const [],
  });
}

class Review {
  final String customerId;
  final int rating;
  final String review;

  Review({
    required this.customerId,
    required this.rating,
    required this.review,
  });
}

class CustomerBookingScreen extends StatefulWidget {
  const CustomerBookingScreen({Key? key}) : super(key: key);

  @override
  _CustomerBookingScreenState createState() => _CustomerBookingScreenState();
}

class _CustomerBookingScreenState extends State<CustomerBookingScreen>
    with TickerProviderStateMixin {
  String selectedCity = ' '; // Track the selected city
  List<Gardener> gardeners = []; // List to store the filtered gardeners
  //List<Gardener> pendingGardeners = [];
  List<Gardener> acceptedGardeners = [];
  TextEditingController ratingController = TextEditingController();
  final TextEditingController reviewController = TextEditingController();
  bool isDataLoading = false; // Add a loading state flag
  late TabController _tabController; // Declare the TabController

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 3, vsync: this); // Initialize the TabController
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose the TabController
    super.dispose();
  }
  // @override
  // void dispose() {
  //   //what does dispose do?
  //   ratingController.dispose();
  //   reviewController.dispose();

  //   super.dispose();
  // }

  // Future<void> rateGardener(BuildContext context, Gardener gardener) async {
  //   final User? user = FirebaseAuth.instance.currentUser;
  //   final String customerId =
  //       user?.email ?? ''; // Replace with actual customer ID

  //   // Check if the customer has already given a rating for this gardener
  //   bool hasRated = await checkIfCustomerRated(customerId, gardener.id);

  //   if (hasRated) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('You have already rated this gardener')),
  //     );
  //     return;
  //   }

  //   String? newRating;

  //   await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Rate Gardener'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const Text('Enter your rating:'),
  //             const SizedBox(height: 16),
  //             TextField(
  //               controller: ratingController,
  //               keyboardType: TextInputType.number,
  //               decoration: const InputDecoration(
  //                 hintText: 'Enter a number between 1 and 5',
  //               ),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             child: const Text('Submit'),
  //             onPressed: () {
  //               newRating = ratingController.text;
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );

  //   if (newRating != null) {
  //     int parsedRating = int.tryParse(newRating!) ?? 0;
  //     if (parsedRating >= 1 && parsedRating <= 5) {
  //       double currentRating = gardener.rating;
  //       int totalRatings = gardener.totalRatings;

  //       double newAverageRating =
  //           ((currentRating * totalRatings) + parsedRating) /
  //               (totalRatings + 1);
  //       int newTotalRatings = totalRatings + 1;

  //       // Update the gardener's rating and total ratings in the database
  //       await FirebaseFirestore.instance
  //           .collection('Gardners')
  //           .doc(gardener.id)
  //           .update({
  //         'rating': newAverageRating,
  //         'totalRatings': newTotalRatings,
  //       });

  //       // Store the customer ID in the ratings collection to prevent multiple ratings
  //       await FirebaseFirestore.instance
  //           .collection('Ratings')
  //           .doc(gardener.id)
  //           .collection('Customers')
  //           .doc(customerId)
  //           .set({
  //         'rated': true,
  //       });

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Rating submitted successfully')),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //             content: Text(
  //                 'Invalid rating. Please enter a number between 1 and 5')),
  //       );
  //     }
  //   }
  // }
  Future<void> rateGardener(BuildContext context, Gardener gardener) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String customerId =
        user?.email ?? ''; // Replace with actual customer ID

    // Check if the customer has already given a rating for this gardener
    bool hasRated = await checkIfCustomerRated(customerId, gardener.id);

    if (hasRated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have already rated this gardener')),
      );
      return;
    }

    String? newRating;
    String? newReview;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
              'By giving a rating you help other customers find the best gardener for them',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'times new roman')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Rate the Gardener',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'times new roman',
                    color: Color(0xff296e48)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: ratingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: 'Enter the number of stars (1-5)',
                    hintStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'times new roman',
                    )),
              ),
              const SizedBox(height: 16),
              const Text('Enter your feedback:',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'times new roman',
                      color: Color(0xff296e48))),
              const SizedBox(height: 16),
              TextField(
                controller: reviewController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'give the gardener a review',
                  hintStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'times new roman'),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Submit',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'times new roman',
                      color: Color(0xff296e48))),
              onPressed: () {
                newRating = ratingController.text;
                newReview = reviewController.text;
                if (newRating!.isEmpty || newReview!.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter a rating and review')),
                  );
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );

    if (newRating != null && newReview != null) {
      int parsedRating = int.tryParse(newRating!) ?? 0;
      if (parsedRating >= 1 && parsedRating <= 5) {
        double currentRating = gardener.rating;
        int totalRatings = gardener.totalRatings;

        double newAverageRating =
            ((currentRating * totalRatings) + parsedRating) /
                (totalRatings + 1);
        int newTotalRatings = totalRatings + 1;

        // Update the gardener's rating and total ratings in the database
        await FirebaseFirestore.instance
            .collection('Gardners')
            .doc(gardener.id)
            .update({
          'rating': newAverageRating,
          'totalRatings': newTotalRatings,
          'reviews': FieldValue.arrayUnion([newReview]),
        });

        // Store the customer ID, rating, and review in the ratings collection
        await FirebaseFirestore.instance
            .collection('Ratings')
            .doc(gardener.id)
            .collection('Customers')
            .doc(customerId)
            .set({
          'rated': true,
          'rating': parsedRating,
          'review': newReview,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rating submitted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Invalid rating. Please enter a number between 1 and 5'),
          ),
        );
      }
      // Clear the rate and review fields
      ratingController.clear();
      reviewController.clear();
    }
  }

  Future<bool> checkIfCustomerRated(
      String customerId, String gardenerId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Ratings')
        .doc(gardenerId)
        .collection('Customers')
        .doc(customerId)
        .get();

    return snapshot.exists;
  }

  Future<List<Gardener>> fetchGardeners() async {
    QuerySnapshot snapshot;

    if (selectedCity.isNotEmpty && selectedCity != ' ') {
      snapshot = await FirebaseFirestore.instance
          .collection('Gardners')
          .where('City', isEqualTo: selectedCity) // Filter by selected city
          .get();
    } else {
      snapshot = await FirebaseFirestore.instance.collection('Gardners').get();
    }

    List<Gardener> fetchedGardeners = [];

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      Gardener gardener = Gardener(
        id: doc.id,
        firstName: doc['first_name'],
        lastName: doc['last_name'],
        rating: doc['rating'].toDouble(),
        profilePhotoUrl: doc['profilePhotoURL'],
        city: doc['City'],
        totalRatings: doc['totalRatings'],
      );
      fetchedGardeners.add(gardener);
    }

    return fetchedGardeners;
  }

  Future<List<String>> fetchCities() async {
    return [
      ' ', // Add an empty option as the default value
      'Abu Simbel',
      'Alexandria',
      'Aswan',
      'Asyut',
      'Banha',
      'Beni Suef',
      'Cairo',
      'Damanhur',
      'Damietta',
      'El Mahalla El Kubra',
      'El Mansoura',
      'El Minya',
      'Faiyum',
      'Giza',
      'Ismaïlia',
      'Kafr El Sheikh',
      'New Cairo',
      'Port Said',
      'Qena',
      'Tanta',
      'Zagazig',
    ];
  }

  Future<bool> checkPendingRequest(String gardenerId) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String customerId =
        user?.email ?? ''; // Replace with actual customer ID

    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('BookingRequests')
        .where('customerId', isEqualTo: customerId)
        .where('gardenerId', isEqualTo: gardenerId)
        .where('status', isEqualTo: 'pending')
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Future<bool> checkAcceptedRequest(String gardenerId) async {
    // Query the BookingRequests collection to check if any request for the given gardener has been accepted
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('BookingRequests')
        .where('gardenerId', isEqualTo: gardenerId)
        .where('status', isEqualTo: 'accepted')
        .limit(1) // Limit the query to only one result
        .get();

    return snapshot.size >
        0; // Return true if at least one accepted request is found
  }

  //this make the gardener doesn't recieve more than one request from the same customer
  //and the gardener if accepted a request he can't accept another one
  // Future<void> sendBookingRequest(
  //     BuildContext context, String gardenerId) async {
  //   final User? user = FirebaseAuth.instance.currentUser;
  //   final String customerId =
  //       user?.email ?? ''; // Replace with actual customer ID

  //   bool isPending = await checkPendingRequest(gardenerId);

  //   if (isPending) {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: const Text('Request Already Sent'),
  //           content:
  //               const Text('You have already sent a request to this gardener.'),
  //           actions: [
  //             TextButton(
  //               child: const Text('OK'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   } else {
  //     // Check if the gardener has already accepted a request
  //     bool isAccepted = await checkAcceptedRequest(gardenerId);

  //     if (isAccepted) {
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: const Text('Request Unavailable'),
  //             content:
  //                 const Text('This gardener has already accepted a request.'),
  //             actions: [
  //               TextButton(
  //                 child: const Text('OK'),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     } else {
  //       // Send the booking request
  //       await FirebaseFirestore.instance.collection('BookingRequests').add({
  //         'customerId': customerId,
  //         'gardenerId': gardenerId,
  //         'status': 'pending',
  //       });

  //       // Show success message
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: const Text('Request Sent'),
  //             content: const Text(
  //                 'Your booking request has been sent successfully.'),
  //             actions: [
  //               TextButton(
  //                 child: const Text('OK'),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     }
  //   }
  // }

  Future<bool> checkAcceptedRequestForCustomer(
      String customerId, String gardenerId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('BookingRequests')
        .where('customerId', isEqualTo: customerId)
        .where('gardenerId', isEqualTo: gardenerId)
        .where('status', isEqualTo: 'accepted')
        .get();

    return snapshot.docs.isNotEmpty;
  }

  //this make the gardener doesn't recieve more than one request from the same customer
  //and the gardener if accepted a request he can accept another one
  Future<void> sendBookingRequest(
      BuildContext context, String gardenerId) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String customerId =
        user?.email ?? ''; // Replace with actual customer ID

    bool isPending = await checkPendingRequest(gardenerId);

    if (isPending) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Request Already Sent'),
            content:
                const Text('You have already sent a request to this gardener.'),
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
    } else {
      // Check if the customer has already had a request accepted by the gardener
      bool hasAcceptedRequest =
          await checkAcceptedRequestForCustomer(customerId, gardenerId);

      if (hasAcceptedRequest) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Request Unavailable'),
              content: const Text(
                  'You have already had a request accepted by this gardener.'),
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
      } else {
        // Send the booking request
        await FirebaseFirestore.instance.collection('BookingRequests').add({
          'customerId': customerId,
          'gardenerId': gardenerId,
          'status': 'pending',
        });

        // Show success message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Request Sent'),
              content: const Text(
                  'Your booking request has been sent successfully.'),
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
  }

  void _navigateToProfile(String gardenerId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GardenerProfile(gardenerId: gardenerId),
      ),
    );
  }

  void _navigateToAcceptedProfile(String gardenerId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AcceptedGardenerProfile(gardenerId: gardenerId),
      ),
    );
  }

  Future<List<Gardener>> fetchPendingGardeners() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String customerId =
        user?.email ?? ''; // Replace with actual customer ID

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('BookingRequests')
        .where('customerId', isEqualTo: customerId)
        .where('status', isEqualTo: 'pending')
        .get();

    List<Gardener> pendingGardeners = [];

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      String gardenerId = doc['gardenerId'];

      DocumentSnapshot gardenerSnapshot = await FirebaseFirestore.instance
          .collection('Gardners')
          .doc(gardenerId)
          .get();

      if (gardenerSnapshot.exists) {
        Gardener gardener = Gardener(
          id: gardenerId,
          firstName: gardenerSnapshot['first_name'],
          lastName: gardenerSnapshot['last_name'],
          rating: gardenerSnapshot['rating'].toDouble(),
          profilePhotoUrl: gardenerSnapshot['profilePhotoURL'],
          city: gardenerSnapshot['City'],
          requestId: doc.id,
          totalRatings: gardenerSnapshot['totalRatings'],
        );
        pendingGardeners.add(gardener);
        gardener.requestId = doc.id;
      }
    }

    return pendingGardeners;
  }

  Future<List<Gardener>> fetchAcceptedGardeners() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String customerId =
        user?.email ?? ''; // Replace with actual customer ID

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('BookingRequests')
        .where('customerId', isEqualTo: customerId)
        .where('status', isEqualTo: 'accepted')
        .get();

    List<Gardener> acceptedGardeners = [];

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      String gardenerId = doc['gardenerId'];

      DocumentSnapshot gardenerSnapshot = await FirebaseFirestore.instance
          .collection('Gardners')
          .doc(gardenerId)
          .get();

      if (gardenerSnapshot.exists) {
        Gardener gardener = Gardener(
          id: gardenerId,
          firstName: gardenerSnapshot['first_name'],
          lastName: gardenerSnapshot['last_name'],
          rating: gardenerSnapshot['rating'].toDouble(),
          profilePhotoUrl: gardenerSnapshot['profilePhotoURL'],
          city: gardenerSnapshot['City'],
          totalRatings: gardenerSnapshot['totalRatings'],
        );
        acceptedGardeners.add(gardener);
      }
    }

    return acceptedGardeners;
  }

  Future<void> cancelBookingRequest(
      BuildContext context, String requestId) async {
    try {
      await FirebaseFirestore.instance
          .collection('BookingRequests')
          .doc(requestId)
          .update({'status': 'canceled'});

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Request Canceled'),
            content: const Text('Your booking request has been canceled.'),
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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to cancel the booking request.'),
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

  Future<void> refreshAvailableGardeners() async {
    setState(() {
      isDataLoading = true; // Set loading state to true
    });

    // Fetch the updated data here
    await fetchGardeners(); // Replace with your data fetching method

    setState(() {
      isDataLoading = false; // Set loading state to false after data is fetched
    });
  }

// Pending requests tab
  Future<void> refreshPendingRequests() async {
    setState(() {
      isDataLoading = true; // Set loading state to true
    });

    // Fetch the updated data here
    await fetchPendingGardeners(); // Replace with your data fetching method

    setState(() {
      isDataLoading = false; // Set loading state to false after data is fetched
    });
  }

// Accepted requests tab
  Future<void> refreshAcceptedRequests() async {
    setState(() {
      isDataLoading = true; // Set loading state to true
    });

    // Fetch the updated data here
    await fetchAcceptedGardeners(); // Replace with your data fetching method

    setState(() {
      isDataLoading = false; // Set loading state to false after data is fetched
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              const Color.fromARGB(255, 241, 236, 236), // Change app bar color
          title: const Text('Book Gardeners',
              style: TextStyle(color: Color(0xff296e48))),
          iconTheme: const IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          // actions: [
          //   // Available gardeners tab refresh button
          //   if (_tabController.index == 0)
          //     IconButton(
          //       icon: Icon(Icons.refresh),
          //       onPressed: refreshAvailableGardeners,
          //     ),

          //   // Pending requests tab refresh button
          //   if (_tabController.index == 1)
          //     IconButton(
          //       icon: Icon(Icons.refresh),
          //       onPressed: refreshPendingRequests,
          //     ),

          //   // Accepted requests tab refresh button
          //   if (_tabController.index == 2)
          //     IconButton(
          //       icon: Icon(Icons.refresh),
          //       onPressed: refreshAcceptedRequests,
          //     ),
          // ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 241, 236, 236),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TabBar(
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        labelColor: const Color(
                            0xff296e48), // Change the selected tab text color
                        unselectedLabelColor: const Color.fromARGB(255, 0, 0,
                            0), // Change the unselected tab text color
                        tabs: const [
                          Tab(text: 'Available', icon: Icon(Icons.home)),
                          Tab(text: 'Pending', icon: Icon(Icons.pending)),
                          Tab(text: 'Accepted', icon: Icon(Icons.check_circle)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // Available gardeners tab
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FutureBuilder<List<String>>(
                    future: fetchCities(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<String> cities = snapshot.data!;
                        return DropdownButtonFormField<String>(
                          value: selectedCity,
                          onChanged: (String? value) {
                            setState(() {
                              selectedCity = value ?? '';
                            });
                          },
                          items: cities
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            labelText: 'Select City',
                            border: OutlineInputBorder(),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return const Text('Error fetching cities');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Gardener>>(
                    future: fetchGardeners(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (snapshot.hasData) {
                        gardeners = snapshot.data!;
                        return ListView.separated(
                          itemCount: gardeners.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider(); // Add a divider between gardeners
                          },
                          itemBuilder: (context, index) {
                            Gardener gardener = gardeners[index];
                            return ListTile(
                              title: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundImage:
                                        NetworkImage(gardener.profilePhotoUrl),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, bottom: 10, top: 10),
                                        child: Text(
                                          '${gardener.firstName} ${gardener.lastName}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'times new roman'),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            color: Colors.grey,
                                            size: 16,
                                          ),
                                          Text(
                                            gardener.city,
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              subtitle: Padding(
                                padding:
                                    const EdgeInsets.only(left: 60.0, top: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      'Rating: ${gardener.rating.toString()} / 5',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(width: 8),
                                    const Row(
                                      children: [
                                        Icon(Icons.star,
                                            color: Color.fromARGB(
                                                255, 212, 194, 30),
                                            size: 16),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff296e48),
                                    ),
                                    onPressed: () {
                                      _navigateToProfile(gardener.id);
                                    },
                                    child: const Text('View'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 126, 147, 130),
                                    ),
                                    onPressed: () {
                                      sendBookingRequest(context, gardener.id);
                                    },
                                    child: const Text('Book'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return const Text('Error fetching gardeners');
                      } else {
                        return const Text('No gardeners found');
                      }
                    },
                  ),
                ),
              ],
            ),

            // Pending requests tab
            FutureBuilder<List<Gardener>>(
              future: fetchPendingGardeners(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasData) {
                  List<Gardener> pendingGardeners = snapshot.data!;

                  if (pendingGardeners.isEmpty) {
                    return const Text('No pending requests');
                  }

                  return ListView.separated(
                    itemCount: pendingGardeners.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(); // Add a divider between gardeners
                    },
                    itemBuilder: (context, index) {
                      Gardener gardener = pendingGardeners[index];
                      return ListTile(
                        title: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage:
                                  NetworkImage(gardener.profilePhotoUrl),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, bottom: 10, top: 10),
                                  child: Text(
                                    '${gardener.firstName} ${gardener.lastName}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'times new roman'),
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.grey,
                                      size: 16,
                                    ),
                                    Text(
                                      gardener.city,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 60.0, top: 10),
                          child: Row(
                            children: [
                              Text(
                                'Rating: ${gardener.rating.toString()} / 5',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(width: 8),
                              const Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Color.fromARGB(255, 212, 194, 30),
                                      size: 16),
                                ],
                              ),
                            ],
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff296e48),
                              ),
                              onPressed: () {
                                _navigateToProfile(gardener.id);
                              },
                              child: const Text('View'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: gardener.requestId != null
                                  ? () {
                                      cancelBookingRequest(
                                          context, gardener.requestId!);
                                    }
                                  : null, // Disable button if requestId is null
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return const Text('Error fetching pending gardeners');
                } else {
                  return const Text('No pending gardeners found');
                }
              },
            ),

            // Accepted requests tab
            FutureBuilder<List<Gardener>>(
              future: fetchAcceptedGardeners(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasData) {
                  List<Gardener> acceptedGardeners = snapshot.data!;

                  if (acceptedGardeners.isEmpty) {
                    return const Text('No accepted requests');
                  }

                  return ListView.separated(
                    itemCount: acceptedGardeners.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(); // Add a divider between gardeners
                    },
                    itemBuilder: (context, index) {
                      Gardener gardener = acceptedGardeners[index];
                      return ListTile(
                        title: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage:
                                  NetworkImage(gardener.profilePhotoUrl),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, bottom: 10, top: 10),
                                  child: Text(
                                    '${gardener.firstName} ${gardener.lastName}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'times new roman'),
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.grey,
                                      size: 16,
                                    ),
                                    Text(
                                      gardener.city,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 60.0, top: 10),
                          child: Row(
                            children: [
                              Text(
                                'Rating: ${gardener.rating.toString()} / 5',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(width: 8),
                              const Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Color.fromARGB(255, 212, 194, 30),
                                      size: 16),
                                ],
                              ),
                            ],
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff296e48),
                              ),
                              onPressed: () {
                                _navigateToAcceptedProfile(gardener.id);
                              },
                              child: const Text('View'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                rateGardener(context, gardener);
                              },
                              child: const Text('Rate'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return const Text('Error fetching accepted gardeners');
                } else {
                  return const Text('No accepted gardeners found');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
