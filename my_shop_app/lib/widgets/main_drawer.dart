import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../screens/user_products_screen.dart';
import '../screens/orders_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text("User Info"),
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.arrow_back),
            ),
            automaticallyImplyLeading: false,
          ),
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              ListTile(
                title: const Text("HomeScreen"),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                title: const Text("Order History"),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(OrdersScreen.routeName);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                title: const Text("Admin Products"),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(UserProductsScreen.routeName);
                },
              ),
              ListTile(
                title: const Text('Log Out'),
                trailing: const Icon(Icons.logout),
                onTap: () {
                  Navigator.pop(context);
                  Provider.of<Auth>(context, listen: false).logOut();
                  Navigator.of(context).pushReplacementNamed('/');
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
