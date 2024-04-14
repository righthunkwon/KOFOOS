import 'WishlistDto.dart';

class FolderDto {
  final int folderId;
  final String folderName;
  final List<WishlistDto> items;

  FolderDto({required this.folderId, required this.folderName, required this.items});

  factory FolderDto.fromJson(Map<String, dynamic> json) {
    var itemsFromJson = json['items'] as List? ?? [];
    List<WishlistDto> itemsList = itemsFromJson.map((item) => WishlistDto.fromJson(item)).toList();

    return FolderDto(
      folderId: json['folderId'],
      folderName: json['folderName'],
      items: itemsList,
    );
  }

  @override
  String toString() {
    return 'folderId: $folderId, folderName: $folderName, items: $items';
  }
}
