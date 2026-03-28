package com.example.demo.service;

import com.example.demo.entity.Evaluation;
import com.example.demo.entity.ShopRatingDistribution;
import com.example.demo.repository.EvaluationRepository;
import com.example.demo.repository.ShopRatingDistributionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class EvaluationService {
    
    @Autowired
    private EvaluationRepository evaluationRepository;
    
    @Autowired
    private ShopRatingDistributionRepository shopRatingDistributionRepository;
    
    public List<Evaluation> getEvaluationsByShopId(Long shopId) {
        return evaluationRepository.findByShopId(shopId);
    }
    
    public Evaluation createEvaluation(Evaluation evaluation) {
        Evaluation saved = evaluationRepository.save(evaluation);
        updateShopRatingDistribution(evaluation.getShopId());
        return saved;
    }
    
    private void updateShopRatingDistribution(Long shopId) {
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
        
        // 查找或创建评分分布记录
        ShopRatingDistribution distribution = shopRatingDistributionRepository.findByShopId(shopId);
        if (distribution == null) {
            distribution = new ShopRatingDistribution();
            distribution.setShopId(shopId);
        }
        
        distribution.setRating5(rating5);
        distribution.setRating4(rating4);
        distribution.setRating3(rating3);
        distribution.setRating2(rating2);
        distribution.setRating1(rating1);
        
        shopRatingDistributionRepository.save(distribution);
    }
}
