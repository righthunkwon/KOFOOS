package com.kofoos.api.product.dto;

import com.kofoos.api.entity.Product;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ProductBoxDto implements Comparable<ProductBoxDto>{

    private String barcode;
    private String name;
    private String itemNo;
    private String imgurl;
    private int productId;
    private int hit;

    public static ProductBoxDto of(Product product) {

        return ProductBoxDto.builder()
                .barcode(product.getBarcode())
                .name(product.getName())
                .itemNo(product.getItemNo())
                .productId(product.getId())
                .hit(product.getHit())
                .imgurl(product.getImage() != null ? product.getImage().getImgUrl()+"?width=200&height=200" : "hoho")
                .build();

    }

    @Override
    public int compareTo(ProductBoxDto o) {
        return Integer.compare(o.hit,this.hit);
    }
}
