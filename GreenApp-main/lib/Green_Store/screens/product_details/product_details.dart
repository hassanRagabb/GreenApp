import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Green/Green_Store/constants/constants.dart';
import 'package:Green/Green_Store/constants/routes.dart';
import 'package:Green/Green_Store/models/product_model/product_model.dart';
import 'package:Green/Green_Store/provider/app_provider.dart';
import 'package:Green/Green_Store/screens/check_out/check_out.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel singleProduct;
  const ProductDetails({super.key, required this.singleProduct});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int qty = 1;
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   // statusBarColor: backgroundColor,
    //   systemNavigationBarColor: Color(0xFFa9c5b6),
    // ));
    Size size = MediaQuery.of(context).size;
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
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
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Constants.primaryColor.withOpacity(.15),
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            widget.singleProduct.isFavourite =
                                !widget.singleProduct.isFavourite;
                          });
                          if (widget.singleProduct.isFavourite) {
                            appProvider
                                .addFavouriteProduct(widget.singleProduct);
                          } else {
                            appProvider
                                .removeFavouriteProduct(widget.singleProduct);
                          }
                        },
                        icon: Icon(
                          appProvider.getFavouriteProductList
                                  .contains(widget.singleProduct)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Constants.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Positioned(
                      top: 10,
                      left: 0,
                      child: SizedBox(
                        height: 350,
                        child: Image.network(
                          widget.singleProduct.image,
                          height: 200,
                          width: 250,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0, bottom: 20.0),
                    child: SizedBox(
                      height: 250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              const Text(
                                'Size',
                              ),
                              const SizedBox(height: 6),
                              Text(
                                widget.singleProduct.size,
                                style: const TextStyle(
                                  color: Color(0xff296e48),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Column(
                            children: [
                              const Text(
                                'Color',
                              ),
                              const SizedBox(height: 6),
                              Text(
                                widget.singleProduct.color,
                                style: const TextStyle(
                                  color: Color(0xff296e48),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Column(
                            children: [
                              const Text(
                                'Temp°C',
                              ),
                              const SizedBox(height: 6),
                              Text(
                                widget.singleProduct.temperature,
                                style: const TextStyle(
                                  color: Color(0xff296e48),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Column(
                            children: [
                              const Text(
                                'Humidity',
                              ),
                              const SizedBox(height: 6),
                              Text(
                                widget.singleProduct.humidity,
                                style: const TextStyle(
                                  color: Color(0xff296e48),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
                  height: size.height * .4765,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Constants.primaryColor.withOpacity(.4),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.singleProduct.name,
                                style: TextStyle(
                                  color: Constants.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30.0,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                r'$' + widget.singleProduct.price.toString(),
                                style: TextStyle(
                                  color: Constants.blackColor,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                widget.singleProduct.rating,
                                style: TextStyle(
                                  fontSize: 30.0,
                                  color: Constants.primaryColor,
                                ),
                              ),
                              Icon(
                                Icons.star,
                                size: 30.0,
                                color: Constants.primaryColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            widget.singleProduct.description,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              height: 1.5,
                              fontSize: 18,
                              color: Constants.blackColor.withOpacity(.7),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Row(
                        children: [
                          CupertinoButton(
                            onPressed: () {
                              if (qty >= 1) {
                                setState(() {
                                  qty--;
                                });
                              }
                            },
                            padding: EdgeInsets.zero,
                            child: const CircleAvatar(
                              backgroundColor: Color(0x80296e48),
                              child: Icon(Icons.remove, color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            width: 12.0,
                          ),
                          Text(
                            qty.toString(),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            width: 12.0,
                          ),
                          CupertinoButton(
                            onPressed: () {
                              setState(() {
                                qty++;
                              });
                            },
                            padding: EdgeInsets.zero,
                            child: const CircleAvatar(
                              backgroundColor: Color(0x80296e48),
                              child: Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(6.0),
        child: SizedBox(
          width: size.width * .9,
          height: 50,
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: Constants.primaryColor.withOpacity(.5),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 1),
                        blurRadius: 5,
                        color: Constants.primaryColor.withOpacity(.3),
                      ),
                    ]),
                child: IconButton(
                    onPressed: () {
                      ProductModel productModel =
                          widget.singleProduct.copyWith(qty: qty);
                      appProvider.addCartProduct(productModel);
                      showMessage("Added to Cart");
                    },
                    icon: Icon(
                      Icons.shopping_cart,
                      color: appProvider.getCartProductList
                              .contains(widget.singleProduct)
                          ? Constants.primaryColor.withOpacity(1)
                          : Colors.white,
                    )),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Container(
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
                    onPressed: () {
                      ProductModel productModel =
                          widget.singleProduct.copyWith(qty: qty);
                      Routes.instance.push(
                        widget: Checkout(singleProduct: productModel),
                        context: context,
                      );
                    },
                    child: const Center(
                      child: Text(
                        'BUY NOW',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
