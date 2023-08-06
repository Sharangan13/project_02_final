import 'Product.dart';

class CartItem {
  final Product product;
  final int quantity;

  CartItem({required this.product, required this.quantity});
}

class Cart {
  static List<CartItem> items = [];

  static void addToCart(Product product, int quantity) {
    final existingItemIndex =
    items.indexWhere((item) => item.product.productId == product.productId);

    if (existingItemIndex != -1) {
      // If the product is already in the cart, update the quantity
      items[existingItemIndex] =
          CartItem(product: product, quantity: quantity);
    } else {
      // If the product is not in the cart, add it as a new item
      items.add(CartItem(product: product, quantity: quantity));
    }
  }

  static void removeItem(Product product) {
    items.removeWhere((cartItem) => cartItem.product == product);
  }


  static double getTotalAmount() {
    double total = 0;
    for (var item in items) {
      total += item.product.price * item.quantity;
    }
    return total;
  }
}
