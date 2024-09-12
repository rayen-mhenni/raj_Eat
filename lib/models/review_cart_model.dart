class ReviewCartModel {
  final String cartId;
  final String cartImage;
  final String cartName;
  final int cartPrice;
  final int cartQuantity;
  final List<String> selectedOptions;
  var cartUnit ;
  ReviewCartModel({
    required this.cartId,
    required this.cartUnit,
    required this.cartImage,
    required this.cartName,
    required this.cartPrice,
    required this.cartQuantity,
    required this.selectedOptions
  });
}