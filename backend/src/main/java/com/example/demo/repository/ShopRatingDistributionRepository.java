package com.example.demo.repository;

import com.example.demo.entity.ShopRatingDistribution;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ShopRatingDistributionRepository extends JpaRepository<ShopRatingDistribution, Long> {
    ShopRatingDistribution findByShopId(Long shopId);
}
