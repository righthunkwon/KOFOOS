package com.kofoos.api.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Category {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "category_id")
    private int id;

    @Column(length = 45,name = "cat_1")
    private String cat1;

    @Column(length = 45,name = "cat_2")
    private String cat2;

    @Column(length = 45,name = "cat_3")
    private String cat3;

    @Column(length = 45,name = "cat_4")
    private String cat4;

    @OneToMany(mappedBy = "category")
    private List<Product> products = new ArrayList<>();


    @Builder
    public Category(String cat1, String cat2, String cat3, String cat4) {
        this.cat1 = cat1;
        this.cat2 = cat2;
        this.cat3 = cat3;
        this.cat4 = cat4;
    }
}
