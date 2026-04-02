package com.example.demo.service;

import com.example.demo.dto.ShopDTO;
import com.example.demo.entity.Shop;
import com.example.demo.entity.ShopRating;
import com.example.demo.repository.ShopRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ShopService {
    
    @Autowired
    private ShopRepository shopRepository;
    
    @Autowired
    private ShopRatingService shopRatingService;
    
    public List<ShopDTO> getAllShops() {
        List<Shop> shops = shopRepository.findAll();
        return shops.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    public List<ShopDTO> getShopsByUserId(Long userId) {
        List<Shop> shops = shopRepository.findByUserId(userId);
        return shops.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    public ShopDTO getShopById(Long id) {
        Shop shop = shopRepository.findById(id).orElse(null);
        if (shop != null) {
            return convertToDTO(shop);
        }
        return null;
    }
    
    private ShopDTO convertToDTO(Shop shop) {
        ShopDTO dto = new ShopDTO();
        dto.setId(shop.getId());
        dto.setName(shop.getName());
        dto.setDescription(shop.getDescription());
        dto.setImage(shop.getImage());
        dto.setAddress(shop.getAddress());
        dto.setContact(shop.getContact());
        dto.setPriceRange(shop.getPriceRange());
        dto.setUserId(shop.getUserId());
        dto.setCreateTime(shop.getCreateTime());
        dto.setUpdateTime(shop.getUpdateTime());
        
        // 从评分表获取评分数据
        ShopRating rating = shopRatingService.getRatingByShopId(shop.getId());
        if (rating != null) {
            dto.setAverageRating(rating.getAverageRating());
            dto.setReviewCount(rating.getReviewCount());
        } else {
            dto.setAverageRating(0.0);
            dto.setReviewCount(0);
        }
        
        return dto;
    }
    
    public Shop createShop(Shop shop) {
        return shopRepository.save(shop);
    }
    
    public Shop updateShop(Long id, Shop shopDetails) {
        Shop shop = shopRepository.findById(id).orElse(null);
        if (shop != null) {
            shop.setName(shopDetails.getName());
            shop.setDescription(shopDetails.getDescription());
            shop.setImage(shopDetails.getImage());
            shop.setAddress(shopDetails.getAddress());
            shop.setContact(shopDetails.getContact());
            shop.setPriceRange(shopDetails.getPriceRange());
            shop.setUserId(shopDetails.getUserId());
            return shopRepository.save(shop);
        }
        return null;
    }
    
    public void deleteShop(Long id) {
        shopRepository.deleteById(id);
    }
}
