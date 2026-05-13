package com.example.demo.service;

import com.example.demo.entity.ShopReview;
import com.example.demo.repository.ShopReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class ShopReviewService {
    
    @Autowired
    private ShopReviewRepository shopReviewRepository;
    
    // 根据用户ID获取评价
    public List<ShopReview> getReviewsByUserId(Long userId) {
        return shopReviewRepository.findByUserId(userId);
    }
    
    // 根据店铺ID获取评价
    public List<ShopReview> getReviewsByShopId(Long shopId) {
        return shopReviewRepository.findByShopId(shopId);
    }
    
    // 创建新评价
    public ShopReview createReview(ShopReview review) {
        // 设置默认值，避免NOT NULL约束错误
        if (review.getAverageRating() == null) {
            review.setAverageRating(0.0);
        }
        if (review.getRating1() == null) {
            review.setRating1(0);
        }
        if (review.getRating2() == null) {
            review.setRating2(0);
        }
        if (review.getRating3() == null) {
            review.setRating3(0);
        }
        if (review.getRating4() == null) {
            review.setRating4(0);
        }
        if (review.getRating5() == null) {
            review.setRating5(0);
        }
        if (review.getReviewCount() == null) {
            review.setReviewCount(0);
        }
        return shopReviewRepository.save(review);
    }
    
    // 删除评价
    public void deleteReview(Long id) {
        shopReviewRepository.deleteById(id);
    }
}
