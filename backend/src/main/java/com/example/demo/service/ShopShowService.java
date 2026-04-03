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
}
