package com.example.demo.controller;

import com.example.demo.entity.ShopShow;
import com.example.demo.service.ShopShowService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@RestController
@RequestMapping("/api/shop-shows")
public class ShopShowController {
    
    private static final Logger logger = LoggerFactory.getLogger(ShopShowController.class);
    
    @Autowired
    private ShopShowService shopShowService;
    
    @GetMapping("/shop/{shopId}")
    public ResponseEntity<List<ShopShow>> getShopShowsByShopId(@PathVariable Long shopId) {
        logger.info("获取店铺{}的展示图片", shopId);
        List<ShopShow> shopShows = shopShowService.getShopShowsByShopId(shopId);
        logger.info("店铺{}找到{}张展示图片", shopId, shopShows.size());
        return ResponseEntity.ok(shopShows);
    }
    
    @GetMapping("/shop/{shopId}/images")
    public ResponseEntity<List<String>> getImageUrlsByShopId(@PathVariable Long shopId) {
        logger.info("获取店铺{}的图片URL列表", shopId);
        List<String> imageUrls = shopShowService.getImageUrlsByShopId(shopId);
        logger.info("店铺{}返回{}张图片URL: {}", shopId, imageUrls.size(), imageUrls);
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
