package com.example.demo.repository;

import com.example.demo.entity.ShopReview;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ShopReviewRepository extends JpaRepository<ShopReview, Long> {
    List<ShopReview> findByShopId(Long shopId);
    List<ShopReview> findByUserId(Long userId);
}
