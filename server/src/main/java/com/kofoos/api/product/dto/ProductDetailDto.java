package com.kofoos.api.product.dto;

import com.kofoos.api.common.dto.CategoryDto;
import com.kofoos.api.common.dto.EditorProductsListDto;
import com.kofoos.api.common.dto.ProductMaterialDto;
import com.kofoos.api.entity.DislikedMaterial;
import com.kofoos.api.entity.Product;
import com.kofoos.api.entity.ProductMaterial;
import lombok.Builder;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

@Data
@Builder
public class ProductDetailDto {

    private String barcode;
    private String name;
    private String description;
    private String itemNo;
    private int hit;
    private int like;
    private String convenienceStore;
    private CategorySearchDto categorySearchDto;
    private List<Integer> dislikedMaterials;
    private String imgurl;
    private String tagString;
    private int productId;
    private List<String> wishList;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ProductDetailDto that = (ProductDetailDto) o;
        return Objects.equals(barcode, that.barcode) &&
                Objects.equals(itemNo, that.itemNo);
    }

    @Override
    public int hashCode() {
        return Objects.hash(barcode, itemNo);
    }

    public static ProductDetailDto of(Product product) {

        List<ProductMaterial> productMaterials = product.getProductMaterials();

        List<Integer> dislikedMaterials = productMaterials.stream()
                .map(material -> material.getDislikedMaterial().getId())
                .collect(Collectors.toList());

        List<String> wishList = product.getWishlistItems().stream()
                .map(wishlistItem -> wishlistItem.getWishlistFolder().getUser().getDeviceId())
                .collect(Collectors.toList());

        return ProductDetailDto.builder()
                .tagString(product.getTagString())
                .barcode(product.getBarcode())
                .name(product.getName())
                .description(product.getDescription())
                .hit(product.getHit())
                .categorySearchDto(CategorySearchDto.of(product.getCategory()))
                .convenienceStore(product.getConvenienceStore())
                .dislikedMaterials(dislikedMaterials)
                .itemNo(product.getItemNo())
                .like(product.getLike())
                .productId(product.getId())
                .wishList(wishList)
                .imgurl(product.getImage() != null ? product.getImage().getImgUrl()+"?width=200&height=200" : "hoho")
                .build();


    }

}
