package com.example.demo.service;

import com.example.demo.entity.ShopImage;
import com.example.demo.repository.ShopImageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ShopImageService {
    
    @Autowired
    private ShopImageRepository shopImageRepository;
    
    public List<ShopImage> getImagesByShopId(Long shopId) {
        return shopImageRepository.findByShopIdOrderBySortOrderAsc(shopId);
    }
    
    public ShopImage getImageById(Long id) {
        return shopImageRepository.findById(id).orElse(null);
    }
    
    public ShopImage saveImage(ShopImage image) {
        return shopImageRepository.save(image);
    }
    
    public void deleteImage(Long id) {
        shopImageRepository.deleteById(id);
    }
    
    @Transactional
    public void deleteImagesByShopId(Long shopId) {
        shopImageRepository.deleteByShopId(shopId);
    }
}