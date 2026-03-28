package com.example.demo.repository;

import com.example.demo.entity.ShopService;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ShopServiceRepository extends JpaRepository<ShopService, Long> {
    
    List<ShopService> findByShopId(Long shopId);
    
    void deleteByShopId(Long shopId);
}