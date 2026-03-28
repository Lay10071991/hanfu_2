package com.example.demo.service;

import com.example.demo.entity.ShopService;
import com.example.demo.repository.ShopServiceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ShopServiceItemService {
    
    @Autowired
    private ShopServiceRepository shopServiceRepository;
    
    public List<ShopService> getServicesByShopId(Long shopId) {
        return shopServiceRepository.findByShopId(shopId);
    }
    
    public ShopService getServiceById(Long id) {
        return shopServiceRepository.findById(id).orElse(null);
    }
    
    public ShopService saveService(ShopService service) {
        return shopServiceRepository.save(service);
    }
    
    public void deleteService(Long id) {
        shopServiceRepository.deleteById(id);
    }
    
    @Transactional
    public void deleteServicesByShopId(Long shopId) {
        shopServiceRepository.deleteByShopId(shopId);
    }
}