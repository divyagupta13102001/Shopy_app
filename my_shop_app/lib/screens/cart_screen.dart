import 'package:flutter/material.dart';
import '../providers/orders.dart';
import '../widgets/cart_item_tile.dart';
import '../providers/cart.dart';
import 'package:provider/provider.dart';

// ignore: use_key_in_widget_constructors
class CartScreen extends StatelessWidget {
  static const String routeName = "/cart_screen";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    //final orderProvider = Provider.of<Orders>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text("\$ ${cart.totalAmount.toStringAsFixed(2)}"),
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                final cartItemValuesList = cart.items.values.toList();
                return CartTile(
                  id: cartItemValuesList[index].id,
                  productId: cart.items.keys.toList()[index],
                  title: cartItemValuesList[index].title,
                  price: cartItemValuesList[index].price,
                  quantity: cartItemValuesList[index].quantity,
                );
              },
              itemCount: cart.size,
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final Cart cart;
  // ignore: use_key_in_widget_constructors
  const OrderButton({required this.cart});

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<Orders>(context, listen: false);
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : TextButton(
            onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await orderProvider.addOrders(
                      widget.cart.items.values.toList(),
                      widget.cart.totalAmount,
                    );
                    setState(() {
                      _isLoading = false;
                    });
                    widget.cart.clearCart();
                  },
            child: const Text("Order now"),
          );
  }
}
