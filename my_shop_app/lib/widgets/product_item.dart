import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';
import '../screens/product_details_screen.dart';
import '../providers/product.dart';

// ignore: use_key_in_widget_constructors
class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // ProductItem({
  //   required this.id,
  //   required this.title,
  //   required this.imageUrl,
  // });

  @override
  Widget build(BuildContext context) {
    //////+++++++++++++++++++++++++++++++++++++++++//////

    final productData = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetailScreen.routeName, arguments: {
          'id': productData.id,
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          header: GridTileBar(
            backgroundColor: Colors.black45,
            title: Text(
              productData.title,
              textAlign: TextAlign.center,
            ),
          ),
          footer: GridTileBar(
            //////+++++++++++++++++++++++++++++++++++++++++//////

            // Consumer Widget is Special Type of Widget which is directly attached to the provider we don't have to extract the provider instance from the context tee manually
            // both the upper approach and consumer approach is significantly same , the difference arises in the working of them , if we want to rebuild the whole widget i.e. rerun the whole build function again then we use the first approach
            // but if there is only some change in the widget tree after the provider notifies , and you want to change only specific part of your widget then simply use consumer widget.

            //////+++++++++++++++++++++++++++++++++++++++++//////
            leading: Consumer<Product>(
              builder: (
                /* 
                context : 
                all the builder methods returns a context , i.e. it 
                */
                ctx,
                /* 
                providerData :  
                simply = Provider.of<Product>(context) 
                */
                product,
                /* 
                child : 
                it is a part of the consumer which does not changes when the provider data changes then you pass it as an argument , the consumer method will not run it's build method hence saving ime and resources 
                */
                _,
              ) {
                return IconButton(
                  icon: (product.isFavorite)
                      ? const Icon(
                          Icons.favorite,
                        )
                      : const Icon(
                          Icons.favorite_border,
                        ),
                  onPressed: () {
                    product.toggleFavoriteStatus(
                      Provider.of<Auth>(context, listen: false).token!,
                      Provider.of<Auth>(context, listen: false).userId!,
                    );
                  },
                );
              },
            ),
            trailing: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(
                  productId: productData.id,
                  price: productData.price,
                  title: productData.title,
                );
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Item Added to Cart'),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(productData.id);
                      },
                    ),
                  ),
                );
              },
            ),
            title: const Text(
              "",
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.black26,
          ),
          child: Hero(
            tag: productData.id,
            child: FadeInImage(
              placeholder:
                  const AssetImage('lib/assets/images/product-placeholder.png'),
              image: NetworkImage(
                productData.imageUrl,
              ),
              fit: BoxFit.fill,
              alignment: Alignment.centerRight,
            ),
          ),
        ),
      ),
    );

    //builder method ends here
    //////+++++++++++++++++++++++++++++++++++++++++//////
  }
}
