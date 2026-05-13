package com.example.demo.service;

import com.example.demo.entity.ShopShow;
import com.example.demo.repository.ShopShowRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ShopShowService {
    
    @Autowired
    private ShopShowRepository shopShowRepository;
    
    public List<ShopShow> getShopShowsByShopId(Long shopId) {
        return shopShowRepository.findByShopIdOrderBySortOrderAsc(shopId);
    }
    
    public List<String> getImageUrlsByShopId(Long shopId) {
        List<ShopShow> shopShows = shopShowRepository.findByShopIdOrderBySortOrderAsc(shopId);
        return shopShows.stream()
                .map(ShopShow::getImageUrl)
                .collect(Collectors.toList());
    }
    
    public ShopShow createShopShow(ShopShow shopShow) {
        return shopShowRepository.save(shopShow);
    }
    
    public void deleteShopShow(Long id) {
        shopShowRepository.deleteById(id);
    }
    
    public void deleteByShopId(Long shopId) {
        shopShowRepository.deleteByShopId(shopId);
    }
    
    public void saveShopShows(Long shopId, List<String> imageUrls) {
        // 先删除该店铺现有的所有展示图片
        deleteByShopId(shopId);
        
        // 保存新的图片列表
        for (int i = 0; i < imageUrls.size(); i++) {
            String imageUrl = imageUrls.get(i);
            // 处理不同格式的URL，转换为数据库存储格式
            if (imageUrl.startsWith("http://localhost:8082/uploads/shopshow/")) {
                imageUrl = imageUrl.replace("http://localhost:8082/uploads/", "backend/uploads/");
            } else if (imageUrl.startsWith("http")) {
                // 对于其他http链接，保持原样
            } else if (imageUrl.startsWith("/uploads/shopshow/")) {
                imageUrl = imageUrl.replace("/uploads/", "backend/uploads/");
            }
            
            ShopShow shopShow = new ShopShow();
            shopShow.setShopId(shopId);
            shopShow.setImageUrl(imageUrl);
            shopShow.setSortOrder(i + 1);
            shopShowRepository.save(shopShow);
        }
    }
}
