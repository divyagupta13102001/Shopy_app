// ignore_for_file: constant_identifier_names
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../screens/cart_screen.dart';
import '../providers/cart.dart';
import '../widgets/products_grid.dart';
import '../widgets/main_drawer.dart';
import '../widgets/badge.dart';
import '../providers/products_provider.dart';
import 'package:badges/badges.dart' as badges;

enum FilterOptions { Favorites, All }

// ignore: use_key_in_widget_constructors
class ProductOverView extends StatefulWidget {
  static const String routeName = '/product_overview_screen';

  @override
  State<ProductOverView> createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverView> {
  var _showOnlyFav = false;
  var _isInitialized = false;
  var _isLoading = false;

  @override
  void initState() {
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context, listen: false).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInitialized) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInitialized = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MyShopApp"),
        actions: [
          Consumer<Cart>(
            builder: (context, cart, child) {
              return badges.Badge(
                badgeContent: Text(cart.size.toString()),
                // color: Colors.amber,
                child: child!,
              );
            },
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            onSelected: (FilterOptions selectedValue) {
              if (selectedValue == FilterOptions.Favorites) {
                setState(() {
                  _showOnlyFav = true;
                });
              } else {
                setState(() {
                  _showOnlyFav = false;
                });
              }
            },
            itemBuilder: (_) {
              return [
                const PopupMenuItem(
                  value: FilterOptions.Favorites,
                  child: Text('Only Favorites'),
                ),
                const PopupMenuItem(
                  value: FilterOptions.All,
                  child: Text('All Products'),
                ),
              ];
            },
          ),
        ],
      ),
      drawer: const MainDrawer(),

      // using the grid view builder
      /**
      
      requirements are - > gridDelegate, itemBuilder like ListViewBuilder , itemCount

      gridDelegate - > how the grid will be structured , aspect ratio of the structure and the spacing between each column and space between rows

      */
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(
              showFavs: _showOnlyFav,
            ),
    );
  }
}
