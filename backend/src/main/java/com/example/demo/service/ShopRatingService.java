package com.example.demo.service;

import com.example.demo.entity.ShopRating;
import com.example.demo.repository.ShopRatingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ShopRatingService {
    
    @Autowired
    private ShopRatingRepository shopRatingRepository;
    
    public ShopRating getRatingByShopId(Long shopId) {
        return shopRatingRepository.findByShopId(shopId);
    }
    
    public ShopRating saveRating(ShopRating rating) {
        return shopRatingRepository.save(rating);
    }
    
    public void deleteRating(Long id) {
        shopRatingRepository.deleteById(id);
    }
}