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
        return shopReviewRepository.save(review);
    }
    
    // 删除评价
    public void deleteReview(Long id) {
        shopReviewRepository.deleteById(id);
    }
}
