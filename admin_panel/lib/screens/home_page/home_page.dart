import 'package:admin_panel/constants/constants.dart';
import 'package:admin_panel/constants/routes.dart';
import 'package:admin_panel/provider/app_provider.dart';
import 'package:admin_panel/screens/categories_view/categories_view.dart';
import 'package:admin_panel/screens/home_page/widgets/single_dash_item.dart';
import 'package:admin_panel/screens/notification_screen/notification_screen.dart';
import 'package:admin_panel/screens/order_list/order_list.dart';
import 'package:admin_panel/screens/product_view/product_view.dart';
import 'package:admin_panel/screens/user_view/user_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  void getData() async {
    setState(() {
      isLoading = true;
    });
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    await appProvider.callBackFuncation();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          "Dashboard",
          style: TextStyle(
            color: Color(0xff296e48),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xff296e48),
                        child: Icon(
                          Icons.admin_panel_settings,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Mohamed Elgabry",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "mohamedelgabrey45@gmail.com",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
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
                        onPressed: () {
                          Routes.instance.push(
                              widget: const NotificationScreen(),
                              context: context);
                        },
                        child: const Center(
                          child: Text(
                            'Send notification to all users',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    GridView.count(
                      shrinkWrap: true,
                      primary: false,
                      padding: const EdgeInsets.only(top: 12.0),
                      crossAxisCount: 2,
                      children: [
                        SingleDashItem(
                          subtitle: "Users",
                          onPressed: () {
                            Routes.instance.push(
                                widget: const UserView(), context: context);
                          },
                          title: appProvider.getUserList.length.toString(),
                        ),
                        SingleDashItem(
                          subtitle: "Categories",
                          onPressed: () {
                            Routes.instance.push(
                                widget: const CategoriesView(),
                                context: context);
                          },
                          title: appProvider.getCategories.length.toString(),
                        ),
                        SingleDashItem(
                          subtitle: "Products",
                          onPressed: () {
                            Routes.instance.push(
                              widget: const ProductView(),
                              context: context,
                            );
                          },
                          title: appProvider.getProducts.length.toString(),
                        ),
                        SingleDashItem(
                          subtitle: "Earning",
                          onPressed: () {},
                          title: "\$${appProvider.getTotalEarning}",
                        ),
                        SingleDashItem(
                          subtitle: "Pending Order",
                          onPressed: () {
                            Routes.instance.push(
                              widget: const OrderList(
                                title: "Pending",
                              ),
                              context: context,
                            );
                          },
                          title:
                              appProvider.getPendingOrderList.length.toString(),
                        ),
                        SingleDashItem(
                          onPressed: () {
                            Routes.instance.push(
                              widget: const OrderList(
                                title: "Delivery",
                              ),
                              context: context,
                            );
                          },
                          subtitle: "Delivery Order",
                          title: appProvider.getDeliveryOrderList.length
                              .toString(),
                        ),
                        SingleDashItem(
                          onPressed: () {
                            Routes.instance.push(
                              widget: const OrderList(
                                title: "Cancel",
                              ),
                              context: context,
                            );
                          },
                          subtitle: "Cancel Order",
                          title:
                              appProvider.getCancelOrderList.length.toString(),
                        ),
                        SingleDashItem(
                          subtitle: "Completed Order",
                          title: appProvider.getCompletedOrderList.length
                              .toString(),
                          onPressed: () {
                            Routes.instance.push(
                              widget: const OrderList(
                                title: "Completed",
                              ),
                              context: context,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
