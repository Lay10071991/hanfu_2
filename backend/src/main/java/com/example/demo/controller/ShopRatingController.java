package com.example.demo.controller;

import com.example.demo.entity.ShopRating;
import com.example.demo.service.ShopRatingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/shop-ratings")
public class ShopRatingController {
    
    @Autowired
    private ShopRatingService shopRatingService;
    
    @GetMapping("/shop/{shopId}")
    public ShopRating getRatingByShopId(@PathVariable Long shopId) {
        return shopRatingService.getRatingByShopId(shopId);
    }
}