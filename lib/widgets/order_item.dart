import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as OP; //Orders Provider

class OrderItem extends StatefulWidget {
  @required
  final orderIndex;

  OrderItem(this.orderIndex);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    List<OP.OrderItem> orders = Provider.of<OP.Orders>(context).orders;
    return orders[widget.orderIndex].isOrderEmpty()
        ? Container(
            width: 0.0,
            height: 0.0) //empty invisible container that takes as less space as possible

        : AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: _isExpanded? min(orders[widget.orderIndex].items.length * 20.0 + 110 ,200) : 95,
            child: Card(
              margin: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text('\$${orders[widget.orderIndex].total}'),
                    subtitle: Text(
                      DateFormat('dd/MM/yyyy hh:mm')
                          .format(orders[widget.orderIndex].orderDate),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                          _isExpanded ? Icons.expand_less : Icons.expand_more),
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                    ),
                  ),
                  //if (_isExpanded)
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                      height: _isExpanded? min(orders[widget.orderIndex].items.length * 20.0 + 10 ,100) : 0,
                      child: ListView(
                        children: orders[widget.orderIndex]
                            .items
                            .map(
                              (prod) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    prod.title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${prod.quantity}x \$${prod.price}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    )
                ],
              ),
            ),
          );
  }
}
