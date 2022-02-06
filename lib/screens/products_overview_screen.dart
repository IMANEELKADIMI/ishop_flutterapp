import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/main_drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import './cart_screen.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

enum ItemsFilter { FAVORITE, ALL }

class ProductOverviewScreen extends StatefulWidget {

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {

  bool isFavorite = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {

    super.initState();
  }

  @override
  void didChangeDependencies() {

    if (_isInit) //this way we make sure this runs only once
    {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context, listen: false)
          .fetchAndSetProducts()
          .then((_) => setState(() {
                _isLoading = false;
              }));
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        actions: [
          Consumer<Cart>(

            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
            builder: (context, cart, ch) => Badge(
              child: ch,
              value: cart.numProducts.toString(),
            ),
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              setState(() {
                if (value == ItemsFilter.FAVORITE) {
                  isFavorite = true;
                } else {
                  isFavorite = false;
                }
              });
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('Favorite'),
                  value: ItemsFilter.FAVORITE,
                ),
                PopupMenuItem(
                  child: Text('All'),
                  value: ItemsFilter.ALL,
                ),
              ];
            },
          ),
        ],
        title: Text("My Shop"),
      ),
      body: _isLoading ? Center(child:CircularProgressIndicator()) : ProductsGrid(isFavorite),
    );
  }
}
