import 'dart:convert';

import 'package:ecommerce_app/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List categories=[];
  bool temp=false;
  GetCategories() async {
    var url = Uri.parse('https://dummyjson.com/products/categories');
    var response = await http.get(url);
    temp=true;
    categories=jsonDecode(response.body);
    setState(() {

    });
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetCategories();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("E-Commerce App")),
      body: (temp)?ListView.builder(itemCount: categories.length,
        itemBuilder: (context, index) {
          return InkWell(onTap: (){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
              return Products(categories[index]);
            },), (route) => true);

          },child: Card(child: ListTile(title: Text("${categories[index]}"),)));
        },
      ):Center(child: CircularProgressIndicator()),
    );
  }
}
