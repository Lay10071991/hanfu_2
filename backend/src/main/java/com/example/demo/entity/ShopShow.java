package com.example.demo.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "shop_show")
public class ShopShow {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "shop_id", nullable = false)
    private Long shopId;
    
    @Column(name = "image_url", nullable = false)
    private String imageUrl;
    
    @Column(name = "sort_order", nullable = false)
    private Integer sortOrder;
    
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
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public Integer getSortOrder() {
        return sortOrder;
    }
    
    public void setSortOrder(Integer sortOrder) {
        this.sortOrder = sortOrder;
    }
}
