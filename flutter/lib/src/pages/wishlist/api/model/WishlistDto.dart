import 'dart:convert';

class WishlistDto {
  final int wishlistItemId;
  final int bought;
  final String? itemNo;
  final String imageUrl;

  WishlistDto({required this.wishlistItemId ,required this.bought, required this.itemNo, required this.imageUrl});

  factory WishlistDto.fromJson(Map<String, dynamic> json) {
    return WishlistDto(
      wishlistItemId: json['wishlistItemId'],
      bought: json['bought'],
      itemNo: json['itemNo'],
      imageUrl: json['imageUrl'],
    );
  }
  @override
  String toString() {
    return 'wishlistItemId $wishlistItemId,bought: $bought, itemNo: $itemNo, imageUrl: $imageUrl';
  }

}
