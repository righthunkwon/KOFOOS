package com.kofoos.api.entity;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Table(name = "user_dislikes_material")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class UserDislikesMaterial {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_dislikes_material_id")
    private int id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "material_id")
    private DislikedMaterial dislikedMaterial;

    @Builder
    public UserDislikesMaterial(User user, DislikedMaterial dislikedMaterial) {
        setUser(user);
        setDislikedMaterial(dislikedMaterial);
    }

    private void setUser(User user) {
        this.user = user;
        user.getUserDislikesMaterials().add(this);
    }

    private void setDislikedMaterial(DislikedMaterial dislikedMaterial) {
        this.dislikedMaterial = dislikedMaterial;
        dislikedMaterial.getUserDislikesMaterials().add(this);
    }

    public int getMaterialId() {
        return this.dislikedMaterial.getId();
    }


}