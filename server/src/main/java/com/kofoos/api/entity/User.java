package com.kofoos.api.entity;
import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private int id;

    @Column(unique = true)
    private String deviceId;

    @Column(name = "language")
    private String language;

    @OneToMany(mappedBy = "user",cascade = CascadeType.REMOVE)
    private List<WishlistFolder> wishlistFolders = new ArrayList<>();

    @OneToMany(mappedBy = "user")
    private List<History> histories = new ArrayList<>();

    @OneToMany(mappedBy = "user", cascade = CascadeType.REMOVE)
    private List<UserDislikesMaterial> userDislikesMaterials = new ArrayList<>();

    @Builder
    public User(String deviceId, String language) {
        this.deviceId = deviceId;
        this.language = language;
    }

    public void updateLanguage(String newLanguage) {
        this.language = newLanguage;
    }


}
