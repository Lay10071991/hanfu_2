package com.example.demo.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "shop_rating")
public class ShopRating {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private Long shopId;
    
    @Column(name = "average_rating")
    private Double averageRating;
    
    @Column(name = "rating_5")
    private Integer rating5;
    
    @Column(name = "rating_4")
    private Integer rating4;
    
    @Column(name = "rating_3")
    private Integer rating3;
    
    @Column(name = "rating_2")
    private Integer rating2;
    
    @Column(name = "rating_1")
    private Integer rating1;
    
    @Column(name = "review_count")
    private Integer reviewCount;
    
    @Column(name = "create_time")
    private LocalDateTime createTime;
    
    @Column(name = "update_time")
    private LocalDateTime updateTime;
    
    @PrePersist
    protected void onCreate() {
        createTime = LocalDateTime.now();
        updateTime = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updateTime = LocalDateTime.now();
    }
    
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Long getShopId() {
        return shopId;
    }
    
    public void setShopId(Long shopId) {
        this.shopId = shopId;
    }
    
    public Double getAverageRating() {
        return averageRating;
    }
    
    public void setAverageRating(Double averageRating) {
        this.averageRating = averageRating;
    }
    
    public Integer getRating5() {
        return rating5;
    }
    
    public void setRating5(Integer rating5) {
        this.rating5 = rating5;
    }
    
    public Integer getRating4() {
        return rating4;
    }
    
    public void setRating4(Integer rating4) {
        this.rating4 = rating4;
    }
    
    public Integer getRating3() {
        return rating3;
    }
    
    public void setRating3(Integer rating3) {
        this.rating3 = rating3;
    }
    
    public Integer getRating2() {
        return rating2;
    }
    
    public void setRating2(Integer rating2) {
        this.rating2 = rating2;
    }
    
    public Integer getRating1() {
        return rating1;
    }
    
    public void setRating1(Integer rating1) {
        this.rating1 = rating1;
    }
    
    public Integer getReviewCount() {
        return reviewCount;
    }
    
    public void setReviewCount(Integer reviewCount) {
        this.reviewCount = reviewCount;
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