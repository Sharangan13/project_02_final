import 'package:flutter/material.dart';
import 'package:project_02_final/Pages/product_details.dart';

class Products extends StatefulWidget {
  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  var product_List = [
    {
      "name": "MoneyPlant",
      "picture": "assets/images/g1.png",
      "old_price": "120",
      "price": "80",
    },
    {
      "name": "MoneyPlant",
      "picture": "assets/images/g1.png",
      "old_price": "120",
      "price": "80",
    },
    {
      "name": "MoneyPlant",
      "picture": "assets/images/g1.png",
      "old_price": "120",
      "price": "80",
    },
    {
      "name": "MoneyPlant",
      "picture": "assets/images/g1.png",
      "old_price": "120",
      "price": "80",
    },
    {
      "name": "MoneyPlant",
      "picture": "assets/images/g1.png",
      "old_price": "120",
      "price": "80",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: product_List.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Single_prod(
            product_name: product_List[index]['name'],
            prod_picture: product_List[index]['picture'],
            prod_old_price: product_List[index]['old_price'],
            prod_price: product_List[index]['price'],
          );
        });
  }
}

class Single_prod extends StatelessWidget {
  final product_name;
  final prod_picture;
  final prod_old_price;
  final prod_price;

  Single_prod({
    this.product_name,
    this.prod_picture,
    this.prod_old_price,
    this.prod_price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: product_name,
        child: Material(
          child: InkWell(
            onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new ProductDetails(
                      product_detail_name: product_name,
                      product_details_new_price: prod_price,
                      product_details_old_price: prod_old_price,
                      product_details_picture: prod_picture,
                    ))),
            child: GridTile(
                footer: Container(
                  color: Colors.white70,
                  child: ListTile(
                    leading: Text(
                      product_name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    title: Text(
                      "\$$prod_price",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.w800),
                    ),
                    subtitle: Text(
                      "\$$prod_old_price",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.lineThrough),
                    ),
                  ),
                ),
                child: Image.asset(
                  prod_picture,
                  fit: BoxFit.cover,
                )),
          ),
        ),
      ),
    );
  }
}
