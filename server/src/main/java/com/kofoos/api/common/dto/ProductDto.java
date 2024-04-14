package com.kofoos.api.common.dto;

import com.kofoos.api.entity.*;
import lombok.Builder;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Data
@Builder
public class ProductDto {

    private int id;
    private String barcode;
    private String name;
    private String description;
    private ImageDto imageDto;
    private int like;
    private int hit;
    private String convenienceStore;
//    private CategoryDto categoryDto;
//    private WishlistItemDto wishlistItemDto;
//    private List<ProductMaterialDto> productMaterialDtos;
//    private List<EditorProductsListDto> editorProductsListDtos;



        public static ProductDto of (Product product){

            List<ProductMaterialDto> productMaterialDtos = new ArrayList<>();
            List<EditorProductsListDto> editorProductsListDtos = new ArrayList<>();

            for (ProductMaterial productMaterial : product.getProductMaterials()) {
                productMaterialDtos.add(ProductMaterialDto.of(productMaterial));
            }

            for (EditorProductsList editorProductsList : product.getEditorProductsLists()) {
                editorProductsListDtos.add(EditorProductsListDto.of(editorProductsList));
            }


            return ProductDto.builder()
                    .barcode(product.getBarcode())
                    .name(product.getName())
                    .imageDto(ImageDto.of(product.getImage()))
                    .like(product.getLike())
                    .hit(product.getHit())
                    .convenienceStore(product.getConvenienceStore())
//                    .productMaterialDtos(productMaterialDtos)
//                    .editorProductsListDtos(editorProductsListDtos)
                    .build();

    }

}


