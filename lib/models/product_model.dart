class ProductModel {
  final String productName;
  final String productImage;
  final int productPrice;
  final String productId;
  final int productQuantity;


  ProductModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.productQuantity,
  });
}