package com.example.demo.controller;

import com.example.demo.entity.ShopImage;
import com.example.demo.service.ShopImageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/shop-images")
public class ShopImageController {
    
    @Autowired
    private ShopImageService shopImageService;
    
    @GetMapping("/shop/{shopId}")
    public ResponseEntity<List<ShopImage>> getImagesByShopId(@PathVariable Long shopId) {
        List<ShopImage> images = shopImageService.getImagesByShopId(shopId);
        return ResponseEntity.ok(images);
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<ShopImage> getImageById(@PathVariable Long id) {
        ShopImage image = shopImageService.getImageById(id);
        if (image == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(image);
    }
    
    @PostMapping
    public ResponseEntity<ShopImage> createImage(@RequestBody ShopImage image) {
        ShopImage created = shopImageService.saveImage(image);
        return ResponseEntity.ok(created);
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<ShopImage> updateImage(@PathVariable Long id, @RequestBody ShopImage image) {
        ShopImage existing = shopImageService.getImageById(id);
        if (existing == null) {
            return ResponseEntity.notFound().build();
        }
        image.setId(id);
        ShopImage updated = shopImageService.saveImage(image);
        return ResponseEntity.ok(updated);
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteImage(@PathVariable Long id) {
        shopImageService.deleteImage(id);
        return ResponseEntity.noContent().build();
    }
}