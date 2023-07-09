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
      "price": "80",
      "quantity": "10",
    },
    {
      "name": "MoneyPlant",
      "picture": "assets/images/g1.png",
      "price": "80",
      "quantity": "10",
    },
    {
      "name": "MoneyPlant",
      "picture": "assets/images/g1.png",
      "price": "80",
      "quantity": "10",
    },
    {
      "name": "MoneyPlant",
      "picture": "assets/images/g1.png",
      "price": "80",
      "quantity": "10",
    },
    {
      "name": "MoneyPlant",
      "picture": "assets/images/g1.png",
      "price": "80",
      "quantity": "10",
    },
    {
      "name": "MoneyPlant",
      "picture": "assets/images/g1.png",
      "price": "80",
      "quantity": "10",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: product_List.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (BuildContext context, int index) {
        return SingleProduct(
          productName: product_List[index]['name'],
          productPicture: product_List[index]['picture'],
          productPrice: product_List[index]['price'],
          productQuantity: product_List[index]['quantity'],
        );
      },
    );
  }
}

class SingleProduct extends StatelessWidget {
  final productName;
  final productPicture;
  final productPrice;
  final productQuantity;

  SingleProduct({
    this.productName,
    this.productPicture,
    this.productPrice,
    this.productQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProductDetails(
                productDetailName: productName,
                productDetailPrice: productPrice,
                productDetailQuantity: productQuantity,
                productDetailPicture: productPicture,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(8.0),
                  ),
                  image: DecorationImage(
                    image: AssetImage(productPicture),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    "Rs$productPrice",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    "Quantity: $productQuantity",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
