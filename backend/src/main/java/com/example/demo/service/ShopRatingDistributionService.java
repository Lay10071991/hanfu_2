package com.example.demo.service;

import com.example.demo.entity.ShopRatingDistribution;
import com.example.demo.repository.ShopRatingDistributionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ShopRatingDistributionService {
    
    @Autowired
    private ShopRatingDistributionRepository shopRatingDistributionRepository;
    
    public ShopRatingDistribution getRatingDistributionByShopId(Long shopId) {
        return shopRatingDistributionRepository.findByShopId(shopId);
    }
    
    public ShopRatingDistribution saveRatingDistribution(ShopRatingDistribution distribution) {
        return shopRatingDistributionRepository.save(distribution);
    }
    
    public void deleteRatingDistribution(Long id) {
        shopRatingDistributionRepository.deleteById(id);
    }
    
    public void deleteRatingDistributionByShopId(Long shopId) {
        ShopRatingDistribution distribution = shopRatingDistributionRepository.findByShopId(shopId);
        if (distribution != null) {
            shopRatingDistributionRepository.delete(distribution);
        }
    }
}
