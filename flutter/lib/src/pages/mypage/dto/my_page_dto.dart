// my_page_dto.dart 수정

import 'ProductDto.dart';

class MyPageDto {
  final String language;
  final List<int> dislikedMaterials;
  final List<ProductDto> products; // ProductDto의 리스트로 변경

  MyPageDto({
    required this.language,
    required this.dislikedMaterials,
    required this.products,
  });

  factory MyPageDto.fromJson(Map<String, dynamic> json) {
    var productList = json['products'] as List; // JSON에서 'products' 키로 제품 리스트를 가져옴
    List<ProductDto> productDtoList = productList
        .map((productJson) => ProductDto.fromJson(productJson))
        .toList(); // JSON 리스트를 ProductDto 리스트로 변환

    return MyPageDto(
      language: json['language'],
      dislikedMaterials: List<int>.from(json['dislikedMaterials']),
      products: productDtoList,
    );
  }
}