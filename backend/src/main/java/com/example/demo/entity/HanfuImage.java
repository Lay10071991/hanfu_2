package com.example.demo.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "hanfu_images")
public class HanfuImage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "hanfu_id", nullable = false)
    private Long hanfuId;

    @Column(name = "image_path", nullable = false, length = 255)
    private String imagePath;

    @Column(name = "sort_order", nullable = false, columnDefinition = "int default 0")
    private Integer sortOrder;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getHanfuId() {
        return hanfuId;
    }

    public void setHanfuId(Long hanfuId) {
        this.hanfuId = hanfuId;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public Integer getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(Integer sortOrder) {
        this.sortOrder = sortOrder;
    }
}
