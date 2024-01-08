import 'package:Green/Green_Store/screens/plants_widgets/card_plant_widget.dart';
import 'package:Green/Green_Store/screens/plants_widgets/plant_widget.dart';
import 'package:flutter/material.dart';
import 'package:Green/Green_Store/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:Green/Green_Store/models/category_model/category_model.dart';
import 'package:Green/Green_Store/models/product_model/product_model.dart';
import 'package:Green/Green_Store/constants/constants.dart';
import 'package:Green/Green_Store/screens/home/widgets/filter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ProductModel> fiterList1 = [];
  List<CategoryModel> categoriesList = [];
  List<ProductModel> productModelList = [];
  int selectedIndex = 0;
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
    categoriesList = await FirebaseFirestoreHelper.instance.getCategories();
    productModelList = await FirebaseFirestoreHelper.instance.getBestProducts();

    productModelList.shuffle();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  TextEditingController search = TextEditingController();
  List<ProductModel> searchList = [];
  void searchProducts(String value) {
    searchList = productModelList
        .where((element) =>
            element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
    setState(() {});
  }

  TextEditingController searchCategories = TextEditingController();
  List<ProductModel> searchListCategories = [];
  void searchProductsCategories(String value) {
    searchListCategories = productModelList
        .where((element) =>
            element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: isLoading
          ? Center(
              child: Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: size.width * .8,
                          decoration: BoxDecoration(
                            color: Constants.primaryColor.withOpacity(.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.black54.withOpacity(.6),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: search,
                                  onChanged: (String value) {
                                    searchProducts(value);
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Search Plants',
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 7.0),
                                child: Icon(
                                  Icons.mic,
                                  color: Colors.black54.withOpacity(.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7.0),
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => CustomBottomSheet(
                                  onFilterListChanged: (filteredList) {
                                    setState(() {
                                      fiterList1 = filteredList;
                                    });
                                  },
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xff296e48),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.filter_list_alt,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 50.0,
                    width: size.width,
                    child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: categoriesList.map((e) {
                            int index = categoriesList.indexOf(e);
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                    searchListCategories = productModelList
                                        .where((product) =>
                                            product.categoryId == e.id)
                                        .toList();
                                  });
                                },
                                child: Text(
                                  e.name,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: selectedIndex == index
                                        ? FontWeight.bold
                                        : FontWeight.w300,
                                    color: selectedIndex == index
                                        ? Constants.primaryColor
                                        : Constants.blackColor,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.3,
                    child: ListView.builder(
                      itemCount: searchListCategories.isEmpty
                          ? 2
                          : searchListCategories.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, index) {
                        ProductModel singleProduct =
                            searchListCategories.isEmpty
                                ? productModelList[index]
                                : searchListCategories[index];
                        return CardPlantWidget(
                          singleProduct: singleProduct,
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  if (!isSearched())
                    const Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 12.0, left: 12.0),
                          child: Text(
                            "New Plants",
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    SizedBox.fromSize(),
                  const SizedBox(
                    height: 12.0,
                  ),
                  if (search.text.isNotEmpty && searchList.isEmpty)
                    const Center(
                      child: Text("No Product Found"),
                    )
                  else if (searchList.isNotEmpty && fiterList1.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 50),
                          shrinkWrap: true,
                          primary: false,
                          itemCount: searchList.length,
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            ProductModel singleProduct = searchList[index];
                            if (index == (searchList.length - 1)) {
                              searchList.clear();
                            }
                            return PlantWidget(singleProduct: singleProduct);
                          }),
                    )
                  else if (fiterList1.isNotEmpty && searchList.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 50),
                          shrinkWrap: true,
                          primary: false,
                          itemCount: fiterList1.length,
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            ProductModel singleProduct = fiterList1[index];
                            if ((fiterList1.length - 1) == index) {
                              fiterList1.clear();
                            }
                            return PlantWidget(singleProduct: singleProduct);
                          }),
                    )
                  else if (fiterList1.isNotEmpty && searchList.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 50),
                          shrinkWrap: true,
                          primary: false,
                          itemCount: fiterList1.length,
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            ProductModel singleProduct = fiterList1[index];
                            return PlantWidget(singleProduct: singleProduct);
                          }),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 50),
                          shrinkWrap: true,
                          primary: false,
                          itemCount: productModelList.length,
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            ProductModel singleProduct =
                                productModelList[index];
                            return PlantWidget(singleProduct: singleProduct);
                          }),
                    ),
                  const SizedBox(
                    height: 12.0,
                  ),
                ],
              ),
            ),
    );
  }

  bool isSearched() {
    if (search.text.isNotEmpty && searchList.isEmpty) {
      return true;
    } else if (search.text.isEmpty && searchList.isNotEmpty) {
      return false;
    } else if (searchList.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
