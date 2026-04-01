package com.example.demo.service;

import com.example.demo.entity.ShopReview;
import com.example.demo.repository.ShopReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class EvaluationService {
    
    @Autowired
    private ShopReviewRepository shopReviewRepository;
    
    public List<ShopReview> getEvaluationsByShopId(Long shopId) {
        return shopReviewRepository.findByShopId(shopId);
    }
    
    public ShopReview createEvaluation(ShopReview review) {
        return shopReviewRepository.save(review);
    }
}
