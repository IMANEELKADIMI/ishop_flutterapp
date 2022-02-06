import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/product.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = '/product-details';

  @override
  Widget build(BuildContext context) {
    final String productId =
        ModalRoute.of(context).settings.arguments as String;

    final productsData = Provider.of<Products>(context, listen: false);

    final Product loadedProduct = productsData.findById(productId);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(
              tag: productId,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor)),
                height: 300,
                width: double.infinity,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: 10,
            ),
            Text('Price \$${loadedProduct.price}',
                style: TextStyle(
                    fontSize: 20,
                    backgroundColor: Theme.of(context).accentColor),
                    textAlign: TextAlign.center,),
            SizedBox(height: 10),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 50),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Description:',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 1.5)),
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: Text(
                loadedProduct.description,
                softWrap: true,
                style: TextStyle(fontSize: 15),
              ),
            ),
            SizedBox(height:600),
          ])),
        ],
       
      ),
    );
  }
}
