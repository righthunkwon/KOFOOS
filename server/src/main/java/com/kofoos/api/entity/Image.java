package com.kofoos.api.entity;


import jakarta.annotation.Nullable;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Image {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "image_id")
    private int id;

    @Column(length = 100)
    private String imgUrl;

    @OneToMany(fetch = FetchType.LAZY)
    private List<WishlistItem> wishlistItem = new ArrayList<>();

    @OneToOne(mappedBy = "image",fetch = FetchType.LAZY)
    @Nullable
    private Product product;

    @Builder
    public Image(int id, String imgUrl, WishlistItem wishlistItem){
        this.id = id;
        this.imgUrl = imgUrl;
    }

    public void setWishlistItem(WishlistItem wishlistItem){
        this.wishlistItem.add(wishlistItem);
    }

    public void setProduct(Product product) {
        this.product = product;
    }
}
