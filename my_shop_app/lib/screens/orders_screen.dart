import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart';
import '../widgets/order_item_tile.dart';
import '../providers/orders.dart';
import 'package:provider/provider.dart';

// ignore: use_key_in_widget_constructors
class OrdersScreen extends StatelessWidget {
  static const String routeName = "/orders_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            // final data = dataSnapshot.data;
            // print(data);
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              return const Center(
                child: Text(
                  'An error occurred While Fetching your Orders please try after some time ',
                  textAlign: TextAlign.center,
                ),
              );
              // do error handling stuff here
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderProvider, _) {
                  return ListView.builder(
                    itemBuilder: (ctx, index) {
                      return OrderItemTile(
                        order: orderProvider.orders[index],
                      );
                    },
                    itemCount: orderProvider.orders.length,
                  );
                },
              );
            }
          }
        },
      ),
      drawer: const MainDrawer(),
    );
  }
}
/*
_isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return OrderItemTile(
                  order: orderProvider.orders[index],
                );
              },
              itemCount: orderProvider.orders.length,
            ),
      drawer: const MainDrawer(),
    );
*/
