package com.kofoos.api.entity;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Table(name = "disliked_material_detail")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class DislikedMaterialDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "disliked_material_detail_id")
    private int id;

    @Column(length = 15, name = "detail_name")
    private String detailName;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "disliked_material_id")
    private DislikedMaterial dislikedMaterial;

    @Builder
    public DislikedMaterialDetail(String detailName, DislikedMaterial dislikedMaterial) {
        this.detailName = detailName;
        setDislikedMaterial(dislikedMaterial);
    }

    private void setDislikedMaterial(DislikedMaterial dislikedMaterial){
        this.dislikedMaterial = dislikedMaterial;
        dislikedMaterial.getDislikedMaterialDetailList().add(this);
    }
}