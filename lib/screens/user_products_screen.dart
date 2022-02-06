import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/main_drawer.dart';
import 'package:provider/provider.dart';

import '../widgets/user_product_item.dart';
import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user_products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<Products>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, EditProductScreen.routeName);
              },
              icon: Icon(Icons.add)),
        ],
      ),

      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => _refreshProducts(context),
                child: Consumer<Products>(
                  builder: (ctx, productsData, _) =>
                      productsData.items.length <= 0
                          ? Center(child: Text('You don\'t have any products'))
                          : Padding(
                              padding: EdgeInsets.all(8.0),
                              child: ListView.builder(
                                  itemCount: productsData.items.length,
                                  itemBuilder: (_, index) {
                                    return Column(
                                      children: [
                                        UserProduct(
                                            productsData.items[index].title,
                                            productsData.items[index].imageUrl,
                                            productsData.items[index].id),
                                        Divider(
                                          color: Theme.of(context).primaryColor,
                                          thickness: 1,
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                ),
              ),
      ),
      drawer: MainDrawer(),
    );
  }
}
