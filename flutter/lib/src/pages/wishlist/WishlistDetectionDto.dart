class WishlistDetectionDto {
  String? itemNo;
  double score;
  String imageUrl;

  WishlistDetectionDto({required this.itemNo, required this.score,required this.imageUrl});

  @override
  String toString() {
    return 'itemNo: $itemNo, imageUrl: $imageUrl, score: $score';
  }


}
