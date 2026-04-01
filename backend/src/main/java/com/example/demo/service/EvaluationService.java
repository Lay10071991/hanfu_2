package com.example.demo.service;

import com.example.demo.entity.Evaluation;
import com.example.demo.entity.ShopRating;
import com.example.demo.repository.EvaluationRepository;
import com.example.demo.repository.ShopRatingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class EvaluationService {
    
    @Autowired
    private EvaluationRepository evaluationRepository;
    
    @Autowired
    private ShopRatingRepository shopRatingRepository;
    
    public List<Evaluation> getEvaluationsByShopId(Long shopId) {
        return evaluationRepository.findByShopId(shopId);
    }
    
    public Evaluation createEvaluation(Evaluation evaluation) {
        Evaluation saved = evaluationRepository.save(evaluation);
        updateShopRating(evaluation.getShopId());
        return saved;
    }
    
    private void updateShopRating(Long shopId) {
        List<Evaluation> evaluations = evaluationRepository.findByShopId(shopId);
        
        // 统计各星级评价数量
        int rating5 = 0, rating4 = 0, rating3 = 0, rating2 = 0, rating1 = 0;
        for (Evaluation eval : evaluations) {
            Double ratingDouble = eval.getRating();
            int rating = ratingDouble != null ? ratingDouble.intValue() : 0;
            switch (rating) {
                case 5: rating5++; break;
                case 4: rating4++; break;
                case 3: rating3++; break;
                case 2: rating2++; break;
                case 1: rating1++; break;
            }
        }
        
        // 计算总评价数和平均评分
        int totalCount = rating5 + rating4 + rating3 + rating2 + rating1;
        double averageRating = 0.0;
        if (totalCount > 0) {
            double weightedSum = 5.0 * rating5 + 4.0 * rating4 + 3.0 * rating3 + 2.0 * rating2 + 1.0 * rating1;
            averageRating = Math.round((weightedSum / totalCount) * 10.0) / 10.0;
        }
        
        // 查找或创建评分记录
        ShopRating rating = shopRatingRepository.findByShopId(shopId);
        if (rating == null) {
            rating = new ShopRating();
            rating.setShopId(shopId);
        }
        
        rating.setRating5(rating5);
        rating.setRating4(rating4);
        rating.setRating3(rating3);
        rating.setRating2(rating2);
        rating.setRating1(rating1);
        rating.setReviewCount(totalCount);
        rating.setAverageRating(averageRating);
        
        shopRatingRepository.save(rating);
    }
}
