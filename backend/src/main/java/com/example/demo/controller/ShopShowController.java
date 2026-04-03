package com.example.demo.controller;

import com.example.demo.entity.ShopShow;
import com.example.demo.service.ShopShowService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/shop-shows")
public class ShopShowController {
    
    @Autowired
    private ShopShowService shopShowService;
    
    @GetMapping("/shop/{shopId}")
    public ResponseEntity<List<ShopShow>> getShopShowsByShopId(@PathVariable Long shopId) {
        List<ShopShow> shopShows = shopShowService.getShopShowsByShopId(shopId);
        return ResponseEntity.ok(shopShows);
    }
    
    @GetMapping("/shop/{shopId}/images")
    public ResponseEntity<List<String>> getImageUrlsByShopId(@PathVariable Long shopId) {
        List<String> imageUrls = shopShowService.getImageUrlsByShopId(shopId);
        return ResponseEntity.ok(imageUrls);
    }
    
    @PostMapping
    public ResponseEntity<ShopShow> createShopShow(@RequestBody ShopShow shopShow) {
        ShopShow created = shopShowService.createShopShow(shopShow);
        return ResponseEntity.ok(created);
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteShopShow(@PathVariable Long id) {
        shopShowService.deleteShopShow(id);
        return ResponseEntity.noContent().build();
    }
}
