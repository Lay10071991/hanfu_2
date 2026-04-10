package com.example.demo.service;

import com.example.demo.dto.ShopDTO;
import com.example.demo.entity.Shop;
import com.example.demo.entity.ShopShow;
import com.example.demo.entity.ShopReview;
import com.example.demo.repository.ShopRepository;
import com.example.demo.repository.ShopShowRepository;
import com.example.demo.repository.ShopReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ShopService {
    
    @Autowired
    private ShopRepository shopRepository;
    
    @Autowired
    private ShopShowRepository shopShowRepository;
    
    @Autowired
    private ShopReviewRepository shopReviewRepository;
    
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
        
        // 计算实际的平均评分和评论数
        List<ShopReview> reviews = shopReviewRepository.findByShopId(shop.getId());
        int reviewCount = reviews.size();
        double averageRating = 0.0;
        
        if (reviewCount > 0) {
            double totalRating = 0.0;
            for (ShopReview review : reviews) {
                if (review.getRating() != null) {
                    totalRating += review.getRating();
                }
            }
            averageRating = totalRating / reviewCount;
            // 保留一位小数
            averageRating = Math.round(averageRating * 10.0) / 10.0;
        }
        
        dto.setAverageRating(averageRating);
        dto.setReviewCount(reviewCount);
        
        // 从shop_show表获取汉服展示图片
        List<ShopShow> shopShows = shopShowRepository.findByShopIdOrderBySortOrderAsc(shop.getId());
        List<String> hanfuImages = shopShows.stream()
                .map(ShopShow::getImageUrl)
                .collect(Collectors.toList());
        dto.setHanfuImages(hanfuImages);
        
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
