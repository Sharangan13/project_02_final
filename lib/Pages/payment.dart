import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'constants.dart';

class paymentpage extends StatefulWidget {
  const paymentpage({super.key, required this.title});

  final String title;

  @override
  State<paymentpage> createState() => _paymentState();
}

class _paymentState extends State<paymentpage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PayPal Integration Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => UsePaypal(
                          sandboxMode: true,
                          clientId: "${Constants.clientId}",
                          secretKey: "${Constants.secretKey}",
                          returnURL: "${Constants.returnURL}",
                          cancelURL: "${Constants.cancelURL}",
                          transactions: const [
                            {
                              "amount": {
                                "total": '10.12',
                                "currency": "USD",
                                "details": {
                                  "subtotal": '10.12',
                                  "shipping": '0',
                                  "shipping_discount": 0
                                }
                              },
                              "description":
                                  "The payment transaction description.",
                              // "payment_options": {
                              //   "allowed_payment_method":
                              //       "INSTANT_FUNDING_SOURCE"
                              // },
                              "item_list": {
                                "items": [
                                  {
                                    "name": "A demo product",
                                    "quantity": 1,
                                    "price": '10.12',
                                    "currency": "USD"
                                  }
                                ],

                                // shipping address is not required though
                                "shipping_address": {
                                  "recipient_name": "Jane Foster",
                                  "line1": "Travis County",
                                  "line2": "",
                                  "city": "Austin",
                                  "country_code": "US",
                                  "postal_code": "73301",
                                  "phone": "+00000000",
                                  "state": "Texas"
                                },
                              }
                            }
                          ],
                          note: "Contact us for any questions on your order.",
                          onSuccess: (Map params) async {
                            print("onSuccess: $params");
                          },
                          onError: (error) {
                            print("onError: $error");
                          },
                          onCancel: (params) {
                            print('cancelled: $params');
                          }),
                    ),
                  );
                },
                child: Text('Pay With PayPal'))
          ],
        ),
      ),
    );
  }
}
