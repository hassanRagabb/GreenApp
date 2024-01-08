import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Green/Green_Store/constants/constants.dart';
import 'package:Green/Green_Store/screens/plants_widgets/plant_widget.dart';
import 'package:Green/Green_Store/provider/app_provider.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );

    return Scaffold(
      body: appProvider.getFavouriteProductList.isEmpty
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    child: Image.asset(
                        'lib/Green_Store/assets/images/favorited.png'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Your favorited Plants',
                    style: TextStyle(
                      color: Constants.primaryColor,
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 50),
                  shrinkWrap: true,
                  primary: false,
                  itemCount: appProvider.getFavouriteProductList.length,
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    return PlantWidget(
                      singleProduct: appProvider.getFavouriteProductList[index],
                    );
                  }),
            ),
    );
  }
}
