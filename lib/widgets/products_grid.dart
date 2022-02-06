import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import 'product_item.dart';
import '../providers/product.dart';

class ProductsGrid extends StatelessWidget {

  final bool isFavorite;

  ProductsGrid(this.isFavorite);

  @override
  Widget build(BuildContext context) {
    //fetch data from the provider class
    final productsData = Provider.of<Products>(context);
    List<Product> products;
    if(isFavorite){
      products = productsData.filteredItems;
    } 
    else
    {
      products = productsData.items;
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: products[index],
        //create: (context) => products[index],
        child:
            //we no longer need to pass data using the constructor we can get the Product from the provider
            ProductItem(

                ),
      ),
    );
  }
}
