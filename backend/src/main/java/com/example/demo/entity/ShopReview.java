package com.example.demo.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "shop_review")
public class ShopReview {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private Long shopId;
    private Long userId;
    private Double rating;
    
    @Column(columnDefinition = "TEXT")
    private String content;
    
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    private Double averageRating;
    private Integer rating5;
    private Integer rating4;
    private Integer rating3;
    private Integer rating2;
    private Integer rating1;
    private Integer reviewCount;
    
    @PrePersist
    protected void onCreate() {
        createTime = LocalDateTime.now();
        updateTime = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updateTime = LocalDateTime.now();
    }
    
    // Getters and Setters
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
    
    public Long getUserId() {
        return userId;
    }
    
    public void setUserId(Long userId) {
        this.userId = userId;
    }
    
    public Double getRating() {
        return rating;
    }
    
    public void setRating(Double rating) {
        this.rating = rating;
    }
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
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
}
