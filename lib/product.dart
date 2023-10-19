import 'dart:convert';

import 'package:ecommerce_app/product_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Products extends StatefulWidget {
  String name;
  Products(this.name);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  Map extract = {};
  List products = [];
  bool temp=false;

  GetProducts() async {
    var url = Uri.parse('https://dummyjson.com/products/category/${widget.name}');
    var response = await http.get(url);
    extract = jsonDecode(response.body);
    products = extract['products'];
    setState(() {temp=true;});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetProducts();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
      ),
      body:(temp)? GridView.builder(padding: EdgeInsets.all(5),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
        itemBuilder: (context, index) {
          return InkWell(onTap: () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
              return ProductDetails(products[index]['id']);
            },), (route) => true);
          },
            child: Card(
              child: Container(
                child: Column(children: [
                  Row(
                    children: [
                      Image.network(
                        products[index]['thumbnail'],
                        height: 100,
                        width: 100,
                        fit: BoxFit.fill,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                products[index]['title'],
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "\$${products[index]['price']}",
                        style: TextStyle(fontSize: 25),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          children: [
                            Text(
                              products[index]['rating'].toString(),
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            Icon(
                              Icons.star_rate,
                              color: Colors.yellowAccent,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(children: [
                    SizedBox(width: 5),
                    Text(
                      "${products[index]['discountPercentage']}% off",
                      style: TextStyle(fontSize: 18,color: Colors.green),
                    ),

                  ],),
                  Row(
                    children: [
                      Text("${products[index]['stock']} stocks left",style: TextStyle(fontSize: 18,color: Colors.red),),
                    ],
                  )
                ]),
              ),
            ),
          );

        },
      ):Center(child:
      CircularProgressIndicator()),
    );
  }
}
