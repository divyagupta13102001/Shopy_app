import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavs;
  // ignore: use_key_in_widget_constructors
  const ProductGrid({required this.showFavs});
  @override
  Widget build(BuildContext context) {
    //////+++++++++++++++++++++++++++++++++++++++++//////

    // setting the connection between the provider class and the widget

    final productsData = Provider.of<Products>(context);

    final loadedProducts =
        (showFavs) ? productsData.favoriteItems : productsData.items;

    //////+++++++++++++++++++++++++++++++++++++++++//////

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3 / 5,
      ),

      // will use the custom widget here

      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        //////+++++++++++++++++++++++++++++++++++++++++//////

        // here we used the ChangedNotifier.value() because we don't have to create new Product , they are ALREADY CREATED IN THE PROVIDER package.
        // so we just have to observe them now
        value: loadedProducts[i],

        //////+++++++++++++++++++++++++++++++++++++++++//////
        child: ProductItem(
            // id: loadedProducts[i].id,
            // imageUrl: loadedProducts[i].imageUrl,
            // title: loadedProducts[i].title,
            ),
      ),
      itemCount: loadedProducts.length,
    );
  }
}
