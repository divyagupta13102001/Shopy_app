import 'package:flutter/material.dart';
import 'package:my_shop_app/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class UserProductItemTile extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItemTile({
    super.key,
    required this.id,
    required this.title,
    required this.imageUrl,
  });
  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(children: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                EditProductScreen.routeName,
                arguments: id,
              );
            },
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).primaryColor,
            ),
          ),
          IconButton(
            onPressed: () async {
              try {
                await Provider.of<Products>(context, listen: false)
                    .deleteProduct(id);
              } catch (error) {
                scaffoldMessenger.removeCurrentSnackBar();
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      'Deleting Failed : $error',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
                // print(error);
              }
            },
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).errorColor,
            ),
          ),
        ]),
      ),
    );
  }
}
