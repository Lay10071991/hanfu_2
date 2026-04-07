package com.example.demo.repository;

import com.example.demo.entity.ShopShow;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ShopShowRepository extends JpaRepository<ShopShow, Long> {
    List<ShopShow> findByShopIdOrderBySortOrderAsc(Long shopId);
}
