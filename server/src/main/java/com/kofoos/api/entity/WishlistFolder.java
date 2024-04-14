package com.kofoos.api.entity;
import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Table(name = "wishlist_folder")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class WishlistFolder {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "wishlist_folder_id")
    private int id;

    @Column(name = "name")
    private String name;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @OneToMany(mappedBy = "wishlistFolder",cascade = CascadeType.REMOVE)
    private List<WishlistItem> wishlistitems = new ArrayList<>();


    @Builder
    private WishlistFolder(String name, User user) {
        this.name = name;
        setUser(user);
    }

    private void setUser(User user) {
        this.user = user;
        user.getWishlistFolders().add(this);
    }

    public void updateName(String name){
        this.name = name;
    }

}