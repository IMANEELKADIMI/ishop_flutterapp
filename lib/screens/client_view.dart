import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/mainappbar.dart';
import 'package:provider/provider.dart';

import '../widgets/drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import './cart_screen.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

enum ItemsFilter { FAVORITE, ALL }

class ClientviewScreen extends StatefulWidget {
  @override
  _ClientviewScreenState createState() => _ClientviewScreenState();
}

class _ClientviewScreenState extends State<ClientviewScreen> {
  bool isFavorite = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    //in initState all .of(context) do not work, EXCEPT for Provider if listen:false

    //THIS WORKS as long as listen:false
    //Provider.of<Products>(context,listen: false).fetchAndSetProducts();

    //THIS HACK ALSO WORKS and for all .of(context) methods
    // Future.delayed(Duration.zero).then((_) =>
    //     Provider.of<Products>(context).fetchAndSetProducts());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    //this also works but it is less optimal because it runs after the widget is set which gives us
    //access to context but before build runs
    //it is less optimal than initState because it runs multiple times unlike InitState which only runs
    //one time
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
      drawer: MDrawer(),
      appBar: AppBar(
        shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        actions: [
          Consumer<Cart>(
            //this is ch that will be passed to builder
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {

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
        title: Text("i-SHOP"),
      ),
      body: Container(
    decoration: BoxDecoration(
    image: DecorationImage(
    image: AssetImage('assets/images/productsOverviewScreen.png'),
    fit: BoxFit.fill,
    ),
    ),
      ),
    );
  }
}
