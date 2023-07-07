import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Cart',
          style: TextStyle(color: Colors.black, fontSize: 17),
        ),
        actions: [
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.white,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                size: 17,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: new Container(
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
                child: ListTile(
              title: new Text("Total:"),
              subtitle: new Text("\$560"),
            )),
            Expanded(
                child: new MaterialButton(
              onPressed: () {},
              child: new Text(
                "Check Out",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.green,
            ))
          ],
        ),
      ),
    );
  }
}
