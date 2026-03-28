package com.example.demo.service;

import com.example.demo.dto.ShopDTO;
import com.example.demo.entity.Shop;
import com.example.demo.entity.ShopRatingDistribution;
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
    private ShopRatingDistributionService shopRatingDistributionService;
    
    public List<ShopDTO> getAllShops() {
        List<Shop> shops = shopRepository.findAll();
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
        dto.setCreateTime(shop.getCreateTime());
        dto.setUpdateTime(shop.getUpdateTime());
        
        // 从评分分布表获取计算后的评分
        ShopRatingDistribution distribution = shopRatingDistributionService.getRatingDistributionByShopId(shop.getId());
        if (distribution != null) {
            dto.setAverageRating(distribution.getAverageRating());
            dto.setReviewCount(distribution.getTotalCount());
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
            return shopRepository.save(shop);
        }
        return null;
    }
    
    public void deleteShop(Long id) {
        shopRepository.deleteById(id);
    }
}
