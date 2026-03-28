package com.example.demo.controller;

import com.example.demo.entity.ShopRatingDistribution;
import com.example.demo.service.ShopRatingDistributionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/shop-ratings")
public class ShopRatingDistributionController {
    
    @Autowired
    private ShopRatingDistributionService shopRatingDistributionService;
    
    @GetMapping("/shop/{shopId}")
    public ResponseEntity<ShopRatingDistribution> getRatingDistributionByShopId(@PathVariable Long shopId) {
        ShopRatingDistribution distribution = shopRatingDistributionService.getRatingDistributionByShopId(shopId);
        if (distribution == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(distribution);
    }
    
    @PostMapping
    public ResponseEntity<ShopRatingDistribution> createRatingDistribution(@RequestBody ShopRatingDistribution distribution) {
        ShopRatingDistribution created = shopRatingDistributionService.saveRatingDistribution(distribution);
        return ResponseEntity.ok(created);
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<ShopRatingDistribution> updateRatingDistribution(@PathVariable Long id, @RequestBody ShopRatingDistribution distribution) {
        ShopRatingDistribution existing = shopRatingDistributionService.getRatingDistributionByShopId(distribution.getShopId());
        if (existing == null) {
            return ResponseEntity.notFound().build();
        }
        distribution.setId(id);
        ShopRatingDistribution updated = shopRatingDistributionService.saveRatingDistribution(distribution);
        return ResponseEntity.ok(updated);
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteRatingDistribution(@PathVariable Long id) {
        shopRatingDistributionService.deleteRatingDistribution(id);
        return ResponseEntity.noContent().build();
    }
}
