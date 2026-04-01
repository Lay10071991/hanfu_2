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
    
    public List<ShopReview> getEvaluationsByUserId(Long userId) {
        return shopReviewRepository.findByUserId(userId);
    }
    
    public ShopReview createEvaluation(ShopReview review) {
        // 先设置评分统计字段的初始值
        review.setAverageRating(0.0);
        review.setRating1(0);
        review.setRating2(0);
        review.setRating3(0);
        review.setRating4(0);
        review.setRating5(0);
        review.setReviewCount(0);
        
        // 保存当前评价
        ShopReview savedReview = shopReviewRepository.save(review);
        
        // 计算并更新评分统计数据
        updateShopRatingStats(review.getShopId());
        
        return savedReview;
    }
    
    public void deleteEvaluation(Long id) {
        ShopReview review = shopReviewRepository.findById(id).orElse(null);
        if (review != null) {
            Long shopId = review.getShopId();
            shopReviewRepository.deleteById(id);
            // 重新计算并更新评分统计数据
            updateShopRatingStats(shopId);
        }
    }
    
    private void updateShopRatingStats(Long shopId) {
        // 获取该店铺的所有评价
        List<ShopReview> reviews = shopReviewRepository.findByShopId(shopId);
        
        // 统计各星级评价数量
        int rating5 = 0, rating4 = 0, rating3 = 0, rating2 = 0, rating1 = 0;
        for (ShopReview review : reviews) {
            Double rating = review.getRating();
            if (rating != null) {
                int ratingInt = rating.intValue();
                switch (ratingInt) {
                    case 5: rating5++; break;
                    case 4: rating4++; break;
                    case 3: rating3++; break;
                    case 2: rating2++; break;
                    case 1: rating1++; break;
                }
            }
        }
        
        // 计算总评价数和平均评分
        int totalCount = rating5 + rating4 + rating3 + rating2 + rating1;
        double averageRating = 0.0;
        if (totalCount > 0) {
            double weightedSum = 5.0 * rating5 + 4.0 * rating4 + 3.0 * rating3 + 2.0 * rating2 + 1.0 * rating1;
            averageRating = Math.round((weightedSum / totalCount) * 10.0) / 10.0;
        }
        
        // 更新所有评价的评分统计字段
        for (ShopReview review : reviews) {
            review.setAverageRating(averageRating);
            review.setRating5(rating5);
            review.setRating4(rating4);
            review.setRating3(rating3);
            review.setRating2(rating2);
            review.setRating1(rating1);
            review.setReviewCount(totalCount);
            shopReviewRepository.save(review);
        }
    }
}
