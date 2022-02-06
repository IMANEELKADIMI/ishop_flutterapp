import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/main_drawer.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/order_item.dart' as oiWidget;

class OrdersScreen extends StatefulWidget {
  static const String routeName = '/orders_screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = false;



  @override
  void initState() {
    // Future.delayed(Duration.zero).then((_) =>
    //     Provider.of<Orders>(context, listen: false).fetchAndSetOrders());
    //this works as long as listen: false
    _isLoading = true;
    Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<OrderItem> ordersData =
        Provider.of<Orders>(context, listen: true).orders;
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: ordersData.length <= 0? Center(child: Text('You don\'t have any orders'),) :Column(children: [
        Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: ordersData.length,
                    itemBuilder: (context, index) {
                      return oiWidget.OrderItem(
                          index); //send the index only and get the order using provider
                    }))
      ]),
    );
  }
}
