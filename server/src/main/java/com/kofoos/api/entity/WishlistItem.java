package com.kofoos.api.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;


@Entity
@Getter
@Table(name = "wishlist_item")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class WishlistItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "wishlist_item_id")
    private int id;

    private Integer bought;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id")
    private Product product;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "image_id")
    private Image image;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "wishlist_folder_id")
    private WishlistFolder wishlistFolder;

    @Builder
    public WishlistItem(Integer bought,Image image, Product product, WishlistFolder wishlistFolder) {
        this.bought = bought;
        setProduct(product);
        setImage(image);
        setWishlistFolder(wishlistFolder);
    }

    private void setProduct(Product product) {
        this.product = product;
        if(product!=null)
            product.getWishlistItems().add(this);
    }

    private void setImage(Image image){
        this.image = (image);
//        image.setWishlistItem(this);
    }


    private void setWishlistFolder(WishlistFolder wishlistFolder) {
        this.wishlistFolder = wishlistFolder;
        wishlistFolder.getWishlistitems().add(this);
    }

    public void updatebought(int bought){
        this.bought = bought;
    }

}