package com.kofoos.api.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "product_id")
    private int id;


    @Column(length = 45)
    private String  barcode;

    @Column(length = 255)
    private String  name;

    @Column(length = 600)
    private String  description;


    @Column(name = "tag_string")
    private String tagString;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "image_id")
    private Image image;

    @Column(name = "wish")
    private Integer like;

    @Column(name = "hit")
    private Integer hit;


    @Column(name = "item_no",length = 10)
    private String itemNo;

    @Column(length = 10)
    private String convenienceStore;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private Category category;


    @OneToMany(mappedBy = "product",fetch = FetchType.LAZY)
    private List<WishlistItem> wishlistItems = new ArrayList<>();

    @OneToMany(mappedBy = "product",fetch = FetchType.LAZY)
    private List<History> history = new ArrayList<>();

    @OneToMany(mappedBy = "product",fetch = FetchType.LAZY)
    private List<ProductMaterial> productMaterials = new ArrayList<>();

    @OneToMany(mappedBy = "product",fetch = FetchType.LAZY)
    private List<EditorProductsList> editorProductsLists = new ArrayList<>();

    @Builder
    public Product(int id, String barcode, String name, String itemNo, String tagString, String description, Image image,  int like, int hit, String convenienceStore, Category category) {
        this.id = id;
        this.barcode = barcode;
        this.itemNo = itemNo;
        this.name = name;
        this.tagString = tagString;
        this.description = description;
        setImage(image);
        this.like = like;
        this.hit = hit;
        this.itemNo = itemNo;
        this.convenienceStore = convenienceStore;
        setCategory(category);
    }

    public void setCategory(Category category) {
        this.category = category;
        category.getProducts().add(this);
    }


    public void setImage(Image image){
        this.image = image;
        image.setProduct(this);
    }


//    public void setWishlistItem(WishlistItem wishlistItem){
//        this.wishlistItem = wishlistItem;
//    }

    public void addLike(){
        this.like += 1;
    }
    public void subLike(){
        this.like -= 1;
    }

    public void addHit(){
        this.hit += 1;
    }


}
