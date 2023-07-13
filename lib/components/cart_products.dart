import 'package:flutter/material.dart';

class Cart_products extends StatefulWidget {
  const Cart_products({Key? key}) : super(key: key);

  @override
  State<Cart_products> createState() => _Cart_productsState();
}

class _Cart_productsState extends State<Cart_products> {
  var Products_on_the_cart = [
    {
      "name": "MoneyPlant",
      "picture": "assets/images/g1.png",
      "price": "80",
      "quantity": "1",
    },
    {
      "name": "MoneyPlant",
      "picture": "assets/images/g1.png",
      "price": "80",
      "quantity": "1",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: Products_on_the_cart.length,
        itemBuilder: (context, index) {
          return Single_cart_product(
            cart_product_name: Products_on_the_cart[index]["name"],
            cart_prod_qty: Products_on_the_cart[index]["quantity"],
            cart_prod_price: Products_on_the_cart[index]["prize"],
            cart_prod_picture: Products_on_the_cart[index]["picture"],
          );
        });
  }
}

class Single_cart_product extends StatelessWidget {
  final cart_product_name;
  final cart_prod_picture;
  final cart_prod_price;
  final cart_prod_qty;

  Single_cart_product(
      {this.cart_product_name,
      this.cart_prod_picture,
      this.cart_prod_price,
      this.cart_prod_qty});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: new Text(cart_product_name),
        subtitle: Column(
          children: [
            /*new Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text("size:"),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: new Text(cart_prod_size != null
                      ? cart_prod_size
                      : 'default value'),
                ),
              ],
            ),*/
            new Container(
              alignment: Alignment.topLeft,
              child: new Text(cart_prod_price),
            )
          ],
        ),
      ),
    );
  }
}
