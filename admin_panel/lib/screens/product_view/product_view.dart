import 'package:admin_panel/constants/constants.dart';
import 'package:admin_panel/constants/routes.dart';
import 'package:admin_panel/screens/product_view/add_product/add_product.dart';
import 'package:admin_panel/screens/product_view/widgets/single_product_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product_model/product_model.dart';
import '../../provider/app_provider.dart';

class ProductView extends StatefulWidget {
  const ProductView({Key? key}) : super(key: key);

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      body: SingleChildScrollView(
        // Wrap the entire Column with SingleChildScrollView
        child: Column(
          children: [
            const SizedBox(
              height: 50.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Constants.primaryColor.withOpacity(.15),
                      ),
                      child: Icon(
                        Icons.close,
                        color: Constants.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Products',
                      style: TextStyle(
                        color: Color(0xff296e48),
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  IconButton(
                    onPressed: () {
                      Routes.instance
                          .push(widget: const AddProduct(), context: context);
                    },
                    icon: const Icon(
                      Icons.add_circle,
                      color: Color(0xff296e48),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: appProvider.getProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 0.9,
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (ctx, index) {
                      ProductModel singleProduct =
                          appProvider.getProducts[index];
                      return SingleProductView(
                        singleProduct: singleProduct,
                        index: index,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
