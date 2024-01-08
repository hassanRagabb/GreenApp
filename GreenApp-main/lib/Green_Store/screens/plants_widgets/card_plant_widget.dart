import 'package:Green/Green_Store/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:Green/Green_Store/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:Green/Green_Store/constants/constants.dart';
import 'package:Green/Green_Store/constants/routes.dart';
import 'package:Green/Green_Store/models/product_model/product_model.dart';
import 'package:Green/Green_Store/screens/product_details/product_details.dart';
import 'package:provider/provider.dart';

class CardPlantWidget extends StatefulWidget {
  final ProductModel singleProduct;
  const CardPlantWidget({super.key, required this.singleProduct});

  @override
  State<CardPlantWidget> createState() => _CardPlantWidget();
}

class _CardPlantWidget extends State<CardPlantWidget> {
  List<ProductModel> productModelList = [];
  FirebaseFirestoreHelper firestoreHelper = FirebaseFirestoreHelper.instance;

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

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
        width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Constants.primaryColor.withOpacity(.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 10,
              right: 20,
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      widget.singleProduct.isFavourite =
                          !widget.singleProduct.isFavourite;
                    });
                    if (widget.singleProduct.isFavourite) {
                      appProvider.addFavouriteProduct(widget.singleProduct);
                    } else {
                      appProvider.removeFavouriteProduct(widget.singleProduct);
                    }
                  },
                  icon: Icon(
                    appProvider.getFavouriteProductList
                            .contains(widget.singleProduct)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Constants.primaryColor,
                  ),
                  iconSize: 30,
                ),
              ),
            ),
            Positioned(
              left: 50,
              right: 50,
              top: 50,
              bottom: 50,
              child: Image.network(widget.singleProduct.image),
            ),
            Positioned(
              bottom: 15,
              left: 20,
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
                      Text(
                        categoryName!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        widget.singleProduct.name,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Positioned(
              bottom: 15,
              right: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  r'$' + widget.singleProduct.price.toString(),
                  style: TextStyle(color: Constants.primaryColor, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
