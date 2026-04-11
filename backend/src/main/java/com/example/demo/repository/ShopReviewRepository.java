package com.example.demo.repository;

import com.example.demo.entity.ShopReview;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ShopReviewRepository extends JpaRepository<ShopReview, Long> {
    
    // 根据用户ID查询评价
    List<ShopReview> findByUserId(Long userId);
    
    // 根据店铺ID查询评价
    List<ShopReview> findByShopId(Long shopId);
}
