package com.example.demo.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "shop_rating_distribution")
public class ShopRatingDistribution {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private Long shopId;
    
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
    
    private LocalDateTime createTime;
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
    
    // 计算总评价数量
    public Integer getTotalCount() {
        return (rating5 != null ? rating5 : 0) +
               (rating4 != null ? rating4 : 0) +
               (rating3 != null ? rating3 : 0) +
               (rating2 != null ? rating2 : 0) +
               (rating1 != null ? rating1 : 0);
    }
    
    // 计算平均评分
    public Double getAverageRating() {
        Integer totalCount = getTotalCount();
        if (totalCount == 0) {
            return 0.0;
        }
        
        Double weightedSum = 5.0 * (rating5 != null ? rating5 : 0) +
                            4.0 * (rating4 != null ? rating4 : 0) +
                            3.0 * (rating3 != null ? rating3 : 0) +
                            2.0 * (rating2 != null ? rating2 : 0) +
                            1.0 * (rating1 != null ? rating1 : 0);
        
        return Math.round((weightedSum / totalCount) * 10.0) / 10.0;
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
