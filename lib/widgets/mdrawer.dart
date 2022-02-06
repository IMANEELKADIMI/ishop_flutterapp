import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';

import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:flutter_complete_guide/screens/product_detail_screen.dart';
import 'package:flutter_complete_guide/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
import '../screens/chat_screen.dart';

class MMDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 150,
            width: double.infinity,
            color: Colors.redAccent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Welcome to i-Shop!',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),

          Divider(
            color: Colors.redAccent,
            height: 1,
            thickness: 1,
          ),
          Container(
            color: Theme.of(context).accentColor,
            child: ListTile(
              leading: Icon(
                Icons.payment,
                size: 30,
              ),
              title: Text('MY ORDERS'),
              onTap: () => Navigator.pushNamed(context, OrdersScreen.routeName),
            ),
          ),


          Container(
            color: Theme.of(context).accentColor,
            child: ListTile(
              leading: Icon(
                Icons.exit_to_app,
                size: 30,
              ),
              title: Text('Log Out'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
          ),
        ],
      ),
    );
  }
}

