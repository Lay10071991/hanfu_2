package com.example.demo.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

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

    @Column(name = "create_time", nullable = false, columnDefinition = "datetime default current_timestamp")
    private LocalDateTime createTime;

    @Column(name = "update_time", nullable = false, columnDefinition = "datetime default current_timestamp on update current_timestamp")
    private LocalDateTime updateTime;

    // Getters and Setters
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

    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }

    public LocalDateTime getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(LocalDateTime updateTime) {
        this.updateTime = updateTime;
    }
}
