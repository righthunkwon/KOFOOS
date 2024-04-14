// product_dto.dart

class ProductDto {
  final String productUrl;
  final String productItemNo;

  ProductDto({
    required this.productUrl,
    required this.productItemNo,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      productUrl: json['productUrl'],
      productItemNo: json['productItemNo'],
    );
  }
}