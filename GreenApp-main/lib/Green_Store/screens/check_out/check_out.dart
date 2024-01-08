import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Green/Green_Store/constants/constants.dart';
import 'package:Green/Green_Store/constants/routes.dart';
import 'package:Green/Green_Store/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:Green/Green_Store/models/product_model/product_model.dart';
import 'package:Green/Green_Store/screens/bottom_bar/bottom_bar.dart';
import 'package:Green/Green_Store/provider/app_provider.dart';
//import 'package:Green/Green_Store/stripe_helper/stripe_helper.dart';

class Checkout extends StatefulWidget {
  final ProductModel singleProduct;

  const Checkout({super.key, required this.singleProduct});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  int groupValue = 1;

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );

    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Checkout',
                        style: TextStyle(
                          color: Color(0xff296e48),
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 36.0,
                    ),
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5ECE8),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: Constants.primaryColor.withOpacity(0.5),
                          width: 3.0,
                        ),
                      ),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Radio(
                            value: 1,
                            groupValue: groupValue,
                            onChanged: (value) {
                              setState(() {
                                groupValue = value!;
                              });
                            },
                          ),
                          const Icon(Icons.attach_money_rounded),
                          const SizedBox(
                            width: 12.0,
                          ),
                          const Text(
                            "Cash on Delivery",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5ECE8),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: Constants.primaryColor.withOpacity(0.5),
                          width: 3.0,
                        ),
                      ),
                      width: double.infinity,
                      // child: Row(
                      //   children: [
                      //     Radio(
                      //       value: 2,
                      //       groupValue: groupValue,
                      //       onChanged: (value) {
                      //         setState(() {
                      //           groupValue = value!;
                      //         });
                      //       },
                      //     ),
                      //     const Icon(Icons.money),
                      //     const SizedBox(
                      //       width: 12.0,
                      //     ),
                      //     const Text(
                      //       "Pay Online",
                      //       style: TextStyle(
                      //         fontSize: 18.0,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Constants.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
                            blurRadius: 5,
                            color: Constants.primaryColor.withOpacity(.3),
                          ),
                        ],
                      ),
                      child: TextButton(
                        onPressed: () async {
                          appProvider.clearBuyProduct();
                          appProvider.addBuyProduct(widget.singleProduct);

                          if (groupValue == 1) {
                            bool value = await FirebaseFirestoreHelper.instance
                                .uploadOrderedProductFirebase(
                              appProvider.getBuyProductList,
                              context,
                              "Cash on delivery",
                            );

                            appProvider.clearBuyProduct();
                            if (value) {
                              Future.delayed(const Duration(seconds: 2), () {
                                Routes.instance.push(
                                  widget: const BottomBar(),
                                  context: context,
                                );
                              });
                            }
                         } //else {
                          //   int value = double.parse(
                          //     appProvider.totalPriceBuyProductList().toString(),
                          //   ).round().toInt();
                          //   String totalPrice = (value * 100).toString();
                          //   await StripeHelper.instance.makePayment(
                          //     totalPrice.toString(),
                          //     context,
                          //   );
                          // }
                        },
                        child: const Center(
                          child: Text(
                            'CHECKOUT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
