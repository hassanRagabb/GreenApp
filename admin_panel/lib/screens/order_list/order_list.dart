import 'package:admin_panel/constants/constants.dart';
import 'package:admin_panel/models/order_model/order_model.dart';
import 'package:admin_panel/provider/app_provider.dart';
import 'package:admin_panel/widgets/single_order_widget/single_order_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderList extends StatelessWidget {
  final String title;
  const OrderList({super.key, required this.title});

  List<OrderModel> getOrderList(AppProvider appProvider) {
    if (title == "Pending") {
      return appProvider.getPendingOrderList;
    } else if (title == "Completed") {
      return appProvider.getCompletedOrderList;
    } else if (title == "Cancel") {
      return appProvider.getCancelOrderList;
    } else if (title == "Delivery") {
      return appProvider.getDeliveryOrderList;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 50.0,
            ),
            Row(
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
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "$title Order List",
                    style: const TextStyle(
                      color: Color(0xff296e48),
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
            getOrderList(appProvider).isEmpty
                ? Center(
                    child: Text(
                      "$title is empty",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: getOrderList(appProvider).length,
                      itemBuilder: (context, index) {
                        OrderModel orderModel =
                            getOrderList(appProvider)[index];
                        return SingleOrderWidget(orderModel: orderModel);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
