class ReviewCartModel {
  final String cartId;
  final String cartImage;
  final String cartName;
  final int cartPrice;
  final int cartQuantity;
  var cartUnit ;
  ReviewCartModel({
    required this.cartId,
    required this.cartUnit,
    required this.cartImage,
    required this.cartName,
    required this.cartPrice,
    required this.cartQuantity,
  });
}
