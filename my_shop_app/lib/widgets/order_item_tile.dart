import 'dart:math';

import 'package:flutter/material.dart';
import '../providers/orders.dart';
import 'package:intl/intl.dart';

class OrderItemTile extends StatefulWidget {
  final OrderItem order;

  // ignore: use_key_in_widget_constructors
  const OrderItemTile({required this.order});

  @override
  State<OrderItemTile> createState() => _OrderItemTileState();
}

class _OrderItemTileState extends State<OrderItemTile> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$ ${widget.order.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy @ hh:mm a').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(
                (_expanded) ? Icons.expand_more : Icons.expand_less,
              ),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            SizedBox(
              height: min(
                widget.order.products.length * 20 + 100,
                widget.order.products.length * 20 + 180,
              ),
              child: ListView(
                children: widget.order.products.map((prod) {
                  return Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          prod.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${prod.quantity}x \$${prod.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
