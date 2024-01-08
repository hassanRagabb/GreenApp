import 'package:Green/Green_Store/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:Green/Green_Store/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:Green/Green_Store/models/product_model/product_model.dart';

class CustomBottomSheet extends StatefulWidget {
  final void Function(List<ProductModel>) onFilterListChanged;

  const CustomBottomSheet({Key? key, required this.onFilterListChanged})
      : super(key: key);

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  List<String> sizes = ["Small", "Medium", "Large"];
  List<String> colors = ["Red", "Green", "Blue", "Pink", "Yellow"];
  Map<String, Color> colorMap = {
    "Red": Colors.red,
    "Green": Colors.green,
    "Blue": Colors.blue,
    "Pink": Colors.pink,
    "Yellow": Colors.yellow
  };
  List<String> fiterColor = [];
  List<String> fiterList1 = [];
  List<ProductModel> productModelList = [];
  double? minPrice;
  double? maxPrice;
  bool isLoading = false;

  @override
  void initState() {
    getCategoryList();
    super.initState();
  }

  void getCategoryList() async {
    setState(() {
      isLoading = true;
    });
    // FirebaseFirestoreHelper.instance.updateTokenFromFirebase();
    productModelList = await FirebaseFirestoreHelper.instance.getBestProducts();

    productModelList.shuffle();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void searchColor(String color) {
    fiterColor = productModelList
        .where((element) => element.color.toLowerCase() == color.toLowerCase())
        .map((element) => element.size)
        .toList();
    updateFilteredList();
  }

  void searchProducts(String value) {
    fiterList1 = productModelList
        .where((element) =>
            element.size.toLowerCase().contains(value.toLowerCase()))
        .map((element) => element.size)
        .toList();
    updateFilteredList();
  }

  void updateFilteredList() {
    List<ProductModel> filteredList = productModelList;

    if (fiterList1.isNotEmpty) {
      filteredList = filteredList
          .where((element) => fiterList1.contains(element.size))
          .toList();
    }

    if (fiterColor.isNotEmpty) {
      filteredList = filteredList
          .where((element) => fiterColor.contains(element.color))
          .toList();
    }

    if (minPrice != null) {
      filteredList =
          filteredList.where((element) => element.price >= minPrice!).toList();
    }

    if (maxPrice != null) {
      filteredList =
          filteredList.where((element) => element.price <= maxPrice!).toList();
    }

    widget.onFilterListChanged(filteredList);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        fiterList1.clear();
                        fiterColor.clear();
                        minPrice = null;
                        maxPrice = null;
                      });
                      updateFilteredList();
                    },
                    icon: const Icon(Icons.clear_all_sharp),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              const Text(
                "Size",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: sizes
                    .map(
                      (size) => ChoiceChip(
                        label: Text(size),
                        selected: fiterList1.contains(size),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              fiterList1.add(size);
                            });
                          } else {
                            setState(() {
                              fiterList1.remove(size);
                            });
                          }
                          updateFilteredList();
                        },
                        backgroundColor: Constants.primaryColor,
                        selectedColor: Constants.primaryColor.withOpacity(.6),
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 10),
              const Text(
                "Color",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: colors
                    .map(
                      (color) => GestureDetector(
                        onTap: () {
                          setState(() {
                            if (fiterColor.contains(color)) {
                              fiterColor.remove(color);
                            } else {
                              fiterColor.add(color);
                            }
                          });
                          updateFilteredList();
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: colorMap[color],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: fiterColor.contains(color)
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 2.5,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 10),
              const Text(
                "Price",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SliderTheme(
                data: SliderThemeData(
                  thumbColor: Constants.primaryColor,
                  activeTrackColor: Constants.primaryColor.withOpacity(.5),
                  inactiveTrackColor: Constants.primaryColor.withOpacity(.2),
                  overlayColor: Constants.primaryColor.withOpacity(.5),
                  trackHeight: 5.0,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 16.0),
                ),
                child: RangeSlider(
                  values: RangeValues(minPrice ?? 0, maxPrice ?? 100),
                  min: 0,
                  max: 100,
                  divisions: 100,
                  labels: RangeLabels(
                    minPrice?.toString() ?? '0',
                    maxPrice?.toString() ?? '100',
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      minPrice = values.start;
                      maxPrice = values.end;
                    });
                    updateFilteredList();
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
