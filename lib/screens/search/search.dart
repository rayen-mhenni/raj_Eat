import 'package:flutter/material.dart';
import 'package:raj_eat/widgets/product_unit.dart';
import 'package:raj_eat/widgets/single_item.dart';
import '../../models/product_model.dart';

class Search extends StatefulWidget {
  final List<ProductModel> search;

  Search({this.search = const []});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String query = '';

   searchItem(String query) {
    List<ProductModel> searchFood = widget.search.where((element) {
      return element.productName.toLowerCase().contains(query);
    }).toList();

    return searchFood;
  }

  @override
  Widget build(BuildContext context) {
    List<ProductModel>_searchItem =searchItem(query);
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
        actions: [
          IconButton(
            onPressed: () {
              // Handle sort action
            },
            icon: Icon(Icons.sort),
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Items"),
          ),
          Container(
            height: 52,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged: (value) {

                setState(() {
                  query = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                fillColor: Color(0xffc2c2c2),
                filled: true,
                hintText: "Search for items in the store",
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: _searchItem.map((data) {
              return SingleItem(
                isBool: false,
                productImage: data.productImage,
                productName: data.productName,
                productPrice: data.productPrice,
                productId: data.productId,
                productQuantity: 0,
                productUnit: ProductUnit(),
                onDelete: () {},

              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
