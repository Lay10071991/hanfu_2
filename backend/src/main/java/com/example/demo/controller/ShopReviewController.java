package com.example.demo.controller;

import com.example.demo.entity.ShopReview;
import com.example.demo.service.ShopReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/evaluations")
public class ShopReviewController {
    
    @Autowired
    private ShopReviewService shopReviewService;
    
    // 获取用户的所有评价
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<ShopReview>> getReviewsByUserId(@PathVariable Long userId) {
        List<ShopReview> reviews = shopReviewService.getReviewsByUserId(userId);
        return ResponseEntity.ok(reviews);
    }
    
    // 获取店铺的所有评价
    @GetMapping("/shop/{shopId}")
    public ResponseEntity<List<ShopReview>> getReviewsByShopId(@PathVariable Long shopId) {
        List<ShopReview> reviews = shopReviewService.getReviewsByShopId(shopId);
        return ResponseEntity.ok(reviews);
    }
    
    // 创建新评价
    @PostMapping
    public ResponseEntity<ShopReview> createReview(@RequestBody ShopReview review) {
        ShopReview createdReview = shopReviewService.createReview(review);
        return ResponseEntity.ok(createdReview);
    }
    
    // 删除评价
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteReview(@PathVariable Long id) {
        shopReviewService.deleteReview(id);
        return ResponseEntity.noContent().build();
    }
}
