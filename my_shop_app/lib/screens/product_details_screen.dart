import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

// ignore: use_key_in_widget_constructors
class ProductDetailScreen extends StatelessWidget {
  static const String routeName = "/product_detail_screen";

  @override
  Widget build(BuildContext context) {
//////+++++++++++++++++++++++++++++++++++++++++//////

    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

//////+++++++++++++++++++++++++++++++++++++++++//////

// when you don't want to rebuild the widget if notify listeners is called then you will pass another argument with the context i.e listen : false
    final productsData = Provider.of<Products>(context, listen: false);
    final loadedProduct = productsData.findProductById(routeArgs['id']!);

//////+++++++++++++++++++++++++++++++++++++++++//////

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            automaticallyImplyLeading: true,
            centerTitle: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                loadedProduct.title,
                textAlign: TextAlign.start,
                style: const TextStyle(color: Colors.red),
              ),
              background: Hero(
                tag: routeArgs['id']!,
                child: FadeInImage(
                  fadeInCurve: Curves.easeIn,
                  placeholder: const AssetImage(
                      'lib/assets/images/product-placeholder.png'),
                  image: NetworkImage(
                    loadedProduct.imageUrl,
                  ),
                  height: 400,
                  width: 400,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 20,
                ),
                Chip(
                  label: Text('\$ ${loadedProduct.price.toStringAsFixed(2)}'),
                ),
                // Chip(
                //   label: Text(loadedProduct.id),
                // ),
                Padding(padding: EdgeInsets.all(10)),
                SizedBox(
                  height: 100,
                  width: 300,
                  child: Card(
                    child: Text(
                      loadedProduct.description,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 800,
                  child: Text(
                    'Try Scrolling Upwards.👆',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

//////+++++++++++++++++++++++++++++++++++++++++//////
}
