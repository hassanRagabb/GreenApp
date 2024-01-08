import 'package:Green/Green_Store/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Green/Green_Store/constants/constants.dart';
import 'package:Green/Green_Store/constants/routes.dart';
import 'package:Green/Green_Store/models/product_model/product_model.dart';
import 'package:Green/Green_Store/screens/product_details/product_details.dart';

class PlantWidget extends StatefulWidget {
  final ProductModel singleProduct;
  const PlantWidget({super.key, required this.singleProduct});

  @override
  State<PlantWidget> createState() => _PlantWidget();
}

class _PlantWidget extends State<PlantWidget> {
  FirebaseFirestoreHelper firestoreHelper = FirebaseFirestoreHelper.instance;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Routes.instance.push(
          widget: ProductDetails(
            singleProduct: widget.singleProduct,
          ),
          context: context,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Constants.primaryColor.withOpacity(.1),
          borderRadius: BorderRadius.circular(10),
        ),
        height: 80.0,
        padding: const EdgeInsets.only(left: 10, top: 10),
        margin: const EdgeInsets.only(bottom: 10, top: 10),
        width: size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: Constants.primaryColor.withOpacity(.8),
                    shape: BoxShape.circle,
                  ),
                ),
                Positioned(
                  bottom: 5,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 80.0,
                    child: Image.network(widget.singleProduct.image),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  left: 80,
                  child: FutureBuilder<String>(
                    future: firestoreHelper
                        .getCategoryName(widget.singleProduct.categoryId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xff296e48)),
                        );
                      }
                      if (snapshot.hasError) {
                        return const Text('Error retrieving category name');
                      }
                      final categoryName = snapshot.data;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(categoryName!),
                          Text(
                            widget.singleProduct.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Constants.blackColor,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                r'$' + widget.singleProduct.price.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Constants.primaryColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
