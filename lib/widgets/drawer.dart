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

class MDrawer extends StatelessWidget {
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
            color: Colors.lightBlueAccent,
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
          Container(
            color: Theme.of(context).accentColor,
            child: ListTile(
              leading: Icon(
                Icons.shop,
                size: 30,
              ),
              title: Text('Start Shopping'),
              onTap: ()  { Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AuthScreen()));
              },
            ),
          ),
          Divider(
            color: Colors.grey,
            height: 1,
            thickness: 1,
          ),
          Divider(
            color: Colors.grey,
            height: 1,
            thickness: 1,
          ),
          Divider(
            color: Colors.grey,
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
          Divider(
            color: Colors.grey,
            height: 1,
            thickness: 1,
          ),

          Divider(
            color: Colors.grey,
            height: 1,
            thickness: 1,
          ),
          Divider(
            color: Colors.grey,
            height: 1,
            thickness: 1,
          ),  Divider(
            color: Colors.grey,
            height: 1,
            thickness: 1,
          ),
          Container(
            color: Theme.of(context).accentColor,
            child: ListTile(
              leading: Icon(
                Icons.manage_accounts,
                size: 30,
              ),
              title: Text('ChatBot'),
              onTap: ()  { Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChatScreen()));
              },
            ),
          ),
          Divider(
            color: Colors.grey,
            height: 1,
            thickness: 1,
          ),
          Divider(
            color: Colors.grey,
            height: 1,
            thickness: 1,
          ),
          Divider(
            color: Colors.grey,
            height: 1,
            thickness: 1,
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

