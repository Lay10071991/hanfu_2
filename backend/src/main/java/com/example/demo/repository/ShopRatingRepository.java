package com.example.demo.repository;

import com.example.demo.entity.ShopRating;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ShopRatingRepository extends JpaRepository<ShopRating, Long> {
    ShopRating findByShopId(Long shopId);
}