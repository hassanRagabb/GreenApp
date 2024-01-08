import 'package:admin_panel/constants/constants.dart';
import 'package:admin_panel/helpers/firebase_firestore_helper/firebase_firestore.dart';
import 'package:admin_panel/screens/product_view/edit_product/edit_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/routes.dart';
import '../../../models/product_model/product_model.dart';
import '../../../provider/app_provider.dart';

class SingleProductView extends StatefulWidget {
  const SingleProductView({
    super.key,
    required this.singleProduct,
    required this.index,
  });

  final ProductModel singleProduct;
  final int index;

  @override
  State<SingleProductView> createState() => _SingleProductViewState();
}

class _SingleProductViewState extends State<SingleProductView> {
  FirebaseFirestoreHelper firestoreHelper = FirebaseFirestoreHelper.instance;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );

    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Constants.primaryColor.withOpacity(.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        // alignment: Alignment.topRight,
        children: [
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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
          Positioned(
            right: 0.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IgnorePointer(
                    ignoring: isLoading,
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });
                        await appProvider
                            .deleteProductsFromFirebase(widget.singleProduct);
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : const Icon(
                              Icons.delete,
                              color: Color.fromARGB(255, 60, 54, 54),
                            ),
                    ),
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Routes.instance.push(
                          widget: EditProduct(
                            productModel: widget.singleProduct,
                            index: widget.index,
                          ),
                          context: context);
                    },
                    child: const Icon(Icons.edit),
                  ),
                  const SizedBox(
                    width: 12.0,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
